<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${post.postTitle}</title>
  <style>
    body {
      background-color: #111;
      color: #fff;
      font-family: 'Noto Sans KR', sans-serif;
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
    }

    .post-title {
      font-size: 20px;
      font-weight: bold;
    }

    .post-meta {
      margin: 10px 0;
      font-size: 14px;
      color: #aaa;
    }

    .post-body {
      margin: 30px 0;
      line-height: 1.6;
    }

    .post-actions {
      display: flex;
      gap: 10px;
      margin-bottom: 30px;
    }

    .btn {
      background-color: transparent;
      border: 1px solid #666;
      color: #fff;
      border-radius: 6px;
      padding: 6px 12px;
      cursor: pointer;
      font-size: 14px;
    }

    .btn-red {
      border-color: #ff4c4c;
      color: #ff4c4c;
    }

    .comment-box {
      margin-top: 40px;
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

    .comment-form button {
      margin-top: 10px;
      float: right;
      background-color: #A983A3;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      color: #fff;
      cursor: pointer;
    }

    .comment-item {
      margin-top: 20px;
      background-color: #1a1a1a;
      border: 1px solid #333;
      padding: 15px;
      border-radius: 8px;
      position: relative;
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
      gap: 8px;
      font-size: 12px;
    }

    .comment-actions button {
      background: transparent;
      color: #ccc;
      border: none;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="main-content">

  <div class="post-header">
    <div class="post-title">${post.postTitle}</div>
    <div class="post-actions">
      <c:choose>
        <c:when test="${loginUser.userId == post.postWriter}">
          <button class="btn" onclick="location.href='editPost.do?postId=${post.postId}'">수정</button>
          <button class="btn btn-red">삭제</button>
        </c:when>
        <c:when test="${loginUser.userAuthority == '2'}">
          <button class="btn">신고</button>
          <button class="btn btn-red">불량이용자 등록</button>
        </c:when>
        <c:otherwise>
          <button class="btn">신고</button>
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
      <textarea name="commentContent" placeholder="새 댓글을 작성해주세요."></textarea>
      <button type="submit">새 댓글 달기</button>
    </form>

    <div class="comment-list">
      <c:forEach var="comment" items="${commentList}">
        <div class="comment-item">
          <div class="comment-meta">
            ${comment.comWrId} (${comment.comTime})
            <c:if test="${comment.parentId != null}">
              <span style="color: #777;">[답글]</span>
            </c:if>
          </div>
          <div class="comment-content">${comment.comContent}</div>
          <div class="comment-actions">
            <button>👍 ${comment.comRecommend}</button>
            <button>답글</button>
            <c:choose>
              <c:when test="${loginUser.userId == comment.comWrId}">
                <button>댓글 삭제</button>
              </c:when>
              <c:otherwise>
                <button>신고</button>
              </c:otherwise>
            </c:choose>
            <c:if test="${loginUser.userAuthority == '2'}">
              <button class="btn-red">불량이용자 등록</button>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>

</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>