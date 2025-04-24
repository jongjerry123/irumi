<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지사항</title>
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
    }
    .tabs {
      display: flex;
      gap: 12px;
    }
    .tabs button {
      background-color: #222;
      color: #fff;
      padding: 10px 24px;
      border: 1px solid transparent;
      border-radius: 10px;
      cursor: pointer;
    }
    .tabs .active {
      border: 1px solid #A983A3;
      color: #A983A3;
    }
    .board-header {
      display: flex;
      justify-content: flex-end;
      margin-bottom: 20px;
    }
    .board-header .write-btn {
      background-color: #A983A3;
      color: #fff;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      cursor: pointer;
    }
    table.board-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    table.board-table th, table.board-table td {
      border: 1px solid #444;
      padding: 12px;
      text-align: center;
    }
    table.board-table th {
      background-color: #222;
    }
    table.board-table td {
      background-color: #1a1a1a;
    }
    table.board-table td:nth-child(2) {
      text-align: left;
      padding-left: 20px;
      width: 70%;
    }
    table.board-table td:nth-child(1),
    table.board-table td:nth-child(3) {
      width: 15%;
    }
    .empty-message {
      text-align: center;
      padding: 40px;
      font-size: 16px;
      color: #aaa;
    }
  </style>
</head>
<body>
  <div class="main-content">
    <div class="category-bar">
      <h2>공지사항</h2>
      <div class="tabs">
        <button onclick="location.href='boardPage.do'">자유게시판</button>
        <button onclick="location.href='qnaList.do'">Q&amp;A</button>
        <button class="active" onclick="location.href='noticeList.do'">공지사항</button>
      </div>
    </div>

    <div class="board-header">
      <c:if test="${loginUser.userType eq 'admin'}">
        <button class="write-btn" onclick="location.href='board/insertPost.do'">✏ 글쓰기</button>
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
                <td>${post.postTitle}</td>
                <td>${post.postTime}</td>
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
  </div>
  <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
