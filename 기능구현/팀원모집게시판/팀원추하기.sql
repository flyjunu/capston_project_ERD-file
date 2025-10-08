-- (1) 팀장인지 체크
SELECT author_user_id
  FROM team_recruitments
 WHERE recruitment_id = :recruitment_id;

-- (2) 팀원추가
INSERT INTO team_members (
    recruitment_id,
    user_id,
    team_role
) VALUES (
    :recruitment_id,       -- 현재 팀(게시글)의 ID
    :accepted_user_id,     -- 수락된 지원자의 ID
    :team_role             -- 팀장이 부여하는 역할 (예: '개발자')
);
