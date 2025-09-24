-- 3. 비밀번호 변경 기능 구현
-- (1) 기존 유저 비밀번호 가져오기.
SELECT user_password FROM users_t WHERE user_id = :user_id;

-- (2) 비밀번호 변경하기.
PDATE users_t SET user_password = :new_user_password WHERE user_id = :user_id;
