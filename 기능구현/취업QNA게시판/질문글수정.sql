-- (1) 질문글수정
UPDATE qna_questions
   SET title = :title,
       question_content = :question_content
 WHERE question_id = :question_id
   AND user_id = :current_user_id;
