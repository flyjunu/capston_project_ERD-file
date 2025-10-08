DELETE FROM qna_answers
      WHERE answer_id = :answer_id
        AND user_id = :current_user_id;
