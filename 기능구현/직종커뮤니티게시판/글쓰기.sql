INSERT INTO job_community_board (
    post_id,
    job_id,
    user_id,
    post_title,
    post_content
) VALUES (
    job_community_board_seq.NEXTVAL, -- 시퀀스로 새 게시글 ID 생성
    :job_id,                         -- 글이 속할 직종 카테고리 ID
    :current_user_id,                -- 현재 로그인된 작성자 ID
    :post_title,                     -- 게시글 제목
    :post_content                    -- 게시글 내용
);
