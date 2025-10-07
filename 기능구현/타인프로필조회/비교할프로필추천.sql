-- user_id는 문자로 출력되면 안되고, 이를 이용해서 유저 프로필 조회한 다음에 링크 타야한다.

select * 
from (select rownum as rnum, x.*
        from (select u.user_id, u.user_name as 이름, nvl(to_char(u.user_grade), '미등록') as 학년,
              LISTAGG(jc.job_name, ', ') WITHIN GROUP (ORDER BY jc.job_name) AS 희망직종,
              up.profile_image_url, up.profile_link, up.profile_introduction 
            
             
              from users_t u, job_categories jc, user_profiles up
               where u.user_university_id IN (SELECT university_id -- 대학이 일치하는 것만 출력
                                              FROM user_compare_university
                                              WHERE user_id = :user_id)
        and exists ( SELECT 1 
                     FROM user_job_preferences ujp
                     WHERE ujp.user_id = u.user_id -- 유저희망직종 = 전체유저 
                    AND ujp.hope_job_id IN (SELECT hope_job_id -- 유저희망직종 in 내 희망직업들
                                            FROM user_job_preferences
                                            WHERE user_id = :user_id)
          and ujp.hope_job_id = jc.job_id
          AND up.user_id = u.user_id
                    )                       
        and u.user_id != :user_id
        GROUP BY 
            u.user_id,
            u.user_name,
            u.user_grade
        ORDER BY
            u.user_id
               ) x
         where rownum <= (:page * 5) )
where RNUM >= (:page-1) * 5


