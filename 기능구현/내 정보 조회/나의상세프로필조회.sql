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
SELECT /*+ leading (A B) use_nl(B) index(A) index(B)*/
B.department_name AS 학과명, A.major_type AS 전공_분류
FROM user_departments A, departments B 
where A.user_id = :user_id
and B.department_id = A.department_id

-- 3. 유저 기술 조회
select /*+ index(B) */ 
    B.skill_name as 기술명
from user_skill B
where B.user_id = :user_id;

-- 4. 유저 자격증 조회
-- (1) 인덱스 생성 
create index user_certificates_info_idx01 on user_certificates_info(user_id)

/*
-- (2) 조회 SQL
select /*+ leading(A B) use_nl(B) index(A) index(B)*/ 
    A.issue_date as 취득일, B.certificate_name as 자격증명, 
    NVL(TO_CHAR(A.expiration_date), '기한없음') as 자격만료일, A.certificate_number as 자격증번호,
    NVL(TO_CHAR(A.score), '-') as 자격증점수 
from user_certificates_info A, certificates B 
where A.user_id = :user_id
and B.certificate_id = A.user_certificate_id;
*/

-- (3) 점수 포함한 신규 SQL

SELECT
    uci.user_certificate_id,
    uci.user_id,
    uci.certificate_id,
    uci.issue_date,
    uci.expiration_date,
    uci.certificate_number,
    uci.score AS raw_score,
    c.certificate_name,
    c.certificate_category,
    c.pass_rate,
    CASE c.certificate_category
        WHEN '기능사'   THEN 1
        WHEN '산업기사' THEN 2
        WHEN '기사'     THEN 3
        WHEN '기능장'   THEN 4
        WHEN '기술사'   THEN 5
        ELSE 0
    END
    +
    CASE
        WHEN c.pass_rate < 10 THEN 5
        WHEN c.pass_rate < 30 THEN 4
        WHEN c.pass_rate < 50 THEN 3
        WHEN c.pass_rate < 70 THEN 2
        ELSE 1
    END AS total_score
FROM user_certificates_info uci
JOIN certificates c
  ON c.certificate_id = uci.certificate_id
WHERE uci.user_id = :user_id
ORDER BY uci.issue_date DESC NULLS LAST;

commit;    

    
-- 5. 유저 대/내외 활동 내역 조회
-- (1) 인덱스 생성 
create index user_activities_idx01 on user_activities(user_id);

-- (2) 조회 SQL
create index user_activities_idx01 on user_activities(user_id);
select /*+ index(user_activities)*/ activity_type as 활동_종류, activity_name as 활동명, start_date as 활동시작일,
    end_date as 활동종료일, activity_description as 활동상세내역
from user_activities    
where user_id = :user_id;

-- 6. 
