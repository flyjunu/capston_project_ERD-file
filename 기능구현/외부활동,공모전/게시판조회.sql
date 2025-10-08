-- 공모전 활동 조회
공모전 데이터를 조회한다.
-- 필터링 기능으로 공모 분야 선택이 가능해야한다.

-- (1) 모든 공모전 출력. 
select * from activity_postings where recruitment_end_date >= sysdate order by recruitment_end_date desc;

-- (2) 지난 공모전 출력
select * from activity_postings where recruitment_end_date < sysdate order by recruitment_end_date desc;

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
