
-- (1) 게시글 목록보기
-- 문제점: 직업 카테고리가 세부로 치면 20만개정도됨. 게시판이 20만개가 될 수는 없음. 
-- 이것도 완전 세부 직업별이 아닌 큰 직업 카테고리에서 게시판을 소수만 만들어야 할 것 같다.  
-- 해결방법 1. 일정한 레벨의 부모 카테고리 까지는 전부 보여줄까? (트리구조)
-- 해결방법 2. 사용자가 l계층씩 확장해나가면서, 검색할 수 있도록 해야할까?
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
SELECT /*+ index(job_community_board) */ *
  FROM job_community_board
 WHERE post_id = :post_id;
