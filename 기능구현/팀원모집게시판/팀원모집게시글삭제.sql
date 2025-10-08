DELETE FROM team_recruitments
      WHERE recruitment_id = :recruitment_id      -- 삭제할 게시글 ID
        AND author_user_id = :current_user_id;  -- 글 작성자 본인 확인
