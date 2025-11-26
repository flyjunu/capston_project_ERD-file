-- 1.유저 테이블 생성
create table users_t (user_id number(20) primary key,
                      user_name varchar2(50) not null,
                      user_email varchar2(255) unique not null ,
                      user_password varchar2(255) not null,
                      user_birthday DATE,
                      user_gender char(3),
                      user_state varchar2(20) default '취준생' not null,
                      user_grade number(1),
                      user_university_id number(20), 
                      user_roadmap CLOB, -- 유저 로드맵 또는 상세 소개
                      user_credit_avg number(15,2), -- 평균 학점
                      user_major_credits_avg number(15,2), -- 전공 평균 학점
                      phone_number varchar2(13) unique not null, -- 휴대폰번호
                      created_at TIMESTAMP default SYSTIMESTAMP, -- 가입일시
                      last_login_at TIMESTAMP, -- 마지막 로그인
                      CONSTRAINT chk_gender_01 CHECK (user_gender IN ('남', '여')),
                      CONSTRAINT chk_state_01 CHECK (user_state IN ('대학생', '졸업자', '취준생'))); 

-- 2 인증 테이블 생성(회원 가입시 이메일인증, 비밀번호 변경 시 사용)
CREATE TABLE auth_codes (
    auth_id         NUMBER(20) PRIMARY KEY,             -- 인증 고유 ID
    user_email      VARCHAR2(255) NOT NULL,             -- 사용자 이메일 (users_t와 연결)
    auth_code       VARCHAR2(6) NOT NULL,             -- 인증 코드 또는 토큰
    auth_purpose    VARCHAR2(30) NOT NULL,              -- 인증 목적 (예: EMAIL_VERIFICATION, PASSWORD_RESET)
    is_used         NUMBER(1) DEFAULT 0 NOT NULL,       -- 코드 사용 여부 (0: 미사용, 1: 사용됨)
    created_at      TIMESTAMP DEFAULT SYSTIMESTAMP,     -- 코드 생성 시간
    expires_at      TIMESTAMP NOT NULL,                 -- 코드 만료 시간
    CONSTRAINT chk_auth_purpose CHECK (auth_purpose IN ('EMAIL_VERIFICATION', 'PASSWORD_RESET')),
    CONSTRAINT chk_is_used CHECK (is_used IN (0, 1))
);

CREATE SEQUENCE seq_auth_codes;

-- 3. 회사 테이블 생성
create table company (
  company_id number(20) primary key, --회사 id
  company_name VARCHAR2(255) NOT NULL -- 회사 명
 );

-- 4. 회사가 모집한적 있는 구인 직종들(회사 우대사항들에서 사용할 것임)
CREATE TABLE company_job_role (
    company_id NUMBER(20) NOT NULL,
    job_id NUMBER(5) NOT NULL,
    CONSTRAINT pk_company_job_role PRIMARY KEY (company_id, job_id),
    CONSTRAINT fk_cjr_company FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE,
    CONSTRAINT fk_cjr_job FOREIGN KEY (job_id) REFERENCES job_categories(job_id) ON DELETE CASCADE
);

  
-- 5. 유저 희망 회사 테이블 생성
create table user_hope_company (
  user_id number(20) not null,
  hope_company_id number(20) not null
  company_name VARCHAR2(255) NOT NULL 
  PRIMARY KEY (user_id, hope_company_id)
  FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE,
  FOREIGN KEY (hope_company_id) REFERENCES company(company_id) ON DELETE CASCADE
  );
  


-- 6. 직종 종류 테이블 생성
CREATE TABLE job_categories (
    job_id NUMBER(5) PRIMARY KEY, --직업 이름
    parent_job_id NUMBER(5), -- 상위 직업 이름
    job_name VARCHAR2(50) UNIQUE NOT NULL
);

-- 7. 유저 희망직종 생성
CREATE TABLE user_job_preferences (
    user_id NUMBER(20),
    hope_job_id NUMBER(5), 
    PRIMARY KEY (user_id, hope_job_id),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE,
    FOREIGN KEY (hope_job_id) REFERENCES job_categories(job_id) ON DELETE CASCADE
);

