SELECT
    jcb.post_id,
    jcb.post_title,
    u.user_name,
    jcb.created_at,
    jcb.view_count,
    jcb.like_count
FROM
    job_community_board jcb, users_t u
WHERE jcb.job_id = :job_id 
and jcb.user_id = u.user_id
ORDER BY jcb.created_at DESC;
