
-- (1) 질문글 목록 조회하기. 
SELECT *
FROM ( SELECT ROWNUM AS rnum, x.*
        FROM (SELECT /*+ leading(q) use_nl(u) index(q) */
                    q.question_id, q.title, u.user_name, q.status, q.view_count, q.question_like_count, q.created_at
              FROM qna_questions q, users_t u 
              WHERE q.user_id = u.user_id
              ORDER BY q.created_at DESC) x
        WHERE ROWNUM <= (:page * 10) -- 한 페이지에 10개씩
    )
WHERE rnum >= ((:page - 1) * 10) + 1;

-- (2) 질문글 검색어로 조회하기. 
-- 2.1 text index 정의하기.
BEGIN
  CTX_DDL.CREATE_SECTION_GROUP('qna_section_group', 'MULTI_COLUMN_DATASTORE');
  CTX_DDL.ADD_FIELD_SECTION('qna_section_group', 'title', 'title');
  CTX_DDL.ADD_FIELD_SECTION('qna_section_group', 'content', 'question_content');
END;

-- 2.2 text index를 생성하기. 커밋마다 동기
CREATE INDEX idx_qna_full_text ON qna_questions(title)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('DATASTORE CTXSYS.MULTI_COLUMN_DATASTORE SECTION GROUP qna_section_group SYNC (ON COMMIT)');

-- 2.3 검색하기.
SELECT /*+ leading(q u) use_nl(u) index(q qna_questions_idx01) index(u)*/
  q.question_id, q.title, u.user_name, q.status, q.view_count, q.question_like_count, q.created_at
    SCORE(1) AS relevance_score -- 1번 CONTAINS 조건의 관련도 점수
FROM qna_questions q, users_t u 
WHERE q.user_id = u.user_id
    -- 'title' 대표 컬럼으로 검색하지만, 실제로는 content까지 함께 검색됨
and CONTAINS(title, :keyword, 1) > 0
ORDER BY relevance_score DESC, q.created_at DESC; -- 관련도 점수가 높은 순 정렬
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
