-- 1. user_t 테스트 데이터 삽입

INSERT INTO users_t (user_id, user_name, user_email, user_age, user_gender, user_state, user_grade, user_university_id, user_roadmap, user_password)
VALUES (1, '김코딩', 'kim.coding@example.com', 24, '남', '대학생', 4, 1, '백엔드 개발자 로드맵', 1234);

INSERT INTO users_t (user_id, user_name, user_email, user_age, user_gender, user_state, user_grade, user_university_id, user_roadmap, user_password)
VALUES (2, '박새로이', 'park.new@example.com', 26, '여', '취준생', NULL, 2, '데이터 분석가 준비중', 1234);

-- 2. 직종 종류 테스트 데이터 삽입
INSERT INTO job_categories(job_id, parent_job_id, job_name) VALUES (1, null, '개발자');
INSERT INTO job_categories(job_id, parent_job_id, job_name) VALUES (2, 1, 'DBA');

-- 3. 유저 희망 직종 테스트 데이터 삽입
INSERT INTO user_job_preferences(user_id, hope_job_id) VALUES (1, 1);
INSERT INTO user_job_preferences(user_id, hope_job_id) VALUES (1, 2);
INSERT INTO user_job_preferences(user_id, hope_job_id) VALUES (2, 1);
INSERT INTO user_job_preferences(user_id, hope_job_id) VALUES (2, 2);

-- 4. 자격증 종류 테스트 데이터 삽입
INSERT INTO  certificates(certificate_id, certificate_name, issuing_authority, certificate_category) VALUES (1, 'SQLP', '한국산업인력공단', '국가기술');
INSERT INTO  certificates(certificate_id, certificate_name, issuing_authority, certificate_category) VALUES (2, 'OCP', '한국산업인력공단', '국가기술');
INSERT INTO  certificates(certificate_id, certificate_name, issuing_authority, certificate_category) VALUES (3, '정보처리기사', '한국산업인력공단', '국가기술');
INSERT INTO  certificates(certificate_id, certificate_name, issuing_authority, certificate_category) VALUES (4, '정보보안기사', '한국산업인력공단', '국가기술');

-- 5. 유저 자격증 목록 테스트 데이터 삽입
INSERT INTO user_certificates_info (user_certificate_id, user_id, certificate_id, issue_date, expiration_date, certificate_number, score
) VALUES (1, 1, 1, '2024-05-20', '2026-05-19', '12345-ABC-67890', '950');
INSERT INTO user_certificates_info (user_certificate_id, user_id, certificate_id, issue_date, expiration_date, certificate_number, score
) VALUES (2, 2, 2, '2024-05-20', null, '12345-ABC-67890', '500');
INSERT INTO user_certificates_info (user_certificate_id, user_id, certificate_id, issue_date, expiration_date, certificate_number, score
) VALUES (3, 1, 1, '2024-05-20', '2026-05-19', '12345-ABC-67890', '0');
INSERT INTO user_certificates_info (user_certificate_id, user_id, certificate_id, issue_date, expiration_date, certificate_number, score
) VALUES (4, 2, 2, '2024-05-20', null, '12345-ABC-67890', '200');

-- 6. 대학 정보 테스트 데이터 삽입
INSERT INTO universities (university_id, university_name, campus_type, academic_system, region, establishment_type, university_level)
VALUES (1, '서울대학교', '본교', '대학교', '서울', '국립대학법인', 1);
INSERT INTO universities (university_id, university_name, campus_type, academic_system, region, establishment_type, university_level)
VALUES (2, '연세대학교', '본교', '대학교', '서울', '사립', 1);
INSERT INTO universities (university_id, university_name, campus_type, academic_system, region, establishment_type, university_level)
VALUES (3, '경북대학교', '본교', '대학교', '대구', '국립', 2);
INSERT INTO universities (university_id, university_name, campus_type, academic_system, region, establishment_type, university_level)
VALUES (4, '계명대학교', '본교', '대학교', '대구', '사립', 3);

