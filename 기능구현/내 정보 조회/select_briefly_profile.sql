-- 아래 테이블에서, 학과, 기술, 자격증, 대/내외 활동을 전부 조회 가능해야한다. 
-- 1. 유저 테이블 정보 및 학교 정보 조회
SELECT /*+ leading(A B) index(A) index(B) use_nl(B)*/
    A.user_name as 유저명,
    A.user_email as 이메일,
    A.user_age as 나이,
    A.user_gender as 성별,
    A.user_state as 유저상태_분류,
    NVL(TO_CHAR(A.user_grade), '없음') as 유저_학년,
    B.university_name as 대학명,
    A.user_roadmap as 로드맵,
    NVL(TO_CHAR(A.user_credit_avg), '미등록') as 전체평균학점,
    NVL(TO_CHAR(A.user_major_credits_avg), '미등록') as 전공평균학점
FROM users_t A, universities B
WHERE A.user_id = :user_id
AND B.university_id = A.user_university_id;

-- 2. 유저 학과명 및 전공분류 조회
-- (1) 조회를 위한 인덱스 생성
create index user_departments_idx01 on user_departments(user_id);
-- (2) 조회 SQL 
SELECT /*+ leading (A B C) use_nl(B) use_nl(C) index(A) index(B) index(C)*/
C.department_name AS 학과명, B.major_type AS 전공_분류
FROM users_t A, user_departments B, departments C 
WHERE A.user_id = :user_id
and B.user_id = A.user_id
and C.department_id = B.department_id
;  

-- (3) 유저 기술 조회



