<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항</title>
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
	gap: 30px;
	margin-bottom: 30px;
}

.category-bar h2 {
	margin: 0;
	font-weight: normal;
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
  border: 1px solid rgba(255, 255, 255, 0.25);
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

.filters {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 40px;
}

.write-btn {
  background-color: #A983A3;
  color: #fff;
  border: none;
  padding: 10px 24px;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(169, 131, 163, 0.2);
}

.write-btn:hover {
  background-color: #8c6c8c;
  border-color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 6px 18px rgba(169, 131, 163, 0.4);
}

table.board-table {
	width: 100%;
	border-collapse: separate; 
	border-spacing: 0;         
	border: 1px solid #3a1f41;
	border-radius: 12px;
	overflow: hidden;          
}

table.board-table th, table.board-table td {
	border: 1px solid #3a1f41;
	padding: 12px;
	text-align: center;
}

table.board-table th {
	background-color: #A983A3;
}

table.board-table td {
	background-color: #000;
}

table.board-table td:nth-child(2) {
	text-align: left;
	padding-left: 20px;
	width: 50%;
}

.board-table td a {
  text-decoration: none; 
  color: #A983A3;        
}

.board-table td a:hover {
  color: #C69BC6;       
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

.board-footer .pagination {
	display: flex;
	gap: 10px;
	justify-content: center;
}

.board-footer .pagination button {
  background-color: #000;
  color: #fff;
  border: 1px solid rgba(255, 255, 255, 0.25);
  padding: 8px 14px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.board-footer .pagination button:hover {
  background-color: #111;
  border-color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 2px 6px rgba(255, 255, 255, 0.1);
}

.board-footer .pagination button.selected {
  border: 1px solid #A983A3;
  color: #A983A3;
  box-shadow: 0 0 6px rgba(169, 131, 163, 0.3);
}

@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

tbody tr {
  opacity: 0;
  animation: fadeUp 0.5s ease forwards;
}

/* 순차적으로 하나씩 뜨게 만들기 위한 딜레이 */
tbody tr:nth-child(1) { animation-delay: 0.1s; }
tbody tr:nth-child(2) { animation-delay: 0.12s; }
tbody tr:nth-child(3) { animation-delay: 0.14s; }
tbody tr:nth-child(4) { animation-delay: 0.16s; }
tbody tr:nth-child(5) { animation-delay: 0.18s; }
tbody tr:nth-child(6) { animation-delay: 0.2s; }
tbody tr:nth-child(7) { animation-delay: 0.22s; }
tbody tr:nth-child(8) { animation-delay: 0.24s; }
tbody tr:nth-child(9) { animation-delay: 0.26s; }
tbody tr:nth-child(10) { animation-delay: 0.28s; }

</style>
</head>

<body>
<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="main-content">
		<div class="category-bar">
			<h2>커뮤니티</h2>
			<div class="tabs">
				<button onclick="location.href='freeBoard.do'">자유게시판</button>
				<button onclick="location.href='qnaList.do'">Q&A</button>
				<button class="active">공지사항</button>
				<c:if test="${loginUser.userAuthority == '2'}">
					<button class="admin-btn" onclick="location.href='badUserList.do'">
						<img src="/irumi/resources/images/bell.png" alt="관리자 알림"
							height="20" />
					</button>
				</c:if>
			</div>
		</div>

		<div class="filters">
			<div></div>
			<c:if test="${loginUser.userAuthority == '2'}">
				<button class="write-btn"
					onclick="location.href='writePost.do?type=공지'">✏ 공지 등록</button>
			</c:if>
		</div>

		<table class="board-table">
			<thead>
				<tr>
					<th>작성자</th>
					<th>글 제목</th>
					<th>작성일자</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty postList}">
						<c:forEach var="post" items="${postList}">
							<tr>
								<td>${post.postWriter}</td>
								<td>
  <div style="display: flex; justify-content: space-between; align-items: center;">
  <div style="display: flex; align-items: center; gap: 6px;">
    <a href="postDetail.do?postId=${post.postId}">${post.postTitle}</a>
    <c:if test="${post.commentCount > 0}">
      <span style="color: gray;">(${post.commentCount})</span>
    </c:if>
    <c:if test="${not empty post.postSavedName}">
      <span title="첨부파일 있음">📎</span>
    </c:if>
  </div>

  <c:if test="${not empty post.postSavedName 
            && (fn:endsWith(post.postSavedName, '.jpg') 
             || fn:endsWith(post.postSavedName, '.png') 
             || fn:endsWith(post.postSavedName, '.jpeg') 
             || fn:endsWith(post.postSavedName, '.gif'))}">
    <img src="resources/uploads/${post.postSavedName}" 
         alt="썸네일"
         style="
           width: 30px;
           height: 30px;
           object-fit: cover;
           border: 1px solid #a983a3;
           border-radius: 4px;
           transition: transform 0.3s ease;
         "
         onmouseover="this.style.transform='scale(1.8)'"
         onmouseout="this.style.transform='scale(1)'"
    />
  </c:if>
</div>
</td>
								<td><fmt:formatDate value="${post.postTime}" pattern="yyyy-MM-dd HH:mm" /></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3" class="empty-message">등록된 게시글이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<div class="board-footer">
			<div class="pagination">
				<c:if test="${currentPage > 1}">
					<button
						onclick="location.href='noticeList.do?page=${currentPage - 1}'">&lt;</button>
				</c:if>
				<c:forEach begin="1" end="${totalPages}" var="pageNum">
					<button onclick="location.href='noticeList.do?page=${pageNum}'"
						class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
				</c:forEach>
				<c:if test="${currentPage < totalPages}">
					<button
						onclick="location.href='noticeList.do?page=${currentPage + 1}'">&gt;</button>
				</c:if>
			</div>
		</div>
	</div>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