-- 7. 학과 정보 테스트 데이터 삽입
INSERT INTO departments (university_id, department_id, department_name) VALUES (1, 1, '컴퓨터공학과');
INSERT INTO departments (university_id, department_id, department_name) VALUES (1, 2, '의용공학과');
INSERT INTO departments (university_id, department_id, department_name) VALUES (2, 3, '문헌정보학과');
INSERT INTO departments (university_id, department_id, department_name) VALUES (2, 4, '오징어심리학과');

-- 8. 유저 학과 테스트 데이터 삽입
INSERT INTO user_departments (user_id, department_id, major_type) VALUES (1, 1, '주전공');
INSERT INTO user_departments (user_id, department_id, major_type) VALUES (1, 2, '복수전공');
INSERT INTO user_departments (user_id, department_id, major_type) VALUES (2, 3, '주전공');
INSERT INTO user_departments (user_id, department_id, major_type) VALUES (2, 4, '복수전공');


-- 9. 유저 기술 테스트 데이터 삽입
INSERT INTO user_skill (user_id, skill_name) VALUES (1, 'Java');
INSERT INTO user_skill (user_id, skill_name) VALUES (2, 'Python');
INSERT INTO user_skill (user_id, skill_name) VALUES (1, 'SQL');
INSERT INTO user_skill (user_id, skill_name) VALUES (2, 'React');

-- 10. 유저/대내외활동 내역 테스트 데이터 삽입
INSERT INTO user_activities (activity_id, user_id, activity_type, activity_name, start_date, end_date, activity_description)
VALUES (1, 1, '교내동아리', '코딩 동아리 CODE', DATE '2023-03-01', DATE '2024-12-20', '정기 스터디 및 교내 코딩 경진대회 참가하여 1위 수상');
INSERT INTO user_activities (activity_id, user_id, activity_type, activity_name, start_date, end_date, activity_description)
VALUES (2, 2, '공모전', '빅데이터 분석 공모전', DATE '2024-06-01', DATE '2024-08-15', '공공데이터를 활용한 도시 교통 문제 해결 방안 제시, 장려상 수상');

-- 11. 대/내외 활동 게시판 테스트 데이터 삽입
INSERT INTO activity_postings (
    posting_id, user_id, activity_type, title, host_organization, 
    recruitment_start_date, recruitment_end_date, 
    eligibility, benefits, details, application_url
) VALUES (
    1, 1, '인턴', '2026년 동계 대학생 인턴십 모집', '삼성전자',
    '2025-10-01','2025-10-31',
    '4년제 대학 3, 4학년 재/휴학생', '인턴십 수료 시 채용 가산점 부여, 월 활동비 250만원 지급',
    'DX 부문 소프트웨어 개발, AI 연구 직무 관련 인턴을 모집합니다. 상세 직무 내용은 홈페이지를 참고하세요.', 'https://careers.samsung.com'
);
INSERT INTO activity_postings (
    posting_id, user_id, activity_type, title, host_organization, 
    recruitment_start_date, recruitment_end_date, 
    eligibility, benefits, details, application_url
) VALUES (
    2, 2, '공모전', '제15회 대한민국 공공데이터 활용 창업경진대회', '행정안전부',
    '2025-09-20', '2025-11-30',
    '대한민국 국민 누구나 (개인 또는 팀)', '대상 대통령상 및 상금 1억원, 사업화 후속 지원',
    '공공데이터를 활용한 혁신적인 아이디어 및 비즈니스 모델 발굴을 위한 공모전입니다.', 'https://www.data.go.kr/contest'
);

