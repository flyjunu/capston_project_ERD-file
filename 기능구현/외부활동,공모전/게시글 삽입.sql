-- 게시판에 글 올리기
INSERT INTO activity_postings (
    posting_id,
    user_id,
    activity_type,
    title,
    host_organization,
    recruitment_start_date,
    recruitment_end_date,
    eligibility,
    benefits,
    details,
    poster_image_url,
    application_url
) VALUES (
    activity_postings_seq.NEXTVAL, -- 시퀀스를 통해 새 게시글 ID 생성
    :current_user_id,            -- 현재 로그인된 사용자의 ID
    :activity_type,
    :title,
    :host_organization,
    :recruitment_start_date,
    :recruitment_end_date,
    :eligibility,
    :benefits,
    :details,
    :poster_image_url,
    :application_url
);


