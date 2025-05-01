<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>커뮤니티</title>
<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #111;
	color: #fff;
}

.main-content {
	padding: 40px 140px;
	max-width: 1280px;
	margin: 0 auto;
}

.category-bar {
	display: flex;
	align-items: center;
	gap: 30px;
	margin-bottom: 30px;
}

.category-bar h2 {
	margin: 0;
}

.tabs {
	display: flex;
	gap: 12px;
}

.tabs button {
	background-color: #222;
	color: #fff;
	padding: 10px 24px;
	border: 1px solid transparent;
	border-radius: 10px;
	cursor: pointer;
}

.tabs .active {
	border: 1px solid #A983A3;
	color: #A983A3;
}

.admin-btn {
	background-color: #222;
	border: 1px solid #fff;
	border-radius: 10px;
	padding: 8px;
	cursor: pointer;
}

.filters {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 40px;
}

.filters-left {
	display: flex;
	gap: 12px;
}

.dropdown {
	position: relative;
}

.dropdown-button {
	background-color: #222;
	color: #fff;
	padding: 8px 16px;
	border: 1px solid #444;
	border-radius: 8px;
	cursor: pointer;
}

.dropdown-button.selected {
	border: 1px solid #A983A3;
	color: #A983A3;
}

.dropdown-content {
	display: none;
	position: absolute;
	background-color: #222;
	border: 1px solid #444;
	top: 38px;
	left: 0;
	z-index: 1;
	border-radius: 8px;
}

.dropdown-content button {
	display: block;
	padding: 8px 16px;
	width: 100%;
	border: none;
	background-color: #222;
	color: #fff;
	text-align: left;
	cursor: pointer;
}

.dropdown-content button:hover {
	background-color: #333;
}

.sort-btn {
	background-color: #222;
	color: #fff;
	border: 1px solid #444;
	padding: 8px 16px;
	border-radius: 8px;
	cursor: pointer;
}

.sort-btn.selected {
	border: 1px solid #A983A3;
	color: #A983A3;
}

.write-btn {
	background-color: #A983A3;
	border: none;
	padding: 10px 20px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
}

table.board-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

table.board-table th, table.board-table td {
	border: 1px solid #444;
	padding: 12px;
	text-align: center;
}

table.board-table th {
	background-color: #222;
}

table.board-table td {
	background-color: #1a1a1a;
}

table.board-table td:nth-child(2) {
	text-align: left;
	padding-left: 20px;
	width: 60%;
}

.empty-message {
	text-align: center;
	padding: 40px;
	font-size: 16px;
	color: #aaa;
}

.board-footer {
	display: flex;
	flex-direction: column;
	align-items: stretch;
	margin-top: 30px;
	gap: 12px;
}

