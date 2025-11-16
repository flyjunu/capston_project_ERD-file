-- 1. 공모전 백분율 조회
SELECT contest_count as 공모전참여수,
       ROUND(CUME_DIST() OVER (ORDER BY contest_count DESC) * 100, 1) AS 백분율
FROM (SELECT u.user_id,NVL(c.cnt, 0) AS contest_count
      FROM users_t u, (SELECT user_id, COUNT(*) AS cnt
                       FROM user_activities
                       WHERE activity_type = '공모전'
                       GROUP BY user_id) c
      WHERE u.user_id = c.user_id(+)) x 
WHERE x.user_id = :user_id;

-- 2. 자격증 백분율 조회
SELECT cert_total_score as 자격증 개수,
       ROUND(CUME_DIST() OVER (ORDER BY cert_total_score DESC) * 100, 1) AS 자격증점수
FROM (SELECT u.user_id, NVL(s.total_score, 0) AS cert_total_score
      FROM users_t u, (SELECT uci.user_id, SUM((CASE c.certificate_category
                                                WHEN '기능사'   THEN 1
                                                WHEN '산업기사' THEN 2
                                                WHEN '기사'     THEN 3
                                                WHEN '기능장'   THEN 4
                                                WHEN '기술사'   THEN 5
                                                ELSE 0 END) + (CASE
                                                               WHEN c.pass_rate < 10 THEN 5
                                                               WHEN c.pass_rate < 30 THEN 4
                                                               WHEN c.pass_rate < 50 THEN 3
                                                               WHEN c.pass_rate < 70 THEN 2
                                                               ELSE 1 END) AS total_score
                      FROM user_certificates_info uci, certificates c
                      WHERE uci.certificate_id = c.certificate_id
                      AND uci.certificate_id <> 576
                      GROUP BY uci.user_id) s
       WHERE u.user_id = s.user_id(+)) x
WHERE x.user_id = :user_id;

-- 3. 인턴경험 백분율 조회
SELECT intern_count as 인턴횟수,
       ROUND(CUME_DIST() OVER (ORDER BY intern_count DESC) * 100, 1) AS 백분율
FROM (SELECT u.user_id, NVL(i.cnt, 0) AS intern_count
      FROM users_t u, (SELECT ua.user_id, COUNT(*) AS cnt
                       FROM user_activities ua
                       WHERE ua.activity_type IN ('인턴', '인턴십')
                       GROUP BY ua.user_id) i
      WHERE u.user_id = i.user_id(+)) x
WHERE x.user_id = :user_id;

-- 4. 활동 경험 백분율 조회 (인턴 뺴고 나머지 활동) 
SELECT activity_count as 활동횟수, 
       ROUND(CUME_DIST() OVER (ORDER BY acticity_count DESC) * 100, 1) AS 백분율
FROM (SELECT u.user_id, NVL(i.cnt, 0) AS activity_count
      FROM users_t u, (SELECT ua.user_id, COUNT(*) AS cnt
                       FROM user_activities ua
                       WHERE ua.activity_type NOT IN ('인턴', '인턴십')
                       GROUP BY ua.user_id) i
     WHERE u.user_id = i.user_id(+)) x
WHERE x.user_id = :user_id;

-- 5. 토익 기준 백분율 조회
SELECT toeic_score,
       ROUND(CUME_DIST() OVER (ORDER BY toeic_score DESC) * 100, 1) AS upper_percent
FROM (SELECT u.user_id, NVL(t.v, 0) AS toeic_score
      FROM users_t u, (SELECT uci.user_id, MAX(TO_NUMBER(uci.score)) AS v
                       FROM user_certificates_info uci
                       WHERE uci.certificate_id = 576
                       GROUP BY uci.user_id) t
      WHERE u.user_id = t.user_id(+)) x
WHERE x.user_id = :user_id;
