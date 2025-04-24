<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시글 작성</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #111;
      color: #fff;
    }
    .main-content {
      max-width: 800px;
      margin: 80px auto;
      padding: 40px;
    }
    h2 {
      margin-bottom: 30px;
      font-size: 24px;
    }
    .form-group {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }
    .form-group label {
      width: 100px;
      font-weight: bold;
    }
    .category-select {
      display: flex;
      gap: 10px;
    }
    .category-select button {
      padding: 8px 16px;
      border-radius: 10px;
      border: 1px solid transparent;
      background-color: #2d2d2d;
      color: #fff;
      cursor: pointer;
    }
    .category-select .selected {
      border: 1px solid #A983A3;
      color: #A983A3;
    }
    .form-group input[type="text"],
    .form-group textarea {
      flex: 1;
      padding: 12px;
      border: none;
      border-radius: 10px;
      background-color: #2d2d2d;
      color: #fff;
      font-size: 14px;
    }
    .form-group textarea {
      height: 200px;
      resize: none;
    }
    .button-group {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 30px;
    }
    .button-group button {
      padding: 10px 20px;
      border-radius: 10px;
      border: 1px solid #555;
      background-color: #2d2d2d;
      color: #fff;
      cursor: pointer;
    }
    .button-group .submit {
      background-color: #A983A3;
      color: white;
      border: none;
    }
  </style>
</head>
<body>
  <div class="main-content">
    <h2>게시글 작성하기</h2>
    <form action="board/insertPost.do" method="post">
      <div class="form-group">
        <label>카테고리</label>
        <div class="category-select">
          <button type="button" class="selected">자유 주제</button>
          <button type="button">면접/취업 후기</button>
          <button type="button">스터디 모집</button>
          <button type="button">QnA</button>
        </div>
      </div>
      <div class="form-group">
        <label for="postTitle">글 제목</label>
        <input type="text" id="postTitle" name="postTitle" placeholder="게시글 제목을 적어주세요..." required />
      </div>
      <div class="form-group">
        <label for="postContent">글 본문</label>
        <textarea id="postContent" name="postContent" placeholder="게시글 내용을 적어주세요..." required></textarea>
      </div>
      <div class="button-group">
        <button type="button" onclick="history.back()">닫기</button>
        <button type="submit" class="submit">등록하기</button>
      </div>
    </form>
  </div>
  <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
