<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    .btn-submit {
      align-self: flex-end;
      background-color: #A983A3;
      border: none;
      padding: 10px 24px;
      border-radius: 8px;
      color: #fff;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="main-content">
  <h2>${param.type == 'qna' ? '질문 등록' : '글쓰기'}</h2>
  <form action="insertPost.do" method="post">
    <input type="hidden" name="postType" value="${param.type}" />
    <label for="category">카테고리</label>
    <select id="category" onchange="document.querySelector('[name=postType]').value = this.value">
      <option value="free" ${param.type == 'free' ? 'selected' : ''}>자유게시판</option>
      <option value="qna" ${param.type == 'qna' ? 'selected' : ''}>Q&A</option>
    </select>

    <label for="title">제목</label>
    <input type="text" id="title" name="postTitle" required />

    <label for="content">내용</label>
    <textarea id="content" name="postContent" required></textarea>

    <button type="submit" class="btn-submit">등록</button>
  </form>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
