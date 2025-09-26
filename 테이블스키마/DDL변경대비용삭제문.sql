-- Level 3 (가장 하위 자식 테이블)
TRUNCATE TABLE qna_answers;
TRUNCATE TABLE team_applications;
TRUNCATE TABLE team_members;
TRUNCATE TABLE user_departments;

-- Level 2
TRUNCATE TABLE job_community_board;
TRUNCATE TABLE qna_questions;
TRUNCATE TABLE team_recruitments;
TRUNCATE TABLE user_certificates_info;
TRUNCATE TABLE user_job_preferences;
TRUNCATE TABLE departments;

-- Level 1
TRUNCATE TABLE activity_postings;
TRUNCATE TABLE notices;
TRUNCATE TABLE user_activities;
TRUNCATE TABLE user_compare_university;
TRUNCATE TABLE user_profiles;
TRUNCATE TABLE user_skill;
TRUNCATE TABLE certificates;
TRUNCATE TABLE job_categories;
TRUNCATE TABLE universities;

-- Level 0 (최상위 부모 테이블)
TRUNCATE TABLE users_t;

-- Level 3 (가장 하위 자식 테이블)
DROP TABLE qna_answers;
DROP TABLE team_applications;
DROP TABLE team_members;
DROP TABLE user_departments;

-- Level 2
DROP TABLE job_community_board;
DROP TABLE qna_questions;
DROP TABLE team_recruitments;
DROP TABLE user_certificates_info;
DROP TABLE user_job_preferences;
DROP TABLE departments;

-- Level 1
DROP TABLE activity_postings;
DROP TABLE notices;
DROP TABLE user_activities;
DROP TABLE user_compare_university;
DROP TABLE user_profiles;
DROP TABLE user_skill;
DROP TABLE certificates;
DROP TABLE job_categories;
DROP TABLE universities;

-- Level 0 (최상위 부모 테이블)
DROP TABLE users_t;
