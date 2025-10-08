-- (1) 질문글 작성
INSERT INTO qna_questions (question_id, user_id, title, question_content)
VALUES (qna_questions_seq.NEXTVAL, :current_user_id, :title, :question_content);

