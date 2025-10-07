-- 사용자에게 4개씩 추천학교들을 선택하여 보여주는 쿼리입니다. 
-- 회원가입 후 실행되야 합니다. 

CREATE INDEX universities_idx02 ON universities (university_level DESC, university_name ASC);

SELECT *
FROM (
    SELECT p.*, ROWNUM AS no
    FROM (
        SELECT /*+ INDEX_DESC(universities idx_universities_level_name) */
               university_level, university_name
        FROM universities
        WHERE university_level >= (
            SELECT B.university_level
            FROM users_t A, universities B
            WHERE A.user_id = :user_id
            AND B.university_id = A.user_university_id
        )
        ORDER BY university_level DESC, university_name
    ) p
    WHERE ROWNUM <= (:page * 4)
)
WHERE no >= (:page - 1) * 4 + 1;

-- 비교 대학을 선택할 때 마다 아래 insert문이 실행되어야 한다. (대학id, 유저id)
insert into user_compare_university VALUES (:university_id, :user_id);
