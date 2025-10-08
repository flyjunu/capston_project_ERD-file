-- (1) 팀 지원하기
INSERT INTO team_applications (
    application_id,
    recruitment_id,
    applicant_user_id,
    application_message
) VALUES (
    team_applications_seq.NEXTVAL, -- 시퀀스로 새 지원 ID 생성
    :recruitment_id,              -- 지원하려는 게시글의 ID
    :current_user_id,             -- 현재 로그인된 지원자의 ID
    :application_message         -- 지원자가 작성한 메시지
);
