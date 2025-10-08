-- (1) 외부활동, 공모전 게시판 글 수정하기

UPDATE activity_postings
   SET
       activity_type = :activity_type,
       title = :title,
       host_organization = :host_organization,
       recruitment_start_date = :recruitment_start_date,
       recruitment_end_date = :recruitment_end_date,
       eligibility = :eligibility,
       benefits = :benefits,
       details = :details,
       poster_image_url = :poster_image_url,
       application_url = :application_url
 WHERE
       posting_id = :posting_id
   AND user_id = :current_user_id; -- 현재 로그인된 id

