-- 이메일 인증 생성기
아래 파이썬 코드를 우리 프로젝트에 맞게 변환해야한다. 


import smtplib
import random
import os
import hashlib
import oracledb
from email.message import EmailMessage
from datetime import datetime, timedelta


  
# --- 1. ⚠️ 사용자 설정 (민감 정보) ---
# (보안을 위해 실제로는 .env 파일이나 환경 변수 사용 권장)

# Oracle DB 연결 정보
DB_USER = "your_db_username"
DB_PASSWORD = "your_db_password"
# 예: "localhost:1521/XEPDB1" 또는 Oracle Cloud의 TNS 정보
DB_DSN = "your_db_host:port/service_name" 

# 이메일 발송자 정보 (Gmail 앱 비밀번호)
SENDER_EMAIL = "your_email@gmail.com"
SENDER_PASSWORD = "your_app_password"
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 465

# --- 2. 이메일 발송 헬퍼 함수 ---
def send_auth_email(to_email, auth_code):
    """지정된 이메일로 인증 코드를 발송합니다."""
    msg = EmailMessage()
    msg['Subject'] = "[회원가입] 인증번호가 도착했습니다."
    msg['From'] = SENDER_EMAIL
    msg['To'] = to_email
    msg.set_content(f"요청하신 회원가입 인증번호는 [ {auth_code} ] 입니다.\n5분 이내에 입력해주세요.")
    
    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, SMTP_PORT) as server:
            server.login(SENDER_EMAIL, SENDER_PASSWORD)
            server.send_message(msg)
        return True, "이메일 전송 성공"
    except Exception as e:
        print(f"[이메일 발송 오류] {e}")
        return False, f"이메일 전송 실패: {e}"

# --- 3. [1단계] 인증번호 요청 함수 ---
def request_verification_code(email_to_verify):
    """
    새로운 인증 코드를 생성하고 DB에 저장한 뒤, 이메일로 발송합니다.
    """
    connection = None
    try:
        connection = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
        cursor = connection.cursor()

        # 1. (선택적) 이미 가입된 이메일인지 확인
        cursor.execute("SELECT user_id FROM users_t WHERE user_email = :email", email=email_to_verify)
        if cursor.fetchone():
            return False, "이미 가입된 이메일입니다."

        # 2. 기존에 만료되지 않은 'EMAIL_VERIFICATION' 코드가 있다면 무효화(is_used = 1)
        #    (한 번에 하나의 유효한 인증번호만 갖도록 함)
        cursor.execute("""
            UPDATE auth_codes 
            SET is_used = 1 
            WHERE user_email = :email 
              AND auth_purpose = 'EMAIL_VERIFICATION' 
              AND is_used = 0
        """, email=email_to_verify)

        # 3. 새로운 6자리 인증 코드 생성
        auth_code = str(random.randint(100000, 999999))
        
        # 4. DB에 새 인증 코드 저장 (auth_id_seq 시퀀스 사용, 5분 뒤 만료)
        sql_insert = """
            INSERT INTO auth_codes (
                auth_id, user_email, auth_code, auth_purpose, expires_at
            ) 
            VALUES (
                auth_id_seq.NEXTVAL, 
                :email, 
                :code, 
                'EMAIL_VERIFICATION', 
                SYSTIMESTAMP + INTERVAL '5' MINUTE
            )
        """
        cursor.execute(sql_insert, email=email_to_verify, code=auth_code)
        
        # 5. DB 변경사항 커밋
        connection.commit()
        
        # 6. 이메일 발송
        email_sent, email_msg = send_auth_email(email_to_verify, auth_code)
        
        if email_sent:
            return True, "인증번호가 성공적으로 발송되었습니다."
        else:
            # (롤백 처리 - 이메일 발송 실패 시 DB 저장도 취소)
            connection.rollback()
            return False, email_msg

    except oracledb.DatabaseError as e:
        if connection:
            connection.rollback()
        print(f"[DB 오류] {e}")
        return False, "데이터베이스 오류가 발생했습니다."
    except Exception as e:
        if connection:
            connection.rollback()
        print(f"[기타 오류] {e}")
        return False, "알 수 없는 오류가 발생했습니다."
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# --- 4. [2단계] 회원가입 완료 (인증번호 검증) 함수 ---
def register_user(email, password, submitted_code):
    """
    제출된 인증 코드를 검증하고, 성공 시 회원가입을 완료(INSERT)합니다.
    """
    connection = None
    try:
        connection = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
        cursor = connection.cursor()

        # 1. 유효한 인증 코드가 있는지 확인
        # (이메일, 코드, 목적, 사용안함, 만료안됨 5가지 조건 동시 체크)
        sql_select = """
            SELECT auth_id 
            FROM auth_codes
            WHERE user_email = :email
              AND auth_code = :code
              AND auth_purpose = 'EMAIL_VERIFICATION'
              AND is_used = 0
              AND expires_at > SYSTIMESTAMP
        """
        cursor.execute(sql_select, email=email, code=submitted_code)
        result = cursor.fetchone()

        if result is None:
            # 유효한 코드가 없음 (틀렸거나, 만료되었거나, 이미 사용됨)
            return False, "인증번호가 유효하지 않거나 만료되었습니다."

        # 2. 인증 성공! (트랜잭션 시작)
        
        # 2-1. 인증 코드 '사용됨'으로 업데이트 (is_used = 1)
        auth_id_to_use = result[0]
        cursor.execute("UPDATE auth_codes SET is_used = 1 WHERE auth_id = :id", id=auth_id_to_use)

        # 2-2. (경고!) 실제로는 bcrypt 사용. 여기서는 예시로 sha256 사용
        hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()
        
        # 2-3. users_t 테이블에 실제 회원 정보 INSERT (user_id_seq 시퀀스 사용)
        sql_insert_user = """
            INSERT INTO users_t (user_id, user_email, password)
            VALUES (user_id_seq.NEXTVAL, :email, :pass)
        """
        cursor.execute(sql_insert_user, email=email, pass=hashed_password)
        
        # 3. 모든 작업이 성공했으므로 트랜잭션 커밋
        connection.commit()
        
        return True, "회원가입이 성공적으로 완료되었습니다."

    except oracledb.IntegrityError:
        # (예: users_t의 이메일 UNIQUE 제약 조건 위반)
        if connection:
            connection.rollback()
        return False, "이미 등록된 이메일 주소입니다. (동시성 오류)"
    except oracledb.DatabaseError as e:
        if connection:
            connection.rollback()
        print(f"[DB 오류] {e}")
        return False, "데이터베이스 오류가 발생했습니다."
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# --- 5. 테스트 실행 ---
if __name__ == "__main__":
    
    # [시나리오 1: 인증번호 요청]
    print("--- 1. 인증번호 요청 테스트 ---")
    user_input_email = "test_user@example.com" # (테스트할 실제 이메일 주소 입력)
    success, message = request_verification_code(user_input_email)
    print(f"결과: {success} / 메시지: {message}\n")

    if success:
        # [시나리오 2: 회원가입 시도]
        print("--- 2. 회원가입 시도 테스트 ---")
        # (이메일로 받은 인증번호를 여기에 입력)
        user_input_code = input(f"{user_input_email}로 받은 6자리 인증번호를 입력하세요: ")
        user_input_password = "my_secure_password123"
        
        reg_success, reg_message = register_user(
            email=user_input_email,
            password=user_input_password,
            submitted_code=user_input_code
        )
        print(f"결과: {reg_success} / 메시지: {reg_message}")
