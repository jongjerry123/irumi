<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #111;
	color: #fff;
}

.main-content {
	padding: 40px 140px;
	max-width: 800px;
	margin: 0 auto;
}

h2 {
	margin-bottom: 30px;
	color: #A983A3;
}

form {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

label {
	font-size: 16px;
	margin-bottom: 6px;
}

input[type="text"], textarea, select {
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #444;
	background-color: #1a1a1a;
	color: #fff;
	width: 100%;
}

textarea {
	resize: vertical;
	height: 200px;
}

.btn-wrap {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.btn-submit, .btn-cancel {
	padding: 10px 24px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	transition: all 0.3s ease;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
}

/* 제출 버튼: 강조색 기반 */
.btn-submit {
	background-color: #A983A3;
	border: none;
}

.btn-submit:hover {
	background-color: #8c6c8c;
	box-shadow: 0 4px 8px rgba(169, 131, 163, 0.4);
	transform: translateY(-1px);
}

/* 취소 버튼: 중간 회색 기반 */
.btn-cancel {
	background-color: #444;
	border: none;
}

.btn-cancel:hover {
	background-color: #666;
	box-shadow: 0 3px 6px rgba(255, 255, 255, 0.1);
	transform: translateY(-1px);
}
</style>
<script>
    function updateHeaderAndType(select) {
      const type = select.value;
      const header = document.getElementById('post-header');
      const hiddenInput = document.querySelector('input[name="postType"]');

      switch (type) {
        case '질문':
          header.innerText = '질문 등록';
          break;
        case '공지':
          header.innerText = '공지사항 등록';
          break;
        default:
          header.innerText = '글쓰기';
      }

      hiddenInput.value = type;
    }
  </script>
</head>
<body>
	<div class="main-content">
		<h2 id="post-header">
			<c:choose>
				<c:when test="${param.type eq '질문'}">질문 등록</c:when>
				<c:when test="${param.type eq '공지'}">공지사항 등록</c:when>
				<c:otherwise>글쓰기</c:otherwise>
			</c:choose>
		</h2>

		<form action="insertPost.do" method="post">
			<input type="hidden" name="postType" value="${param.type}" /> <label
				for="category">카테고리</label> <select id="category" name="category"
				onchange="updateHeaderAndType(this)">
				<option value="일반" ${param.type eq '일반' ? 'selected' : ''}>자유게시판</option>
				<option value="질문" ${param.type eq '질문' ? 'selected' : ''}>Q&A</option>
				<c:if test="${loginUser.userAuthority eq '2'}">
					<option value="공지" ${param.type eq '공지' ? 'selected' : ''}>공지사항</option>
				</c:if>
			</select> <label for="title">제목</label> <input type="text" id="title"
				name="postTitle" required /> <label for="content">내용</label>
			<textarea id="content" name="postContent" required></textarea>

			<div style="display: flex; justify-content: flex-end; gap: 8px;">
				<button type="button" class="btn-submit" onclick="history.back()">취소</button>
				<button type="submit" class="btn-submit">등록</button>
			</div>
		</form>
	</div>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>