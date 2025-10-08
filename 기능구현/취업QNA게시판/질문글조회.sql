-- 1. 조회수 1 증가
UPDATE qna_questions
   SET view_count = view_count + 1
 WHERE question_id = :question_id;

-- 2. 질문 상세 정보와 모든 답변 함께 가져오기
-- (질문 정보)
SELECT * FROM qna_questions WHERE question_id = :question_id;
-- (답변 목록)
SELECT
    a.answer_id,
    a.answer_content,
    u.user_name AS answerer_name,
    a.created_at
FROM
    qna_answers a
JOIN
    users_t u ON a.user_id = u.user_id
WHERE
    a.question_id = :question_id
ORDER BY
    a.created_at ASC;
