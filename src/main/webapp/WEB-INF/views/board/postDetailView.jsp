<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${post.postTitle}</title>
<style>
  body { background-color: #111; color: #fff; font-family: 'Noto Sans KR', sans-serif; }
  .main-content { max-width: 900px; margin: 40px auto; padding: 0 20px; }
  .post-header { display: flex; justify-content: space-between; align-items: center; }
  .post-title { font-size: 20px; font-weight: bold; display: flex; align-items: center; gap: 10px; }
  .post-category { font-size: 14px; color: #aaa; background-color: #222; padding: 2px 8px; border-radius: 10px; }
  .post-meta { margin: 10px 0; font-size: 14px; color: #aaa; }
  .post-body { margin: 30px 0; line-height: 1.6; }
  .post-actions { display: flex; gap: 10px; margin-bottom: 30px; }
  .btn { background-color: transparent; border: 1px solid #666; color: #fff; border-radius: 6px; padding: 6px 12px; cursor: pointer; font-size: 14px; }
  .btn-red { border-color: #ff4c4c; color: #ff4c4c; }
  .comment-box { margin-top: 40px; }
  .comment-form { margin-bottom: 20px; }
  .comment-form textarea { width: 100%; height: 70px; padding: 10px; background-color: #1a1a1a; color: #fff; border: 1px solid #444; border-radius: 6px; resize: none; }
  .comment-form button { margin-top: 10px; background-color: #A983A3; border: none; padding: 8px 16px; border-radius: 6px; color: #fff; cursor: pointer; float: right; }
  .comment-item { margin-top: 20px; background-color: #1a1a1a; border: 1px solid #333; padding: 15px; border-radius: 8px; }
  .comment-meta { font-size: 13px; margin-bottom: 8px; color: #ccc; }
  .comment-content { margin-bottom: 10px; }
  .comment-actions { display: flex; gap: 8px; font-size: 12px; }
  .comment-actions form { display: inline; }
  .comment-actions button { background: transparent; color: #ccc; border: none; cursor: pointer; }
  .reply-form { margin-top: 10px; }
</style>
</head>

<body>
<div class="main-content">

  <!-- 게시글 제목/카테고리/수정/삭제/추천/신고 -->
  <div class="post-header">
    <div class="post-title">
      ${post.postTitle}
      <span class="post-category">${post.postType}</span>
    </div>
    <div class="post-actions">
      <c:choose>
        <c:when test="${loginUser.userId == post.postWriter}">
          <button class="btn" onclick="location.href='editPost.do?postId=${post.postId}'">수정</button>
          <form action="deletePost.do" method="post" style="display:inline;">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button type="submit" class="btn btn-red" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
          </form>
        </c:when>
        <c:otherwise>
          <form action="recommendPost.do" method="post" style="display:inline;">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button type="submit" class="btn">추천 👍 (${post.postRecommend})</button>
          </form>
          <form action="reportPost.do" method="post" style="display:inline;">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button type="submit" class="btn btn-red">신고 🚨</button>
          </form>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="post-meta">
    ${post.postWriter} | ${post.postTime} | 조회수 ${post.postViewCount}
  </div>

  <div class="post-body">
    ${post.postContent}
  </div>

  <!-- 댓글 작성 -->
  <div class="comment-box">
    <form class="comment-form" action="addComment.do" method="post">
      <input type="hidden" name="postId" value="${post.postId}" />
      <input type="hidden" name="comParentId" value="" id="comParentId" />
      <textarea name="commentContent" placeholder="댓글을 입력하세요."></textarea>
      <button type="submit">
        <c:choose>
          <c:when test="${post.postType == '질문'}">질문 등록</c:when>
          <c:otherwise>새 댓글 달기</c:otherwise>
        </c:choose>
      </button>
    </form>

    <!-- 댓글 목록 -->
    <div class="comment-list">
      <c:forEach var="comment" items="${commentList}">
        <div class="comment-item">
          <div class="comment-meta">
            ${comment.comWrId} (${comment.comTime})
            <c:if test="${comment.comParentId != null}">
              <span style="color: #777;">[답글]</span>
            </c:if>
          </div>
          <div class="comment-content">${comment.comContent}</div>
          <div class="comment-actions">
            <form action="recommendComment.do" method="post">
              <input type="hidden" name="commentId" value="${comment.comId}" />
              <button type="submit">👍 ${comment.comRecommend}</button>
            </form>
            <button onclick="openReply(${comment.comId})">답글</button>
            <c:choose>
              <c:when test="${loginUser.userId == comment.comWrId}">
                <!-- 내 댓글이면 삭제 -->
                <form action="deleteComment.do" method="post" style="display:inline;">
                  <input type="hidden" name="commentId" value="${comment.comId}" />
                  <button type="submit">댓글 삭제</button>
                </form>
              </c:when>
              <c:otherwise>
                <!-- 타인 댓글이면 신고 -->
                <form action="reportComment.do" method="post" style="display:inline;">
                  <input type="hidden" name="commentId" value="${comment.comId}" />
                  <button type="submit">신고 🚨</button>
                </form>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- 답글 폼 -->
          <div class="reply-form" id="reply-form-${comment.comId}" style="display:none;">
            <form action="addComment.do" method="post">
              <input type="hidden" name="postId" value="${post.postId}" />
              <input type="hidden" name="comParentId" value="${comment.comId}" />
              <textarea name="commentContent" placeholder="답글을 입력하세요." style="margin-top:10px;"></textarea>
              <button type="submit" style="margin-top:5px;">답글 등록</button>
            </form>
          </div>
        </div>
      </c:forEach>
    </div>

  </div>

</div>

<script>
function openReply(parentId) {
  var replyForm = document.getElementById('reply-form-' + parentId);
  if (replyForm.style.display === 'none') {
    replyForm.style.display = 'block';
  } else {
    replyForm.style.display = 'none';
  }
}
</script>

<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>