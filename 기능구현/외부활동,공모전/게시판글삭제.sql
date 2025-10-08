-- 게시판 글을 삭제하는 sql
-- 게시판 id를 알려면 프론트에서 id값을 가지고 있어야한다.

DELETE FROM activity_postings
      WHERE posting_id = :posting_id
        AND user_id = :current_user_id;
