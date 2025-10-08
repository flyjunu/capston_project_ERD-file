BEGIN
    -- (0) 변수 선언: 게시글 작성자 ID를 담을 변수
    DECLARE
        v_author_id NUMBER;
BEGIN
    -- (1) 권한 확인: 현재 로그인한 사용자가 이 팀의 리더(게시글 작성자)가 맞는지 확인
    SELECT author_user_id INTO v_author_id
      FROM team_recruitments
     WHERE recruitment_id = :recruitment_id;

    IF v_author_id != :current_user_id THEN
        -- 권한이 없으면 에러 발생 및 트랜잭션 중단
        RAISE_APPLICATION_ERROR(-20001, '팀원 수락 권한이 없습니다.');
    END IF;

    -- (2) 지원 상태 변경: 'team_applications' 테이블에서 지원자의 상태를 '수락됨'으로 업데이트
    UPDATE team_applications
       SET status = '수락됨'
     WHERE recruitment_id = :recruitment_id
       AND applicant_user_id = :accepted_user_id;

    -- (3) 팀원 추가: 'team_members' 테이블에 새로운 팀원으로 삽입
    INSERT INTO team_members (
        recruitment_id,
        user_id,
        team_role
    ) VALUES (
        :recruitment_id,
        :accepted_user_id,
        :team_role
    );

    -- (4) 현재 인원 증가: 'team_recruitments' 테이블의 현재 팀원 수를 1 증가
    UPDATE team_recruitments
       SET current_members = current_members + 1
     WHERE recruitment_id = :recruitment_id;

    -- 모든 작업이 성공적으로 끝나면 애플리케이션에서 COMMIT
EXCEPTION
    -- 중간에 오류 발생 시 모든 작업을 취소하고 애플리케이션에 에러 전달
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
END;
/
