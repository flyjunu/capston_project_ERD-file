-- 1.유저 테이블(users_t)

-- 2. 인증 테이블(auth_codes)

-- 3. 회사 테이블(company)

-- 4. 회사 구인 직종(company_job_role) 

-- 5. 유저 희망 회사 테이블(user_hope_company)

-- 6. 직종 종류 테이블(job_categories)
create index job_categories_idx01 on job_categories(parent_job_id);

-- 7. 유저 희망직종 테이블(user_job_preferences)
create index user_job_preferences_idx01 on user_job_preferences(user_id);

-- 8. 자격증 종류 테이블(certificates)

-- 9. 유저 자격증 목록 테이블(user_certificates_info)
create index user_certificates_info_idx01 on user_certificates_info(user_id)
  
-- 10. 대학 정보 테이블(universities)

-- 11. 학과 종류 테이블(departments)

-- 12. 유저 학과 테이블(user_departments)

-- 13. 기술 테이블(skill)

-- 14. 유저 기술 테이블(user_skill)

-- 15. 유저 대/내외 활동 내역 테이블(user_activities)

-- 16. 대/내외 활동 게시판 테이블(activity_postings)

-- 17. 팀원 모집 게시판 테이블(team_recruitments)

-- 18. 팀원 모집 지원자 테이블(team_applications)

-- 19. 결성된 팀원 테이블(team_members)

-- 20. 공지사항 테이블(notices)

-- 21. 직종별 게시판 테이블(job_community_board)

-- 22. QnA 게시판(질문) 테이블(qna_questions)

-- 23. QnA 게시판(답변) 테이블(qna_answers)

-- 24. 유저 비교대학 선택 저장 테이블 (user_compare_university) --> 이 테이블 사용?

-- 25. 유저 프로필 저장 테이블(user_profiles) --> 

-- 26. 회사 요구 기술 테이블(company_skill) 

-- 27. 회사 우대 자격증 테이블(company_certificate)

-- 28. 회사 우대 학과 테이블(company_department) -- > 이 테이블 사용?
  

-- 25. 
  
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