-- 12. 대/내외 활동 팀 모집 게시판 테스트 데이터 삽입
INSERT INTO team_recruitments (recruitment_id, posting_id, external_activity_url, author_user_id, title, content, required_roles, required_members, contact_info)
VALUES (1, 1, NULL, 1, '[급구] 삼성전자 인턴십 스터디 팀원 2명 모집!', '삼성전자 동계 인턴십을 목표로 CS 스터디와 코딩테스트를 함께 준비할 팀원을 구합니다. 주 2회 오프라인 스터디 예정입니다.', '백엔드 개발자, 프론트엔드 개발자', 2, '카카오톡 ID: kimcoding');
INSERT INTO team_recruitments (recruitment_id, posting_id, external_activity_url, author_user_id, title, content, required_roles, required_members, contact_info)
VALUES (2, 2, NULL, 2, '공공데이터 창업경진대회 UI/UX 디자이너 1명 찾습니다', '현재 개발자 2명, 기획자 1명 있습니다. 저희 아이디어를 멋지게 시각화해주실 실력있는 디자이너분을 간절히 기다립니다!', 'UI/UX 디자이너', 1, '이메일: park.new@example.com');
INSERT INTO team_recruitments (recruitment_id, posting_id, external_activity_url, author_user_id, title, content, required_roles, required_members, contact_info)
VALUES (3, NULL, 'https://hackathon.naver.com/2025', 2, '네이버 캠퍼스 핵데이 참가할 AI/ML 엔지니어 구합니다', '네이버 핵데이에서 AI 챗봇을 주제로 프로젝트를 진행할 팀입니다. Python 및 Pytorch에 능숙하신 분이면 좋겠습니다.', 'AI/ML 엔지니어', 1, '오픈채팅: https://open.kakao.com/o/s12345');

-- 13. 대/내외 활동 팀 지원자 목록 테스트 데이터 삽입
INSERT INTO team_applications (application_id, recruitment_id, applicant_user_id, application_message, status)
VALUES (1, 1, 1, '안녕하세요, 해당 공모전 경험이 있습니다. 기획 직무로 지원합니다.', '대기중');
INSERT INTO team_applications (application_id, recruitment_id, applicant_user_id, application_message, status)
VALUES (2, 2, 1, 'UI/UX 디자인에 자신있습니다. 포트폴리오 확인 부탁드립니다.', '대기중');
INSERT INTO team_applications (application_id, recruitment_id, applicant_user_id, application_message, status)
VALUES (3, 1, 2, '백엔드 개발자로 지원합니다. 함께 좋은 결과 만들고 싶습니다!', '수락됨');
INSERT INTO team_applications (application_id, recruitment_id, applicant_user_id, application_message, status)
VALUES (4, 2, 2, '프론트엔드 개발자입니다.', '거절됨');

-- 14. 팀원 테이블 테스트 데이터 삽입
INSERT INTO team_members (recruitment_id, user_id, team_role) VALUES (1, 1, '팀장');
INSERT INTO team_members (recruitment_id, user_id, team_role) VALUES (2, 1, '개발자');
INSERT INTO team_members (recruitment_id, user_id, team_role) VALUES (3, 2, '백엔드');
INSERT INTO team_members (recruitment_id, user_id, team_role) VALUES (1, 2, '프론트');

-- 15. 공지사항 테이블 테스트 데이터 삽입
INSERT INTO notices (notice_id, user_id, notice_title, notice_content) VALUES (1, 1, '시스템 정기 점검 안내 (9/22)', '2025년 9월 22일 월요일 오전 2시부터 4시까지 서비스 안정화를 위한 시스템 정기 점검이 진행됩니다. 이용에 불편을 드려 죄송합니다.'); 
INSERT INTO notices (notice_id, user_id, notice_title, notice_content) VALUES (2, 2, '제3회 개발자 컨퍼런스 개최 안내', '오는 10월 15일, 제3회 개발자 컨퍼런스가 개최됩니다. 상세 내용 및 참가 신청은 공고 게시판을 확인해주세요. 많은 참여 바랍니다.');

