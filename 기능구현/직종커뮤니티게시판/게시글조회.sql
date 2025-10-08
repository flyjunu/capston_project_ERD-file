
-- (1) 게시글 목록보기
-- 문제점: 직업 카테고리가 세부로 치면 2000개정도됨. 게시판이 2000개가 될 수는 없음. 
-- 이것도 완전 세부 직업별이 아닌 큰 직업 카테고리에서 게시판을 소수만 만들어야 할 것 같다.  
-- 해결방법 1. 일정한 레벨의 부모 카테고리 까지는 전부 보여줄까? (트리구조)
-- 해결방법 2. 사용자가 l계층씩 확장해나가면서, 검색할 수 있도록 해야할까?
-- (개선전) ---------------------------------------------------------------------
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

--(개선 후) ----------------------------------------------------------------------------- 
SELECT *
FROM (
    SELECT
        ROWNUM AS rnum,
        x.*
    FROM (
        SELECT u.user_id, u.user_name, NVL(TO_CHAR(u.user_grade), '미등록') AS user_grade,
            up.profile_image_url, up.profile_link, up.profile_introduction,
            LISTAGG(jc.job_name, ', ') WITHIN GROUP (ORDER BY jc.job_name) AS matching_jobs
        FROM
            users_t u, user_job_preferences ujp, job_categories jc, user_compare_university ucu,
            user_profiles up, job_community_board jcb
        WHERE u.user_id = ujp.user_id
            AND ujp.hope_job_id = jc.job_id
            AND u.user_university_id = ucu.university_id
            AND u.user_id = up.user_id(+)
            AND u.user_id = jcb.user_id
            AND ucu.user_id = :user_id
            AND ujp.hope_job_id IN (SELECT hope_job_id 
                                    FROM user_job_preferences 
                                    WHERE user_id = :user_id
            )
            AND u.user_id != :user_id
            AND TO_CHAR(jcb.job_id) LIKE :selected_top_level_job_id || '%'
        GROUP BY
            u.user_id, u.user_name, u.user_grade, up.profile_image_url, up.profile_link, up.profile_introduction
        ORDER BY
            u.user_id
    ) x
    WHERE ROWNUM <= (:page * 20)
)
WHERE rnum >= ((:page - 1) * 20) + 1;

-- (2) 조회수 증가
UPDATE job_community_board
   SET view_count = view_count + 1
 WHERE post_id = :post_id;

-- (3) 게시글 상세 정보 보기
SELECT /*+ index(job_community_board) */ *
  FROM job_community_board
 WHERE post_id = :post_id;
