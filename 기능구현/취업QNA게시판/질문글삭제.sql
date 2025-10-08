DELETE FROM qna_questions
      WHERE question_id = :question_id
        AND user_id = :current_user_id;
