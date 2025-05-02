<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신고된 댓글 관리</title>
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
	border: 1px solid #333;
	border-radius: 12px;
	overflow: hidden;  
	margin-top: 40px;         
}

th, td {
	border: 1px solid #333;
	padding: 14px;
	text-align: center;
}

th {
	background-color: #000;
}

td {
	background-color: #1a1a1a;
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

<script>
    function getSelectedCommentIds() {
      return Array.from(document.querySelectorAll('input[name="selectedComments"]:checked'))
                  .map(cb => cb.value);
    }

    function validateSelectionOrAlert() {
      const selected = getSelectedCommentIds();
      if (selected.length === 0) {
        alert("댓글을 선택해주세요.");
        return null;
      }
      return selected;
    }
    
    function deleteSelectedComments() {
        const selected = validateSelectionOrAlert();
        if (!selected) return;
        document.getElementById("deleteCommentForm").action = "deleteSelectedComments.do";
        document.getElementById("deleteCommentForm").submit();
      }

    function registerBadUsers() {
        const selected = validateSelectionOrAlert();
        if (!selected) return;

        const reason = prompt("신고 사유를 입력해주세요.");
        if (!reason || reason.trim() === "") {
            alert("신고 사유는 필수입니다.");
            return;
        }

        const formData = new URLSearchParams();
        selected.forEach(id => formData.append("selectedComments", id));
        formData.append("reason", reason);  

        fetch("registerBadUsersFromComments.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: formData.toString()
        })
        .then(res => {
            if (res.redirected) {
                alert("등록되었습니다.");
                window.location.href = res.url;
            } else {
                alert("등록 실패");
            }
        });
    }
  </script>
</head>
<body>
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

		<!-- 신고 카테고리 탭 -->
		<div class="tabs" style="margin-top: 30px;">
			<button onclick="location.href='reportedPosts.do'">신고된 게시글</button>
			<button class="active">신고된 댓글</button>
			<button onclick="location.href='badUserList.do'">불량 이용자 목록</button>
		</div>

		<form id="deleteCommentForm" action="deleteSelectedComments.do"
			method="post">
			<table>
				<thead>
					<tr>
						<th>작성자</th>
						<th>댓글 내용</th>
						<th>신고수</th>
						<th>선택</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="comment" items="${reportedCommentList}">
						<tr>
							<td>${comment.comWrId}</td>
							<td><a href="postDetail.do?postId=${comment.postId}"
								style="color: #A983A3; text-decoration: underline;">
									${comment.comContent} </a></td>
							<td>${comment.comReportCount}</td>
							<td><input type="checkbox" name="selectedComments"
								value="${comment.comId}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<div class="bottom-bar">
				<div class="left">신고된 댓글 수: ${fn:length(reportedCommentList)}개</div>
				<div class="right">
					<button type="button" class="btn-action"
						onclick="deleteSelectedComments()">선택한 댓글 삭제</button>
					<button type="button" class="btn-action btn-danger"
						onclick="registerBadUsers()">불량 이용자 등록</button>
				</div>
			</div>
		</form>

		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<button
					onclick="location.href='reportedComments.do?page=${currentPage - 1}'">&lt;</button>
			</c:if>
			<c:forEach begin="1" end="${totalPages}" var="pageNum">
				<button
					onclick="location.href='reportedComments.do?page=${pageNum}'"
					class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
			</c:forEach>
			<c:if test="${currentPage < totalPages}">
				<button
					onclick="location.href='reportedComments.do?page=${currentPage + 1}'">&gt;</button>
			</c:if>
		</div>

	</div>
	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>