.board-footer-top {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.board-footer .pagination {
	display: flex;
	gap: 10px;
	justify-content: center;
}

.board-footer .pagination button {
	background-color: #222;
	color: #fff;
	border: none;
	padding: 8px 14px;
	border-radius: 6px;
	cursor: pointer;
}

.board-footer .pagination button.selected {
	border: 1px solid #A983A3;
	color: #A983A3;
}

.board-footer .search-box {
	display: flex;
	gap: 6px;
	align-items: center;
}

.board-footer input[type="text"] {
	padding: 8px;
	border-radius: 4px;
	border: 2px solid transparent;
	outline: none;
	background-color: #1a1a1a;
	color: #fff;
	transition: border 0.3s, background-color 0.3s;
}

.board-footer input[type="text"]:focus {
	border: 2px solid #A983A3;
	background-color: #222;
}

.board-footer button.search-btn {
	background-color: #444;
	color: #fff;
	border: none;
	padding: 8px 14px;
	border-radius: 6px;
	cursor: pointer;
}
</style>
</head>
<body>
	<div class="main-content">
		<div class="category-bar">
			<h2>커뮤니티</h2>
			<div class="tabs">
				<button class="active" onclick="location.href='freeBoard.do'">자유게시판</button>
				<button onclick="location.href='qnaList.do'">Q&A</button>
				<button onclick="location.href='noticeList.do'">공지사항</button>
				<c:if test="${loginUser.userAuthority == '2'}">
					<button class="admin-btn" onclick="location.href='badUserList.do'">
						<img src="/irumi/resources/images/bell.png" alt="관리자 알림"
							height="20" />
					</button>
				</c:if>
			</div>
		</div>

		<form id="filterForm" action="freeBoard.do" method="get">
			<input type="hidden" name="period" value="${selectedPeriod}" /> <input
				type="hidden" name="sort" value="${selectedSort}" /> <input
				type="hidden" name="keyword" value="${keyword}" /> <input
				type="hidden" name="page" value="${currentPage}" />
		</form>

		<div class="filters">
			<div class="filters-left">
				<div class="dropdown">
					<button type="button" class="dropdown-button selected"
						onclick="toggleDropdown(this)" id="periodBtn">단위기간:
						${selectedPeriod}</button>
					<div class="dropdown-content">
						<button onclick="updateFilter('period', '전체')">전체</button>
						<button onclick="updateFilter('period', '최근 한달')">최근 한달</button>
						<button onclick="updateFilter('period', '최근 1일')">최근 1일</button>
					</div>
				</div>
				<button class="sort-btn ${selectedSort eq 'hit' ? 'selected' : ''}"
					onclick="updateFilter('sort', 'hit')">조회수 정렬</button>
				<button class="sort-btn ${selectedSort eq 'like' ? 'selected' : ''}"
					onclick="updateFilter('sort', 'like')">추천순 정렬</button>
			</div>
			<c:choose>
				<c:when test="${not empty loginUser}">
					<button class="write-btn"
						onclick="location.href='writePost.do?type=일반'">✏ 글쓰기</button>
				</c:when>
				<c:otherwise>
					<button class="write-btn" onclick="location.href='loginPage.do'">✏
						글쓰기</button>
				</c:otherwise>
			</c:choose>
		</div>

		<table class="board-table">
			<thead>
				<tr>
					<th>작성자</th>
					<th>글 제목</th>
					<th>작성일자</th>
					<th>조회수</th>
					<th>추천</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty postList}">
						<c:forEach var="post" items="${postList}">
							<tr>
								<td>${post.postWriter}</td>
								<td><a href="postDetail.do?postId=${post.postId}"
									style="color: inherit; text-decoration: none;">${post.postTitle}</a></td>
								<td>${post.postTime}</td>
								<td>${post.postViewCount}</td>
								<td>${post.postRecommend}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="5" class="empty-message">등록된 게시글이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<div class="board-footer">
			<div class="board-footer-top">
				<div class="post-count">글 수: ${totalCount}개</div>
				<div class="search-box">
					<form action="freeBoard.do" method="get">
						<input type="hidden" name="period" value="${selectedPeriod}" /> <input
							type="hidden" name="sort" value="${selectedSort}" /> <input
							type="hidden" name="page" value="1" /> <input type="text"
							name="keyword" value="${keyword}" placeholder="검색 키워드 입력 후 엔터" />
						<button type="submit" class="search-btn">↵</button>
					</form>
				</div>
			</div>
			<div class="pagination">
				<c:if test="${currentPage > 1}">
					<button onclick="goToPage(${currentPage - 1})">&lt;</button>
				</c:if>
				<c:forEach begin="1" end="${totalPages}" var="pageNum">
					<button onclick="goToPage(${pageNum})"
						class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<button onclick="goToPage(${currentPage + 1})">&gt;</button>
				</c:if>
			</div>
		</div>
	</div>
	<c:import url="/WEB-INF/views/common/footer.jsp" />

	<script>
  function toggleDropdown(btn) {
    const dropdown = btn.nextElementSibling;
    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
  }
  function updateFilter(type, value) {
    const form = document.getElementById('filterForm');
    form[type].value = value;
    form.page.value = 1;
    form.submit();
  }
  function goToPage(pageNum) {
    const form = document.getElementById('filterForm');
    form.page.value = pageNum;
    form.submit();
  }
</script>
</body>
</html>