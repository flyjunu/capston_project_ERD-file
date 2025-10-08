UPDATE job_community_board
   SET
       post_title = :post_title,
       post_content = :post_content
 WHERE
       post_id = :post_id
   AND user_id = :current_user_id; 