-- 8. 자격증 종류 테이블 생성(모든 종류의 레벨관련 컬럼들 삭제)
CREATE TABLE certificates (
    certificate_id INT PRIMARY KEY,
    certificate_name VARCHAR(100) NOT NULL, --자격증 이름
    issuing_authority VARCHAR(100) NOT NULL, -- 자격증 발급 기관
    certificate_category VARCHAR(50), -- 자격증 분류(모두국가기술자격증:기능장, 기술사, 기사, 산업기사, 기능사)
    pass_rate NUMBER(4, 1)
  );

-- 9. 유저 자격증 목록 테이블 생성
CREATE TABLE user_certificates_info (
    user_certificate_id INT PRIMARY KEY, -- 유저 자격증 구분용도(like: 시퀸스)
    user_id INT NOT NULL, -- 유저 id
    certificate_id INT NOT NULL, -- 자격증 id
    issue_date DATE NOT NULL, -- 자격 취득일
    expiration_date DATE, -- 자격 만료일
    certificate_number VARCHAR(100), -- 자격증 번호
    score VARCHAR(20), -- 토익 같은 점수 있는 자격증 용도
    FOREIGN KEY (user_id) REFERENCES users_t(user_id),
    FOREIGN KEY (certificate_id) REFERENCES certificates(certificate_id)
);


-- 10. 대학 정보 테이블 
CREATE TABLE universities (
    university_id         NUMBER(20) PRIMARY KEY,          -- 학교코드
    university_name         VARCHAR2(100) NOT NULL,          -- 학교명
    campus_type         VARCHAR2(10),                    -- 본분교 구분 (예: 본교, 분교)
    academic_system     VARCHAR2(30),                    -- 학제 (예: 대학교, 전문대학)
    region              VARCHAR2(50),                    -- 지역 (예: 서울, 경기)
    establishment_type  VARCHAR2(20),                    -- 설립구분 (예: 국립, 사립)
    university_level        NUMBER                           -- 학교수준
);

-- 11. 학과 종류 테이블 생성
CREATE TABLE departments(
    department_id number(20) primary key,
    department_name varchar2(100) not null 
);

-- 12. 유저 학과 테이블 생성
CREATE TABLE user_departments (
    user_id          NUMBER(20) NOT NULL,
    department_id    NUMBER(20) NOT NULL,
    major_type       VARCHAR2(20) DEFAULT '주전공' NOT NULL, -- 전공 종류(복수전공, 부전공 등) 
    CONSTRAINT pk_user_departments PRIMARY KEY (user_id, department_id),
    CONSTRAINT fk_ud_user FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ud_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
  );
alter table user_departments add check (major_type in ('주전공', '부전공', '복수전공', '연계전공', '융합전공', '마이크로디그리'));


-- 13. 새로 기술 테이블 생성(ㅠㅠ)
CREATE TABLE skill (
    skill_id NUMBER(20) primary key,
    skill_name varchar(100) NOT NULL
);

-- 14. 유저 기술 테이블 생성(수정 완료)
CREATE TABLE user_skill (
    user_id NUMBER(20) NOT NULL,
    skill_name varchar(100) NOT NULL,
    CONSTRAINT pk_user_skill PRIMARY KEY (user_id, skill_name),
    CONSTRAINT fk_user_skill_user FOREIGN KEY (user_id) REFERENCES users_t(user_id)
);

-- 15. 유저 대/내외 활동 내역 테이블
CREATE TABLE user_activities (
    activity_id NUMBER(20) primary key,
    user_id NUMBER(20) not null,
    activity_type varchar2(20) not null, -- (동아리, 공모전, 인턴십, 봉사활동, 알바 등)
    activity_name varchar2(50) not null, 
    start_date date not null,
    end_date date not null,
    activity_description varchar2(500),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE
);

