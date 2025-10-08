-- (1) 메인화면에 나타날 나의 간략 프로필 

select A.user_name AS 이름, A.user_grade AS 학년, B.job_name AS 희망직종
from users_t A, job_categories B, user_job_preferences C
where A.user_id = :user_id
and C.user_id = A.user_id
and B.job_id = C.hope_job_id;

