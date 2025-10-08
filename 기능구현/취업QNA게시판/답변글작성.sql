BEGIN
    -- (1) 답변 테이블에 새로운 답변 삽입
    INSERT INTO qna_answers (answer_id, question_id, user_id, answer_content)
    VALUES (qna_answers_seq.NEXTVAL, :question_id, :current_user_id, :answer_content);

    -- (2) 질문 테이블의 상태를 '답변 완료'로 변경
    UPDATE qna_questions
       SET status = '답변 완료'
     WHERE question_id = :question_id;
     
    -- 애플리케이션에서 COMMIT
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
