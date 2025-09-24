-- 아래 테이블에서, 학과, 기술, 자격증, 대/내외 활동을 전부 조회 가능해야한다. 

SELECT
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
AND A.user_university_id = B.university_id; 
