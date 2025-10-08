DELETE FROM team_applications
      WHERE recruitment_id = :recruitment_id         -- 취소하려는 게시글 ID
        AND applicant_user_id = :current_user_id;  -- 지원자 본인 확인
