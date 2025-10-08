-- (1) 게시글 수정
UPDATE team_recruitments
   SET
       posting_id = :posting_id,
       external_activity_url = :external_activity_url,
       title = :title,
       content = :content,
       required_roles = :required_roles,
       required_members = :required_members,
       current_members = :current_members,
       status = :status,
       contact_info = :contact_info
 WHERE
       recruitment_id = :recruitment_id      -- 수정할 게시글 ID
   AND author_user_id = :current_user_id;  -- 글 작성자 본인 확인