-- 16. 대/내외 활동 게시판 테이블
CREATE TABLE activity_postings (
    posting_id NUMBER(20) PRIMARY KEY, -- 공고의 고유 ID
    user_id NUMBER(20) NOT NULL, -- 작성자 표기
    activity_type VARCHAR2(30) NOT NULL, -- '공모전', '대외활동', '인턴', '봉사활동' 등
    title VARCHAR2(255) NOT NULL, -- 공고 제목
    host_organization VARCHAR2(100) NOT NULL, -- 주최 기관 (예: '삼성전자', '코이카')
    recruitment_start_date DATE NOT NULL, -- 모집 시작일
    recruitment_end_date DATE NOT NULL, -- 모집 마감일
    eligibility VARCHAR2(500), -- 지원 자격 (예: '대학교 3, 4학년 재/휴학생')
    benefits VARCHAR2(500), -- 활동 혜택 (예: '활동비 지급, 우수자 인턴 기회 제공')
    details CLOB, -- 공고 상세 내용 (긴 텍스트)
    poster_image_url VARCHAR2(1000), -- 포스터 이미지 URL
    application_url VARCHAR2(1000), -- 지원 링크
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP, -- 공고 등록일
    view_count number(20) DEFAULT 0,  -- 조회수
    CONSTRAINT fk_ap_user FOREIGN KEY (user_id) REFERENCES users_t(user_id)
);

-- 17. 팀원 모집 게시판 테이블 생성
CREATE TABLE team_recruitments (
    recruitment_id NUMBER(20) PRIMARY KEY, -- 팀원 모집 게시글의 고유 ID
    posting_id NUMBER(20),  -- 내부공고
    external_activity_url VARCHAR2(1000), -- 외부 공고 
    author_user_id NUMBER(20) NOT NULL, -- 글 작성자의 user_id
    title VARCHAR2(255) NOT NULL, -- 게시글 제목
    content CLOB NOT NULL, -- 상세 모집 내용
    required_roles VARCHAR2(200), -- 필요한 역할/분야
    required_members NUMBER(2) NOT NULL, -- 모집할 인원 수
    current_members NUMBER(2) DEFAULT 1 NOT NULL, -- 현재 팀 인원 수
    status VARCHAR2(20) DEFAULT '모집중' NOT NULL, -- '모집중', '모집완료'
    contact_info VARCHAR2(200), -- 연락 방법
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP, -- 글 작성일
    CONSTRAINT fk_tr_user FOREIGN KEY (author_user_id) REFERENCES users_t(user_id),
    CONSTRAINT chk_tr_status CHECK (status IN ('모집중', '모집완료'))
);

-- 18. 팀원모집 지원자 목록
CREATE TABLE team_applications (
    application_id NUMBER(20) PRIMARY KEY, -- 지원 신청의 고유 ID
    recruitment_id NUMBER(20) NOT NULL, -- 지원하려는 팀 모집 게시글 ID
    applicant_user_id NUMBER(20) NOT NULL, -- 지원자의 user_id
    application_message VARCHAR2(500), -- 지원 시 남기는 메시지 (자기소개 등)
    status VARCHAR2(20) DEFAULT '대기중' NOT NULL, -- '대기중', '수락됨', '거절됨'
    applied_at TIMESTAMP DEFAULT SYSTIMESTAMP, -- 지원 날짜
    CONSTRAINT fk_ta_recruitment FOREIGN KEY (recruitment_id) REFERENCES team_recruitments(recruitment_id) ON DELETE CASCADE,
    CONSTRAINT fk_ta_user FOREIGN KEY (applicant_user_id) REFERENCES users_t(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_ta_status CHECK (status IN ('대기중', '수락됨', '거절됨')),
    CONSTRAINT uq_application UNIQUE (recruitment_id, applicant_user_id)
);

-- 19. 결성된 팀원 테이블
CREATE TABLE team_members (
    recruitment_id NUMBER(20) NOT NULL, -- 팀 모집 게시글 ID (team_recruitments 참조)
    user_id NUMBER(20) NOT NULL, -- 팀에 속한 사용자의 ID (users_t 참조)
    team_role VARCHAR2(50), -- 팀 내에서 맡은 역할 (예: '팀장', '개발자', '디자이너')
    join_date TIMESTAMP DEFAULT SYSTIMESTAMP, -- 팀 합류 날짜
    CONSTRAINT pk_team_members PRIMARY KEY (recruitment_id, user_id),
    CONSTRAINT fk_tm_recruitment FOREIGN KEY (recruitment_id) REFERENCES team_recruitments(recruitment_id) ON DELETE CASCADE,
    CONSTRAINT fk_tm_user FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE
);

-- 20. 공지사항 게시판 테이블
CREATE TABLE notices (
    notice_id NUMBER(20) PRIMARY KEY,
    user_id NUMBER(20) NOT NULL, -- 작성자 표기용도
    notice_title VARCHAR2(100) NOT NULL,
    notice_content CLOB,
    upload_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    view_count NUMBER(20) DEFAULT 0,
    CONSTRAINT fk_notices_user FOREIGN KEY (user_id) REFERENCES users_t(user_id)
);

-- 21. 직종별 게시판 테이블 
CREATE TABLE job_community_board (
    post_id NUMBER(20) PRIMARY KEY,
    job_id NUMBER(5) NOT NULL,
    user_id NUMBER(20) NOT NULL,
    post_title VARCHAR2(200) NOT NULL,
    post_content CLOB,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    view_count NUMBER(10) DEFAULT 0,
    like_count NUMBER(10) DEFAULT 0,
    FOREIGN KEY (job_id) REFERENCES job_categories(job_id),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id)
);