-- 16. 직종별 게시판 테스트 데이터 삽입
INSERT INTO job_community_board (post_id, job_id, user_id, post_title, post_content) VALUES (1, 1, 1, '신입 백엔드 개발자 기술 스택 질문드립니다.', '안녕하세요. 현재 Java와 Spring Boot를 주로 사용하고 있는데, 추가적으로 어떤 기술을 공부하면 취업에 도움이 될까요? 선배님들의 조언을 구합니다.'); 
INSERT INTO job_community_board (post_id, job_id, user_id, post_title, post_content) VALUES (2, 1, 2, '최근에 유용하게 사용한 피그마 플러그인 공유합니다!', '최근에 발견한 피그마 플러그인 3가지입니다. 작업 효율을 엄청나게 올려주네요. 다들 한번 사용해보세요!');
INSERT INTO job_community_board (post_id, job_id, user_id, post_title, post_content) VALUES (3, 2, 1, '전능하신 재미나이님께 무릎꿇습니다.', 'AI 때문에 우리 일자리가 ㅠㅠ'); 
INSERT INTO job_community_board (post_id, job_id, user_id, post_title, post_content) VALUES (4, 2, 2, 'HTML은 코딩언어다.', '이것은 컴퓨터 공학과가 높게 평가.');

-- 17. QnA 게시판 (질문) 테스트 데이터 삽입
INSERT INTO qna_questions (question_id, user_id, title, question_content) VALUES (1, 1, 'DBA는 어떻게 준비가능한가요?', '제목처럼 선배님들의 조언이 필요합니다'); 
INSERT INTO qna_questions (question_id, user_id, title, question_content) VALUES (2, 2, '코딩 배우면 치킨집 차리나요?', '제목처럼 선배님들의 조언이 필요합니다'); 
INSERT INTO qna_questions (question_id, user_id, title, question_content) VALUES (3, 1, '백엔드가 앞으로 유망할까요?', '제목처럼 선배님들의 조언이 필요합니다'); 
INSERT INTO qna_questions (question_id, user_id, title, question_content) VALUES (4, 2, '프론트엔드가 앞으로 유망할까요?', '제목처럼 선배님들의 조언이 필요합니다'); 

-- 18. QnA 게시판 (답변) 테스트 데이터 삽입
INSERT INTO qna_answers (answer_id, question_id, user_id, answer_content) VALUES (1, 1, 1, '안녕하세요, SQLP와 OCP 를 따시는것을 추천드리고 취업시장상 경력직밖에 뽑지 않음으로 경력을 쌓고 이직하는 방법을 추천드립니다. ');
INSERT INTO qna_answers (answer_id, question_id, user_id, answer_content) VALUES (2, 2, 2, '네 치킨집차립니다. ');
INSERT INTO qna_answers (answer_id, question_id, user_id, answer_content) VALUES (3, 1, 1, '유망 합니다. ㅎㅎ ');
INSERT INTO qna_answers (answer_id, question_id, user_id, answer_content) VALUES (4, 2, 2, '유망 합니다. 매우매우요. ');

-- 19. 유저 비교 대학 선택 테스트 데이터 삽입
INSERT INTO user_compare_university (university_id, user_id) VALUES (1, 1);
INSERT INTO user_compare_university (university_id, user_id) VALUES (3, 1);
INSERT INTO user_compare_university (university_id, user_id) VALUES (4, 1);
INSERT INTO user_compare_university (university_id, user_id) VALUES (2, 2);
INSERT INTO user_compare_university (university_id, user_id) VALUES (3, 2);

-- 20. 유저간략프로픽 테스트 데이터 삽입
INSERT INTO user_profiles (user_id, profile_image_url, profile_link, profile_introduction)
VALUES (1, 'https://example.com/images/profiles/kim.jpg', '/profile/kimcoding', '백엔드 개발자를 꿈꾸는 김코딩입니다. 함께 성장해요!');
INSERT INTO user_profiles (user_id, profile_image_url, profile_link, profile_introduction)
VALUES (2, 'https://example.com/images/profiles/park.png', '/profile/newpark', '데이터로 세상을 이롭게 만들고 싶은 박새로이입니다.');

commit;



