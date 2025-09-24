-- 메인 화면에서 표기될 간략한 프로필 학과정보 추가할 것.
-- 클릭시 세부 프로필 확인가능
-- 추천학과 테이블에서 가져오도록 완전히 갈아 엎어야합니다. 수정 필수

SELECT
    A.user_name as 유저명,
    A.user_age as 나이,
    A.user_gender as 성별,
    A.user_state as 유저상태_분류,
    NVL(TO_CHAR(A.user_grade), '없음') as 유저_학년,
    B.university_name as 대학명
FROM users_t A, universities B
WHERE A.user_id = :user_id
AND A.user_university_id = B.university_id; 
