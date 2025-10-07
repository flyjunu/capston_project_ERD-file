-- 사용자가 선택한 학교+관련직종인 사람만 데이터를 출력하는 쿼리.
-- 1. 
-- 


select A.user_id AS 비교유저id, A.user_name AS 비교유저명, A.user_grade AS 학년, B.job_name AS 희망직종
from users_t A, job_categories B, user_job_preferences C
where A.user_id = :user_id
and C.user_id = A.user_id
and B.job_id = C.hope_job_id
and exists (select 1
            from user_compare_university D
             where D.user_id = A.user_Id)
             