-- 22. QnA 게시판(질문) 테이블 생성
CREATE TABLE qna_questions (
    question_id NUMBER(20) PRIMARY KEY,
    user_id NUMBER(20) NOT NULL,
    title VARCHAR2(200) NOT NULL,
    question_content CLOB,
    view_count NUMBER(10) DEFAULT 0,
    question_like_count NUMBER(10) DEFAULT 0,
    status VARCHAR2(20) DEFAULT '답변 대기',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users_t(user_id),
    CONSTRAINT chk_question_status CHECK (status IN ('답변 대기', '답변 완료'))
);

-- 23. QnA 게시판(답변) 테이블 생성
CREATE TABLE qna_answers (
    answer_id NUMBER(20) PRIMARY KEY,
    question_id NUMBER(20) NOT NULL,
    user_id NUMBER(20) NOT NULL,
    answer_content CLOB,
    answer_like_count NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES qna_questions(question_id),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id)
   
);

-- 24. 유저 비교 대학선택 저장 테이블
create table user_compare_university (
    university_id number(20) not null,  
    user_id number(20) not null,
    CONSTRAINT pk_user_compare_university PRIMARY KEY (user_id, university_id),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id)
    );

-- 25. 유저 프로핑 저장 테이블
CREATE TABLE user_profiles (
    user_id NUMBER(20) PRIMARY KEY, 
    profile_image_url VARCHAR2(1000),
    profile_link VARCHAR2(255) UNIQUE,
    profile_introduction VARCHAR2(500),
    FOREIGN KEY (user_id) REFERENCES users_t(user_id) ON DELETE CASCADE
);

-- 26. 회사 요구기술 테이블
CREATE TABLE company_skill (
    company_id NUMBER(20) NOT NULL,
    job_id NUMBER(5) NOT NULL,
    skill_name VARCHAR2(100) NOT NULL,
    skill_type VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_company_skill PRIMARY KEY (company_id, job_id, skill_name),
    CONSTRAINT fk_skill_to_role FOREIGN KEY (company_id, job_id) REFERENCES company_job_role(company_id, job_id) ON DELETE CASCADE,
    CONSTRAINT chk_skill_type CHECK (skill_type IN ('필수', '우대')) 
);

-- 27. 회사 우대 자격증 테이블
CREATE TABLE company_certificate (
    company_id NUMBER(20) NOT NULL,
    job_id NUMBER(5) NOT NULL,
    certificate_id INT NOT NULL,
    CONSTRAINT pk_company_certificate PRIMARY KEY (company_id, job_id, certificate_id),
    CONSTRAINT fk_cert_to_role FOREIGN KEY (company_id, job_id) REFERENCES company_job_role(company_id, job_id) ON DELETE CASCADE,
    CONSTRAINT fk_comp_cert_certificate FOREIGN KEY (certificate_id) REFERENCES certificates(certificate_id)
);

-- 28. 회사 우대 학과 테이블
CREATE TABLE company_department (
    company_id NUMBER(20) NOT NULL,
    job_id NUMBER(5) NOT NULL,
    department_id NUMBER(20) NOT NULL,
    CONSTRAINT pk_company_department PRIMARY KEY (company_id, job_id, department_id),
    CONSTRAINT fk_dept_to_role FOREIGN KEY (company_id, job_id) REFERENCES company_job_role(company_id, job_id) ON DELETE CASCADE,
    CONSTRAINT fk_comp_dept_department FOREIGN KEY (department_id) REFERENCES departments(department_id) 
);





















