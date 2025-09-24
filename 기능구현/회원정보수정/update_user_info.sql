-- 2. 회원 정보 수정 기능 구현
-- 비밀번호 변경 기능은 보안상 따로 만들었습니다. 
-- (1) 기존 회원 정보를 가져와서 뷰에 표기
SELECT
    user_id, 
    user_name, 
    user_email,
    user_age, 
    user_gender,
    user_state, 
    user_grade, 
    user_university_id, 
    user_roadmap,
    user_credit_avg, 
    user_major_credits_avg
FROM
    users_t
WHERE
    user_id = :user_id; -- 현재 로그인한 사용자의 ID

-- (2) 유저 정보 update하기.
UPDATE
    users_t
SET
    user_name = :user_name,
    user_email = :user_email,
    user_age = :user_age,
    user_gender = :user_gender,
    user_state = :user_state,
    user_grade = :user_grade,
    user_university_id = :user_university_id,
    user_roadmap = :user_roadmap,
    user_credit_avg = :user_credit_avg,
    user_major_credits_avg = :user_major_credits_avg
WHERE
    user_id = :user_id;


