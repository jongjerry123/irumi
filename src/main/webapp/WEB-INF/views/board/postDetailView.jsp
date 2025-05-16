<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${post.postTitle}</title>
<style>
body {
	background-color: #000 !important;
	color: #fff;
}

.main-content {
	max-width: 900px;
	margin: 40px auto;
	padding: 0 20px;
}

.post-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.post-title {
	font-size: 20px;
	font-weight: bold;
	display: flex;
	align-items: center;
	gap: 10px;
}

.post-category {
	font-size: 14px;
	color: #aaa;
	background-color: #222;
	padding: 2px 8px;
	border-radius: 10px;
}

.post-meta {
	margin-bottom: 20px;
	font-size: 14px;
	color: #aaa;
}

.post-body {
	margin-bottom: 40px;
	line-height: 1.6;
	word-wrap: break-word;
}

.post-actions {
	display: flex;
	gap: 10px;
}

.btn, .btn-red {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	padding: 8px 16px;
	min-width: 72px;
	height: 38px;
	font-size: 14px;
	border-radius: 6px;
	cursor: pointer;
	background-color: transparent;
	transition: all 0.3s ease; /* 부드러운 효과 추가 */
}

/* 일반 버튼 */
.btn {
	border: 1px solid #666;
	color: #fff;
}

.btn:hover {
	border-color: #A983A3;
	color: #A983A3;
	box-shadow: 0 2px 5px rgba(169, 131, 163, 0.3);
}

/* 삭제 버튼 */
.btn-red {
	border: 1px solid #ff4c4c;
	color: #ff4c4c;
	background-color: transparent;
	transition: all 0.3s ease;
}

.btn-red:hover {
	background-color: rgba(255, 76, 76, 0.15); /* 더 강한 대비 */
	color: #fff; /* 글씨를 흰색으로 반전 */
	box-shadow: 0 3px 8px rgba(255, 76, 76, 0.4);
	transform: translateY(-1px);
}

.comment-box {
	margin-top: 60px;
}

