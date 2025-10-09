-- 1. 조회수 1 증가
UPDATE qna_questions
   SET view_count = view_count + 1
 WHERE question_id = :question_id;

-- 2. 질문 상세 정보와 모든 답변 함께 가져오기(따로만든 이유. 답변이 없을 수 있어서.)
-- (질문 정보)
SELECT * 
   FROM qna_questions 
   WHERE question_id = :question_id;
-- (답변 목록)
SELECT /*+ leading(a u) index(a) use_nl(u) index(u) */
   a.answer_id,a.answer_content, u.user_name AS answerer_name, a.created_at
FROM qna_answers a, users_t u
WHERE a.user_id = u.user_id
and a.question_id = :question_id
ORDER BY a.created_at ASC;

