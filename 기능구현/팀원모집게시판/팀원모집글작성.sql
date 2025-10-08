-- 공모전 테이블이랑 fk관계없음으로, 그냥 자유롭게 작성하면 됨
-- 팀원 모집 작성
INSERT INTO team_recruitments (
    recruitment_id,
    author_user_id,
    posting_id,
    external_activity_url,
    title,
    content,
    required_roles,
    required_members,
    contact_info
) VALUES (
    team_recruitments_seq.NEXTVAL, -- 시퀀스로 새 ID 생성
    :current_user_id,             -- 현재 로그인된 작성자 ID
    :posting_id,                  -- 내부 공고 ID (선택 사항)
    :external_activity_url,       -- 외부 공고 링크 (선택 사항)
    :title,
    :content,
    :required_roles,
    :required_members,
    :contact_info
);
