SELECT
    tr.recruitment_id,
    tr.title,
    u.user_name AS author_name, -- 작성자 이름
    tr.required_roles,
    tr.required_members,
    tr.current_members,
    tr.status,
    tr.created_at
FROM
    team_recruitments tr, users_t u 
WHERE
    tr.author_user_id = u.user_id
    tr.status = '모집중'
ORDER BY
    tr.created_at DESC;
