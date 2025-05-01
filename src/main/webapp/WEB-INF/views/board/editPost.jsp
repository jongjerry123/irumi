<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 수정</title>
  <style>
    body { margin: 0; font-family: 'Noto Sans KR', sans-serif; background-color: #111; color: #fff; }
    .main-content { padding: 40px 140px; max-width: 800px; margin: 0 auto; }
    h2 { margin-bottom: 30px; color: #A983A3; }
    form { display: flex; flex-direction: column; gap: 16px; }
    label { font-size: 16px; margin-bottom: 6px; }
    input[type="text"], textarea, select {
      padding: 10px; border-radius: 6px; border: 1px solid #444;
      background-color: #1a1a1a; color: #fff; width: 100%;
    }
    textarea { resize: vertical; height: 200px; }
    .btn-submit, .btn-cancel {
      background-color: #A983A3; border: none; padding: 10px 24px;
      border-radius: 8px; color: #fff; cursor: pointer;
    }
    .btn-cancel { background-color: #555; }
    .btn-wrap { display: flex; justify-content: flex-end; gap: 10px; }
  </style>
</head>
<body>
<div class="main-content">
  <h2>게시글 수정</h2>

  <form action="updatePost.do" method="post">
    <input type="hidden" name="postId" value="${post.postId}" />
    <input type="hidden" name="postType" value="${post.postType}" />

    <label for="category">카테고리</label>
    <select id="category" name="category" disabled>
      <option value="일반" ${post.postType eq '일반' ? 'selected' : ''}>자유게시판</option>
      <option value="질문" ${post.postType eq '질문' ? 'selected' : ''}>Q&A</option>
      <c:if test="${loginUser.userAuthority eq '2'}">
        <option value="공지" ${post.postType eq '공지' ? 'selected' : ''}>공지사항</option>
      </c:if>
    </select>

    <label for="title">제목</label>
    <input type="text" id="title" name="postTitle" value="${post.postTitle}" required />

    <label for="content">내용</label>
    <textarea id="content" name="postContent" required>${post.postContent}</textarea>

    <div class="btn-wrap">
      <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
      <button type="submit" class="btn-submit">수정 완료</button>
    </div>
  </form>
</div>

<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>