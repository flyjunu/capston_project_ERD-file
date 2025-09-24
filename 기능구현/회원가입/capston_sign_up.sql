-- 1. 회원 가입 기능구현(아래 6개의 SQL은 동시에 실행되어야함. 
-- 아래코드는 모두 시퀸스를 만든 후에야 정상작동 함으로 이를 유의할 것.

BEGIN
-- (1) user_t 테이블에 기본정보 삽입
INSERT INTO users_t (
    user_id, user_name, user_email, user_password, user_age, user_gender,
    user_state, user_grade, user_university_id, user_roadmap,
    user_credit_avg, user_major_credits_avg
) VALUES (
    users_seq.NEXTVAL,
    :user_name, :user_email, :user_password, :user_age, :user_gender,
    :user_state, :user_grade, :user_university_id, :user_roadmap,
    :user_credit_avg, :user_major_credits_avg
);

-- (2) 유저 희망 직업 테이블에 데이터 삽입
INSERT INTO user_job_preferences(user_id, hope_job_id) VALUES (users_seq.CURRVAL, :hope_job_id);

-- (3) 유저 자격증 테이블에 데이터 삽입
INSERT INTO user_certificates (user_certificate_id, user_id, certificate_id, issue_date, expiration_date, certificate_number, score)
    VALUES (user_cert_seq.NEXTVAL, users_seq.CURRVAL , :cert_id, :issue_date, :exp_date, :cert_num, :cert_score);

-- (4) 유저 학과 테이블에 데이터 삽입
INSERT INTO user_departments (user_id, department_id, major_type) VALUES (users_seq.CURRVAL, :dept_id, :major_type);

-- (5) 유저 기술 테이블에 데이터 삽입
INSERT INTO user_skill (user_id, skill_name) VALUES (users_seq.CURRVAL, :skill_name);

-- (6) 유저 대/내외 활동 내역에 데이터 삽입
INSERT INTO user_activities ( activity_id, user_id, activity_type, activity_name, start_date, end_date, activity_description ) 
VALUES (activities_seq.NEXTVAL, users_seq.CURRVAL, :activity_type, :activity_name, :start_date, :end_date, :activity_description );

commit; 

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

