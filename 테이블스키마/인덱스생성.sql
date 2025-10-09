-- 1.유저 테이블

-- 1.1 인증 테이블

-- 2. 직종 종류 테이블
create index job_categories_idx01 on job_categories(parent_job_id);

-- 3. 유저 희망직종
create index user_job_preferences_idx01 on user_job_preferences(user_id);
-- 4. 자격증 종류 테이블

-- 5. 유저 자격증 목록 테이블
create index user_certificates_info_idx01 on user_certificates_info(user_id)
  
-- 6. 대학 정보 테이블 

-- 7. 학과 종류 테이블

-- 8. 유저 학과 테이블
create index user_departments_idx01 on user_departments(user_id);

-- 9. 유저 기술 테이블
create index user_skill_idx01 on user_skill(user_id);

-- 10. 유저 대/내외 활동 내역 테이블
create index user_activities_idx01 on user_activities(user_id);

-- 11. 대/내외 활동 게시판 테이블
CREATE INDEX activity_postings_idx01 ON activity_postings (activity_type, recruitment_end_date);

-- 12. 팀원 모집 게시판 테이블 생성

-- 13. 팀원모집 지원자 목록

-- 14. 결성된 팀원 테이블

-- 15. 공지사항 게시판 테이블

-- 16. 직종별 게시판 테이블 
CREATE INDEX job_community_board_idx01 ON job_community_board (job_id, created_at);
-- 17. QnA 게시판(질문) 테이블 생성
BEGIN
  CTX_DDL.CREATE_SECTION_GROUP('qna_section_group', 'MULTI_COLUMN_DATASTORE');
  CTX_DDL.ADD_FIELD_SECTION('qna_section_group', 'title', 'title');
  CTX_DDL.ADD_FIELD_SECTION('qna_section_group', 'content', 'question_content');
END;
CREATE INDEX qna_questions_idx01 ON qna_questions(title)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('DATASTORE CTXSYS.MULTI_COLUMN_DATASTORE SECTION GROUP qna_section_group SYNC (ON COMMIT)');

CREATE INDEX qna_questions_idx02 ON qna_questions(created_at);

-- 18. QnA 게시판(답변) 테이블 생성
CREATE INDEX qna_answers_idx02 ON  qna_answers(created_at);

-- 19. 유저 비교 대학선택 저장 테이블

-- 20. 유저 프로필 저장 테이블







