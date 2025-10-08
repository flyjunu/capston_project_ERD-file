
-- (1) 게시글 목록보기
-- 문제점: 직업 카테고리가 세부로 치면 2000개정도됨. 게시판이 2000개가 될 수는 없음. 
-- 이것도 완전 세부 직업별이 아닌 큰 직업 카테고리에서 게시판을 소수만 만들어야 할 것 같다.  
-- 해결방법 1. 일정한 레벨의 부모 카테고리 까지는 전부 보여줄까? (트리구조)
-- 해결방법 2. 사용자가 l계층씩 확장해나가면서, 검색할 수 있도록 해야할까?
-- (개선전) ---------------------------------------------------------------------

-- (1) 특정 상위 직군 게시판 조회 -- 이거 실제 데이터 넣어보고 반드시 힌트 수정필요. 내 예상대로 안움ㅁ직임
SELECT *
FROM (
    SELECT
        ROWNUM AS rnum, 
        x.*
    FROM (
        SELECT /*+ leading(jcb) index(jcb job_community_board_idx01) index(u) use_nl(u) */ 
            jcb.post_id, jcb.post_title, u.user_name, jcb.created_at, jcb.view_count, jcb.like_count
        FROM job_community_board jcb, users_t u      
        WHERE u.user_id = jcb.user_id
        AND jcb.job_id IN (SELECT /*+ unnest index(job_categories)*/ job_id   
                           FROM job_categories
                           START WITH job_id = :selected_top_level_job_id -- 클릭시 job_id 가 들어가야함.
                           CONNECT BY PRIOR job_id = parent_job_id)        -- 프론트,백에서 작업해야함 이거.
                                                                           -- 22 클릭시 22가 들어가야함
        ORDER BY jcb.created_at DESC
    ) x
    WHERE ROWNUM <= (:page * 10) -- 한 페이지에 10개씩
)
WHERE rnum >= ((:page - 1) * 10) + 1;


-- (2) 내 관심직종 글만 조회 -- 이것도 실제 데이터 넣고 인덱스 구성 만져야 한다.
SELECT *
FROM (
    SELECT
        ROWNUM AS rnum, x.*     
    FROM (
        SELECT /*+ leading(jcb) index(jcb) index(users_t) use_nl(u) */ 
            jcb.post_id, jcb.post_title, u.user_name, jcb.created_at, jcb.view_count, jcb.like_count
        FROM job_community_board jcb, users_t u
        WHERE jcb.user_id = u.user_id 
        AND jcb.job_id IN (SELECT /*+ unnest index(user_job_preferences)*/ hope_job_id
                           FROM user_job_preferences
                           WHERE user_id = :current_user_id)    
        ORDER BY jcb.created_at DESC 
    ) x
    WHERE ROWNUM <= (:page * 10) -- 한 페이지에 10개씩
)
WHERE rnum >= ((:page - 1) * 10) + 1;

-- (3) 게시글 상세 정보 보기
SELECT /*+ index(job_community_board) */ *
  FROM job_community_board
 WHERE post_id = :post_id;

-- (4) 조회수 증가
UPDATE job_community_board
   SET view_count = view_count + 1
 WHERE post_id = :post_id;


