-- 공모전 활동 조회
공모전 데이터를 조회한다.
-- 필터링 기능으로 공모 분야 선택이 가능해야한다.

-- (공모전 검색 조건)
1. (defalt) 모든 공모전 출력
2. 설정한 직종의 공모전 출력. -- 그러면 범위가 너무 좁아지고(직종이 20만개인데, 그중 정확히 준비 직종 일치 불가능
    관리가 힘들어짐 (취소요청 하자) 
3. 공모 분야로 검색한다.
4. 검색어로 검색시 출력(아래 파이썬코드참조) 
   
-- (1) 모든 모집중인 공모전 출력. 
select * 
    from activity_postings 
    where recruitment_end_date >= sysdate 
    order by recruitment_end_date desc;

-- 활동 타입(activity_type에서 XX공모전같은 걸로 종류를 나눠야 할것같음. )
-- 공모전 종류를 따로 테이블에 담아 둘까 생각했는데 컬럼수가 많아봐야 50개정도일텐데 조회성능상 굳이굳이 인것같기도?
-- 애초에 varchar로 내가 데이터타입을 저장했으니까 굳이 테이블만들지는 말자. ㅇㅇ 
-- 백엔드에서 타입 지정해야함.

-- (1.1) 모집 기간이 지난 공모전 출력
select * 
    from activity_postings 
    where recruitment_end_date < sysdate 
    order by recruitment_end_date desc;

-- (3) 자신이 지정한 분야의 공모전, 활동만 출력하기.
CREATE INDEX activity_postings_idx01 ON activity_postings (activity_type, recruitment_end_date);
select * 
    from activity_postings 
    where recruitment_end_date < sysdate
    and activity_type = :activity_type
    order by recruitment_end_date desc;
-- 


-- (3) 기타 필터링 조건대로 검색기능 구현
-- 백엔드에서 SQL을 조합해서 넣어야한다. 
-- 사용예시.  
import datetime

def build_activity_search_query(
    activity_type: str | None = None,
    keyword: str | None = None,
    deadline_option: str | None = None,
    eligibility_tag: str | None = None
) -> tuple[str, dict]:
    """
    활동 게시판의 검색 조건에 따라 동적으로 SQL 쿼리와 파라미터를 생성합니다.

    :param activity_type: 활동 종류 (예: '공모전', '인턴')
    :param keyword: 검색어 (제목 또는 주최 기관)
    :param deadline_option: 마감일 옵션 (예: 'today', 'this_week')
    :param eligibility_tag: 지원 자격 태그 (예: '3-4학년', '전공무관')
    :return: 실행할 SQL 쿼리 문자열과 바인딩할 파라미터 딕셔너리
    """
    # 1. 기본이 되는 SQL 쿼리 (모집 중인 공고만 선택)
    base_query = """
        SELECT posting_id, title, host_organization, activity_type, recruitment_end_date, view_count
        FROM activity_postings
        WHERE recruitment_end_date >= SYSDATE
    """
    
    # 2. 동적으로 추가될 조건문과 파라미터를 담을 리스트와 딕셔너리
    conditions = []
    params = {}

    # 3. 각 필터 조건이 존재할 경우, SQL 조건문과 파라미터를 추가
    # (필터 1: 활동 종류)
    if activity_type:
        conditions.append("activity_type = :p_activity_type")
        params["p_activity_type"] = activity_type

    # (필터 2: 검색어)
    if keyword:
        conditions.append("(title LIKE :p_keyword OR host_organization LIKE :p_keyword)")
        params["p_keyword"] = f"%{keyword}%"

    # (필터 3: 모집 마감일)
    if deadline_option == 'today':
        # TRUNC를 사용해 시간 부분을 제외하고 날짜만 비교
        conditions.append("TRUNC(recruitment_end_date) = TRUNC(SYSDATE)")
    elif deadline_option == 'this_week':
        # 오늘부터 이번 주 일요일까지 (Oracle 기준)
        conditions.append("TRUNC(recruitment_end_date) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE, 'IW') + 6")

    # (필터 5: 지원 자격)
    if eligibility_tag:
        conditions.append("eligibility LIKE :p_eligibility")
        params["p_eligibility"] = f"%{eligibility_tag}%"

    # 4. 생성된 조건문들이 있다면, 기본 쿼리에 AND로 연결하여 추가
    if conditions:
        final_query = base_query + " AND " + " AND ".join(conditions)
    else:
        final_query = base_query

    # 5. 마지막으로 정렬 순서 추가
    final_query += " ORDER BY recruitment_end_date ASC"

    return final_query, params

-- 실제 사용 예시
# 예시 1: '인턴'이면서 '네이버' 키워드로 검색
query1, params1 = build_activity_search_query(activity_type="인턴", keyword="네이버")
print("--- 예시 1 ---")
print("SQL:", query1)
print("PARAMS:", params1)
# SQL: ... WHERE recruitment_end_date >= SYSDATE AND activity_type = :p_activity_type AND (title LIKE :p_keyword OR host_organization LIKE :p_keyword) ORDER BY ...
# PARAMS: {'p_activity_type': '인턴', 'p_keyword': '%네이버%'}


# 예시 2: '공모전'이면서 '이번 주 마감'인 공고 검색
query2, params2 = build_activity_search_query(activity_type="공모전", deadline_option="this_week")
print("\n--- 예시 2 ---")
print("SQL:", query2)
print("PARAMS:", params2)
# SQL: ... WHERE recruitment_end_date >= SYSDATE AND activity_type = :p_activity_type AND TRUNC(recruitment_end_date) BETWEEN TRUNC(SYSDATE) AND TRUNC(SYSDATE, 'IW') + 6 ORDER BY ...
# PARAMS: {'p_activity_type': '공모전'}
