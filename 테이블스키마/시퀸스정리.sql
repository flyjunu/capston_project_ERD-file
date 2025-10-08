-- 1. 사용자 테이블 (users_t) 용
CREATE SEQUENCE users_seq;

-- 2. 인증 코드 테이블 (auth_codes) 용
CREATE SEQUENCE seq_auth_codes;

-- 3. 대/내외 활동 게시판 (activity_postings) 용
CREATE SEQUENCE activity_postings_seq;

-- 4. 팀원 모집 게시판 (team_recruitments) 용
CREATE SEQUENCE team_recruitments_seq;

-- 5. 팀원 지원 테이블 (team_applications) 용
CREATE SEQUENCE team_applications_seq;

-- 6. 직종별 커뮤니티 (job_community_board) 용
CREATE SEQUENCE job_community_board_seq;

-- 7. Q&A 질문 테이블 (qna_questions) 용
CREATE SEQUENCE qna_questions_seq;

-- 8. Q&A 답변 테이블 (qna_answers) 용
CREATE SEQUENCE qna_answers_seq;
