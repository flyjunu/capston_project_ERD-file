DELETE FROM team_members
      WHERE recruitment_id = :recruitment_id
        AND user_id = :member_to_remove_id;
