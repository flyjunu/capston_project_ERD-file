-- 1. 공모전 정보 조회
SELECT contest_count as 공모전참여수,
       ROUND(CUME_DIST() OVER (ORDER BY contest_count DESC) * 100, 1) AS 백분율
FROM (SELECT u.user_id,NVL(c.cnt, 0) AS contest_count
  FROM users_t u,
       (SELECT user_id, COUNT(*) AS cnt
        FROM user_activities
        WHERE activity_type = '공모전'
        GROUP BY user_id) c
  WHERE u.user_id = c.user_id(+)
) x
WHERE x.user_id = :user_id;
