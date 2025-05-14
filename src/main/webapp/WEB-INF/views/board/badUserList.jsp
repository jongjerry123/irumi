<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>불량 이용자 목록</title>
<style>
body {
	margin: 0;
	background-color: #000 !important;
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
	justify-content: space-between;
	gap: 30px;
	margin-bottom: 30px;
}

.category-bar h2 {
	margin: 0;
	font-size: 35px;
}

.tabs {
	display: flex;
	gap: 12px;
}

.tabs button {
  background-color: #000;
  color: #fff;
  padding: 10px 24px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  backdrop-filter: blur(4px);
  transition: all 0.3s ease;
}

.tabs button:hover {
  background-color: #111;
  border-color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 2px 6px rgba(255, 255, 255, 0.1);
}

.tabs .active {
  color: #A983A3;
  border: 1px solid #A983A3;
  box-shadow: 0 0 8px rgba(169, 131, 163, 0.3);
}



.admin-btn {
  background-color: #000;
  color: #fff;
  border: 1px solid #ff4c4c;
  border-radius: 10px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  backdrop-filter: blur(4px);
  transition: all 0.3s ease;
}

.admin-btn:hover {
  background-color: #111;
  border-color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 2px 6px rgba(255, 255, 255, 0.1);
}

.admin-btn.active {
	border: 2px solid #ff4c4c;
	background-color: #1a1a1a;
}

table {
	width: 100%;
	border-collapse: separate; 
	border-spacing: 0;         
	border: 1px solid #111;
	border-radius: 12px;
	overflow: hidden;  
	margin-top: 40px;         
}

th {
	border: 1px solid #2d0033;
	padding: 14px;
	text-align: center;
	background-color: #2d0033;
} 

td {
	border: 1px solid #111;
	padding: 14px;
	text-align: center;
	background-color: #000;
}


td a {
	color: #A983A3;
	
}

.bottom-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 60px;
}

.bottom-bar .left {
	font-size: 14px;
}

.bottom-bar .right {
	display: flex;
	gap: 10px;
}

.btn-action {
	background-color: #000;
	border: 1px solid #A983A3;
	color: #A983A3;
	padding: 8px 16px;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	letter-spacing: 0.4px;
	transition: all 0.3s ease;
	backdrop-filter: blur(4px);
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.btn-action:hover {
	background-color: #1a1a1a;
	color: #fff;
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(169, 131, 163, 0.25);
}

.btn-danger {
	background-color: #000;
	border: 1px solid #ff4c4c;
	color: #ff4c4c;
	transition: all 0.3s ease;
}

.btn-danger:hover {
	background-color: #ff4c4c;
	color: #fff;
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(255, 76, 76, 0.25);
}

.board-footer {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 30px;
	gap: 20px;
}

.pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 10px;
	width: 100%;
	margin-top: 20px;
}

.pagination button {
	background-color: #111;    
	color: #fff;
	border: 1px solid #444;       
	padding: 8px 14px;
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.3s ease;
}

.pagination button:hover {
	border-color: #A983A3;
	color: #A983A3;
	background-color: #1c1c1c;
}

.pagination button.selected {
	border: 1px solid #A983A3;
	color: #A983A3;
	background-color: transparent;
	font-weight: bold;
}

input[type="checkbox"] {
	accent-color: #A983A3;
	width: 18px;
	height: 18px;
}
</style>
</head>

<body>
<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="main-content">

		<!-- 상단 카테고리 -->
		<div class="category-bar">
			<h2>불량 이용자 관리</h2>
			<div class="tabs">
				<button onclick="location.href='freeBoard.do'">자유게시판</button>
				<button onclick="location.href='qnaList.do'">Q&A</button>
				<button onclick="location.href='noticeList.do'">공지사항</button>
				<c:if test="${loginUser.userAuthority == '2'}">
					<button class="admin-btn active"
						onclick="location.href='badUserList.do'">
						<img src="/irumi/resources/images/bell.png" alt="관리자 알림"
							height="20" />
					</button>
				</c:if>
			</div>
		</div>

		<!-- 하위 탭 -->
		<div class="tabs" style="margin-top: 40px;">
			<button onclick="location.href='reportedPosts.do'">신고된 게시글</button>
			<button onclick="location.href='reportedComments.do'">신고된 댓글</button>
			<button class="active">불량 이용자 목록</button>
		</div>

		<form id="badUserForm" method="post">
			<table>
				<thead>
					<tr>
						<th>아이디</th>
						<th>등록 사유</th>
						<th>원본 게시글 제목</th>
						<th>등록 날짜</th>
						<th>선택</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty badUserList}">
							<c:forEach var="user" items="${badUserList}">
								<tr>
									<td>${user['USER_ID']}</td>
									<td><c:choose>
											<c:when test="${not empty user['REPORT_REASON']}">
                      ${user['REPORT_REASON']}
                    </c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>
									<td><c:choose>
											<c:when test="${not empty user['POST_ID']}">
												<a href="postDetail.do?postId=${user['POST_ID']}">${user['POST_TITLE']}</a>
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>
									<td><c:choose>
											<c:when test="${not empty user['REPORT_DATE']}">
												<fmt:formatDate value="${user['REPORT_DATE']}"
													pattern="yyyy-MM-dd HH:mm:ss" />
											</c:when>
											<c:otherwise>-</c:otherwise>
										</c:choose></td>
									<td><input type="checkbox" name="selectedUsers"
										value="${user['USER_ID']}" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" class="empty-message">불량 이용자가 없습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>

			<!-- 하단 버튼 -->
			<div class="bottom-bar">
				<div class="left">등록된 불량 이용자 수: ${fn:length(badUserList)}명</div>
				<div class="right">
					<button type="submit" class="btn-action"
						formaction="restoreBadUsers.do">불량 이용자 등록 해제</button>
					<button type="submit" class="btn-action btn-danger"
						formaction="withdrawBadUsers.do">탈퇴시키기</button>
				</div>
			</div>
		</form>

		<!-- 페이징 -->
		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<button
					onclick="location.href='badUserList.do?page=${currentPage - 1}'">&lt;</button>
			</c:if>
			<c:forEach begin="1" end="${totalPages}" var="pageNum">
				<button onclick="location.href='badUserList.do?page=${pageNum}'"
					class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
			</c:forEach>
			<c:if test="${currentPage < totalPages}">
				<button
					onclick="location.href='badUserList.do?page=${currentPage + 1}'">&gt;</button>
			</c:if>
		</div>
	</div>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>