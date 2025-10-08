DELETE FROM job_community_board
      WHERE post_id = :post_id
        AND user_id = :current_user_id;
