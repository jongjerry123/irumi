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
  .post-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
  .post-title { font-size: 20px; font-weight: bold; display: flex; align-items: center; gap: 10px; }
  .post-category { font-size: 14px; color: #aaa; background-color: #222; padding: 2px 8px; border-radius: 10px; }
  .post-meta { margin-bottom: 20px; font-size: 14px; color: #aaa; }
  .post-body { margin-bottom: 40px; line-height: 1.6; word-wrap: break-word; }
  .post-actions { display: flex; gap: 10px; }
  .btn, .btn-red { display: inline-flex; justify-content: center; align-items: center; padding: 8px 16px; min-width: 72px; height: 38px; font-size: 14px; border-radius: 6px; cursor: pointer; background-color: transparent; }
  .btn { border: 1px solid #666; color: #fff; }
  .btn-red { border: 1px solid #ff4c4c; color: #ff4c4c; }
  .comment-box { margin-top: 60px; }
  .comment-form { margin-bottom: 30px; display: flex; flex-direction: column; gap: 10px; }
  .comment-form textarea { width: 100%; height: 70px; padding: 10px; background-color: #1a1a1a; color: #fff; border: 1px solid #444; border-radius: 6px; resize: none; }
  .comment-form .submit-btn { align-self: flex-end; background-color: #A983A3; border: none; padding: 8px 18px; border-radius: 6px; color: #fff; cursor: pointer; }
  .comment-list { margin-top: 30px; }
  .comment-item { background-color: #1a1a1a; border: 1px solid #333; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
  .comment-item.reply { background-color: #191919; }
  .comment-meta { font-size: 13px; margin-bottom: 8px; color: #ccc; }
  .comment-content { margin-bottom: 10px; }
  .comment-actions { display: flex; gap: 12px; font-size: 13px; align-items: center; }
  .comment-actions form, .comment-actions button { display: flex; align-items: center; background: transparent; border: none; color: #ccc; cursor: pointer; }
  .comment-actions .icon-text { display: flex; align-items: center; gap: 4px; }
  .reply-form { margin-top: 10px; display: none; }
  .reply-form textarea { width: 100%; height: 60px; background-color: #1a1a1a; color: #fff; border: 1px solid #555; border-radius: 6px; padding: 8px; resize: none; }
  .reply-form .submit-btn { margin-top: 6px; background-color: #A983A3; border: none; padding: 6px 14px; border-radius: 6px; color: #fff; cursor: pointer; float: right; }
</style>
</head>

<body>
<div class="main-content">

  <div class="post-header">
    <div class="post-title">
      ${post.postTitle}
      <span class="post-category">${post.postType}</span>
    </div>
    <div class="post-actions">
      <c:choose>
        <c:when test="${loginUser.userId == post.postWriter}">
          <button class="btn" onclick="location.href='editPost.do?postId=${post.postId}'">수정</button>
          <form action="deletePost.do" method="post">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button type="submit" class="btn-red" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
          </form>
        </c:when>
        <c:otherwise>
          <form action="recommendPost.do" method="post">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button class="btn"><span class="icon-text">👍 ${post.postRecommend}</span></button>
          </form>
          <form action="reportPost.do" method="post">
            <input type="hidden" name="postId" value="${post.postId}" />
            <button class="btn-red"><span class="icon-text">🚨 ${post.postReportCount}</span></button>
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

  <div class="comment-box">
    <form class="comment-form" action="addComment.do" method="post">
  <input type="hidden" name="postId" value="${post.postId}" />
  <textarea name="commentContent" placeholder="댓글을 입력하세요."></textarea>
  
  <div style="display: flex; justify-content: space-between; margin-top: 10px;">
    <!-- 목록으로 버튼 -->
    <c:choose>
      <c:when test="${post.postType == '자유'}">
        <button type="button" class="btn" onclick="location.href='freeBoard.do'">목록으로</button>
      </c:when>
      <c:when test="${post.postType == '질문'}">
        <button type="button" class="btn" onclick="location.href='qnaList.do'">목록으로</button>
      </c:when>
      <c:when test="${post.postType == '공지'}">
        <button type="button" class="btn" onclick="location.href='noticeList.do'">목록으로</button>
      </c:when>
      <c:otherwise>
        <button type="button" class="btn" onclick="location.href='freeBoard.do'">목록으로</button>
      </c:otherwise>
    </c:choose>

    <!-- 질문등록(또는 새 댓글) 버튼 -->
    <button type="submit" class="submit-btn">
      <c:choose>
        <c:when test="${post.postType == '질문'}">질문 등록</c:when>
        <c:otherwise>새 댓글 달기</c:otherwise>
      </c:choose>
    </button>
  </div>
</form>

    <div class="comment-list">
      <c:forEach var="comment" items="${commentList}">
        <div class="comment-item ${comment.comParentId != null ? 'reply' : ''}" style="margin-left: ${comment.lvl * 20}px;">
          <div class="comment-meta">
            <c:if test="${comment.comParentId != null}">↪️</c:if>
            ${comment.comWrId} (${comment.comTime})
          </div>
          <div class="comment-content">${comment.comContent}</div>
          <div class="comment-actions">
            <form action="recommendComment.do" method="post">
              <input type="hidden" name="commentId" value="${comment.comId}" />
              <input type="hidden" name="postId" value="${post.postId}" />
              <button><span class="icon-text">👍 ${comment.comRecommend}</span></button>
            </form>
            <form action="reportComment.do" method="post">
              <input type="hidden" name="commentId" value="${comment.comId}" />
              <input type="hidden" name="postId" value="${post.postId}" />
              <button><span class="icon-text">🚨 ${comment.comReportCount}</span></button>
            </form>
            <form onsubmit="return false;">
              <button type="button" onclick="toggleReply(${comment.comId})">답글</button>
            </form>
            <c:if test="${loginUser.userId == comment.comWrId}">
              <form action="deleteComment.do" method="post">
                <input type="hidden" name="commentId" value="${comment.comId}" />
                <input type="hidden" name="postId" value="${post.postId}" />
                <button type="submit">댓글 삭제</button>
              </form>
            </c:if>
          </div>

          <div class="reply-form" id="reply-form-${comment.comId}">
            <form action="addComment.do" method="post">
              <input type="hidden" name="postId" value="${post.postId}" />
              <input type="hidden" name="parentId" value="${comment.comId}" />
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

<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>