-- 타인의 프로필을 확인할 수 있다.
-- 반드시 아래 4개의 인덱스가 존재해야 아래 조회문을 사용할 수 있다.
-- 성능 튜닝 종료됨
create index user_departments_idx01 on user_departments(user_id);
create index user_certificates_info_idx01 on user_certificates_info(user_id);
create index user_activities_idx01 on user_activities(user_id);
create index user_skill_idx01 on user_skill(user_id);

SELECT /*+ leading (A C) use_nl(C) index(A) index(C) */
    A.user_name AS 이름,
    DECODE(A.user_state, '대학생', A.user_grade || '학년', A.user_state) AS 유저_상태, C.university_name AS 대학교,
    (SELECT /*+ leading(D F) index(D) index(F) use_nl(F) no_unnest */
            LISTAGG(F.department_name || ' (' || D.major_type || ')', ', ') WITHIN GROUP (ORDER BY D.major_type)
     FROM user_departments D, departments F
     WHERE D.user_id = A.user_id AND F.department_id = D.department_id) AS 학과_정보,
    (SELECT /*+ leading(B E) index(B) index(E) use_nl(E) no_unnest*/
            LISTAGG(E.job_name, ', ') WITHIN GROUP (ORDER BY E.job_name)
     FROM user_job_preferences B, job_categories E
     WHERE B.user_id = A.user_id AND E.job_id = B.hope_job_id) AS 희망_직무,
    A.user_roadmap AS 유저_로드맵,
    NVL((SELECT /*+ index(E) no_unnest */
                LISTAGG(E.skill_name, ', ') WITHIN GROUP (ORDER BY E.skill_name)
           FROM user_skill E
          WHERE E.user_id = A.user_id), '보유기술없음') AS 보유_기술_목록,
     NVL((SELECT /*+ index(I) no_unnest */
                LISTAGG(I.activity_name || ' (' || I.activity_type || ')', ', ') WITHIN GROUP (ORDER BY I.start_date)
           FROM user_activities I
          WHERE I.user_id = A.user_id), '활동내역없음') AS 대내외_활동내역,
      NVL((SELECT /*+ leading(G H) index(G) index(H) use_nl(H) no_unnest */
                LISTAGG(H.certificate_name || ' (' || TO_CHAR(G.issue_date, 'YYYY-MM-DD') || ')', ', ') WITHIN GROUP (ORDER BY G.issue_date)
           FROM user_certificates_info G, certificates H
          WHERE G.user_id = A.user_id AND H.certificate_id = G.certificate_id), '보유자격증없음') AS 보유_자격증
FROM
    users_t A,
    universities C
WHERE
    A.user_id = :others_user_id 
AND C.university_id = A.user_university_id;