.comment-form {
	margin-bottom: 30px;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.comment-form textarea {
	width: 100%;
	height: 70px;
	padding: 10px;
	background-color: #1a1a1a;
	color: #fff;
	border: 1px solid #444;
	border-radius: 6px;
	resize: none;
}

.comment-form .submit-btn {
	align-self: flex-end;
	background-color: #A983A3;
	border: none;
	padding: 8px 18px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	transition: all 0.3s ease;
	box-shadow: 0 2px 4px rgba(169, 131, 163, 0.2);
}

.comment-form .submit-btn:hover {
	background-color: #8c6c8c;
	box-shadow: 0 4px 8px rgba(169, 131, 163, 0.4);
	transform: translateY(-1px);
}

.comment-list {
	margin-top: 30px;
}

.comment-item {
	background-color: #1a1a1a;
	border: 1px solid #333;
	padding: 15px;
	border-radius: 8px;
	margin-bottom: 15px;
}

.comment-item.reply {
	margin-left: 40px; /* 기존보다 깊이 */
	background-color: #161616; /* 더 어두운 배경 */
	border-left: 3px solid #A983A3; /* 시각적 구분용 세로선 */
	padding-left: 14px;
}

.comment-item.reply .comment-meta {
	color: #999;
}

.comment-item:not(.reply) {
	border-top: 1px solid #A983A3;
	padding-top: 20px;
	margin-top: 30px;
}

.comment-meta {
	font-size: 13px;
	margin-bottom: 8px;
	color: #ccc;
}

.comment-content {
	margin-bottom: 10px;
}

.comment-actions {
	display: flex;
	gap: 12px;
	font-size: 13px;
	align-items: center;
}

.comment-actions form, .comment-actions button {
	display: flex;
	align-items: center;
	background: transparent;
	border: none;
	color: #ccc;
	cursor: pointer;
}

.comment-actions .icon-text {
	display: flex;
	align-items: center;
	gap: 4px;
}

.reply-form {
	margin-top: 10px;
	display: none;
	text-align: right;
}

.reply-form textarea {
	width: 100%;
	height: 60px;
	background-color: #1a1a1a;
	color: #fff;
	border: 1px solid #555;
	border-radius: 6px;
	padding: 8px;
	resize: none;
}

.reply-form .submit-btn {
  margin-top: 20px;
  background-color: #A983A3;
  border: none;
  padding: 6px 14px;
  border-radius: 6px;
  color: #fff;
  cursor: pointer;
  text-align: right;
  display: inline-block;  
}

.reply-form .submit-btn:hover {
	background-color: #8c6c8c;
	box-shadow: 0 4px 8px rgba(169, 131, 163, 0.4);
	transform: translateY(-1px);
}

</style>
</head>

<body>
<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="main-content">

		<div class="post-header">
			<div class="post-title">
				${post.postTitle} <span class="post-category">${post.postType}</span>
			</div>
			<div class="post-actions">
				<c:choose>
					<c:when
						test="${loginUser.userId == post.postWriter || loginUser.userAuthority == 2}">
						<button class="btn"
							onclick="location.href='editPost.do?postId=${post.postId}'">수정</button>
						<form action="deletePost.do" method="post">
							<input type="hidden" name="postId" value="${post.postId}" />
							<button type="submit" class="btn-red"
								onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
						</form>
					</c:when>
					<c:otherwise>
						<form action="recommendPost.do" method="post">
							<input type="hidden" name="postId" value="${post.postId}" />
							<button class="btn">
								<span class="icon-text">👍 ${post.postRecommend}</span>
							</button>
						</form>
						<form action="reportPost.do" method="post">
							<input type="hidden" name="postId" value="${post.postId}" />
							<button class="btn-red">
								<span class="icon-text">🚨 ${post.postReportCount}</span>
							</button>
						</form>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="post-meta">
			<c:choose>
				<c:when test="${loginUser.userId == post.postWriter}">
					<span style="color: #A983A3; font-weight: bold;">${post.postWriter}</span>
				</c:when>
				<c:otherwise>
      ${post.postWriter}
    </c:otherwise>
			</c:choose>
			|
			<fmt:formatDate value="${post.postTime}" pattern="yyyy-MM-dd HH:mm" />
			| 조회수 ${post.postViewCount}
		</div>

		<div class="post-body">${post.postContent}</div>
		<c:if test="${not empty post.postOriginalName}">
			<div style="margin-top: 30px;">
				<p style="font-weight: bold;">
					첨부파일: <a href="resources/uploads/${post.postSavedName}"
						download="${post.postOriginalName}" style="color: #A983A3;">${post.postOriginalName}</a>
				</p>

				<c:if
					test="${fn:endsWith(post.postSavedName, '.jpg') 
                || fn:endsWith(post.postSavedName, '.png') 
                || fn:endsWith(post.postSavedName, '.jpeg') 
                || fn:endsWith(post.postSavedName, '.gif')}">
					<img src="resources/uploads/${post.postSavedName}" alt="첨부 이미지"
						style="max-width: 80%; max-height: 300px; object-fit: contain; margin-top: 12px; border-radius: 8px; border: 1px solid #a983a3; display: block;" />
				</c:if>
			</div>
		</c:if>
		<div class="comment-box">
			<form class="comment-form" action="addComment.do" method="post" onsubmit="return validateComment(this)">
				<input type="hidden" name="postId" value="${post.postId}" />
				<textarea name="commentContent" placeholder="댓글을 입력하세요."></textarea>

				<div
					style="display: flex; justify-content: space-between; margin-top: 10px;">
					<!-- 목록으로 버튼 -->
					<c:choose>
						<c:when test="${post.postType == '자유'}">
							<button type="button" class="btn"
								onclick="location.href='freeBoard.do'">목록으로</button>
						</c:when>
						<c:when test="${post.postType == '질문'}">
							<button type="button" class="btn"
								onclick="location.href='qnaList.do'">목록으로</button>
						</c:when>
						<c:when test="${post.postType == '공지'}">
							<button type="button" class="btn"
								onclick="location.href='noticeList.do'">목록으로</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn"
								onclick="location.href='freeBoard.do'">목록으로</button>
						</c:otherwise>
					</c:choose>


					<!-- 질문등록(또는 새 댓글) 버튼 -->
					<button type="submit" class="submit-btn">
						<c:choose>
							<c:when test="${post.postType == '질문'}">답변 등록</c:when>
							<c:otherwise>새 댓글 달기</c:otherwise>
						</c:choose>
					</button>
				</div>
			</form>

			<div class="comment-list">
				<c:forEach var="comment" items="${commentList}">
					<div
						class="comment-item ${comment.comParentId != null ? 'reply' : ''}"
						style="margin-left: ${comment.lvl * 20}px;">
						<div class="comment-meta">
							<c:if test="${comment.comParentId != null}">↪️</c:if>

							<c:choose>
								<c:when test="${loginUser.userId == comment.comWrId}">
									<span style="color: #A983A3; font-weight: bold;">${comment.comWrId}</span>
								</c:when>
								<c:otherwise>
      ${comment.comWrId}
    </c:otherwise>
							</c:choose>

							<c:if test="${comment.comWrId == post.postWriter}">
								<span style="color: #A983A3;"> (글쓴이)</span>
							</c:if>
							<c:if
								test="${comment.comWrId == 'admin' || comment.comWrId == 'administrator' || comment.comWrId == '관리자'}">
								<span style="color: #ff4c4c;"> (관리자)</span>
							</c:if>

							(
							<fmt:formatDate value="${comment.comTime}"
								pattern="yyyy-MM-dd HH:mm" />
							)
						</div>
						<div class="comment-content">${comment.comContent}</div>
						<div class="comment-actions">
							<form action="recommendComment.do" method="post">
								<input type="hidden" name="commentId" value="${comment.comId}" />
								<input type="hidden" name="postId" value="${post.postId}" />
								<button>
									<span class="icon-text">👍 ${comment.comRecommend}</span>
								</button>
							</form>
							<form action="reportComment.do" method="post">
								<input type="hidden" name="commentId" value="${comment.comId}" />
								<input type="hidden" name="postId" value="${post.postId}" />
								<button>
									<span class="icon-text">🚨 ${comment.comReportCount}</span>
								</button>
							</form>
							<form onsubmit="return false;">
								<button type="button" onclick="toggleReply(${comment.comId})">답글</button>
							</form>
							<c:if
								test="${loginUser.userId == comment.comWrId || loginUser.userAuthority == 2}">
								<form action="deleteComment.do" method="post">
									<input type="hidden" name="commentId" value="${comment.comId}" />
									<input type="hidden" name="postId" value="${post.postId}" />
									<button type="submit">댓글 삭제</button>
								</form>
							</c:if>
						</div>

						<div class="reply-form" id="reply-form-${comment.comId}">
							<form action="addComment.do" method="post" onsubmit="return validateComment(this)">
								<input type="hidden" name="postId" value="${post.postId}" /> <input
									type="hidden" name="parentId" value="${comment.comId}" />
								<textarea name="commentContent" placeholder="답글을 입력하세요."></textarea>
								<button type="submit" class="submit-btn">답글 등록</button>
							</form>
						</div>

					</div>
				</c:forEach>
			</div>
		</div>

	</div>

	<script>
function toggleReply(parentId) {
  const replyForm = document.getElementById('reply-form-' + parentId);
  replyForm.style.display = (replyForm.style.display === 'block') ? 'none' : 'block';
}
</script>

<script>
function validateComment(form) {
  const commentInput = form.querySelector('textarea[name="commentContent"]');
  if (!commentInput || commentInput.value.trim() === '') {
    alert('댓글 내용을 입력해주세요.');
    return false;
  }
  return true;
}
</script>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>