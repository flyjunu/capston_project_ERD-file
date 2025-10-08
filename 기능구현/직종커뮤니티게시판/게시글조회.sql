
-- (1) 게시글 목록보기
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

-- (2) 조회수 증가
UPDATE job_community_board
   SET view_count = view_count + 1
 WHERE post_id = :post_id;

-- (3) 게시글 상세 정보 보기
SELECT *
  FROM job_community_board
 WHERE post_id = :post_id;
