SELECT
    tm.user_id,
    u.user_name,
    u.user_grade,
    tm.team_role,
    tm.join_date
FROM
    team_members tm, users_t u
WHERE tm.user_id = u.user_id
and  tm.recruitment_id = :recruitment_id; 
