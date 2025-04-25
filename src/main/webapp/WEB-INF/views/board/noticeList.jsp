<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
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
    .filters {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      min-height: 50px;
    }
    .board-header {
      display: flex;
      align-items: center;
      margin-top: 10px;
    }
    .write-btn {
      background-color: #A983A3;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      color: #fff;
      cursor: pointer;
    }
    table.board-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
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
    }
    .empty-message {
      text-align: center;
      padding: 40px;
      font-size: 16px;
      color: #aaa;
    }
    .pagination {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-top: 20px;
    }
    .pagination button {
      background-color: #222;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
    }
    .admin-btn {
      background-color: #222;
      border: 1px solid #fff;
      border-radius: 10px;
      padding: 8px;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="main-content">
  <div class="category-bar">
    <h2>커뮤니티</h2>
    <div class="tabs">
      <button onclick="location.href='freeBoard.do'">자유 게시판</button>
      <button onclick="location.href='qnaList.do'">Q&A</button>
      <button class="active">공지사항</button>

      <!-- 관리자만 보는 벨 버튼 -->
      <c:if test="${loginUser.userAuthority == '2'}">
  <button class="admin-btn" onclick="location.href='badUserList.do'">
    <img src="/resources/img/bell.png" alt="관리자 알림" height="20" />
  </button>
</c:if>
    </div>
  </div>

  <div class="filters">
    <div></div>
    <div class="board-header">
      <c:if test="${loginUser.userAuthority == '2'}">
        <button class="write-btn" onclick="location.href='board/writePost.do?type=공지'">✏ 공지 등록</button>
      </c:if>
    </div>
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
            <td><a href="detailPost.do?id=${post.postId}" style="color: #A983A3">${post.postTitle}</a></td>
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

  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <button onclick="location.href='noticeList.do?page=${currentPage - 1}'">&lt;</button>
    </c:if>
    <c:forEach begin="1" end="${totalPages}" var="pageNum">
      <button onclick="location.href='noticeList.do?page=${pageNum}'"
              class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
      <button onclick="location.href='noticeList.do?page=${currentPage + 1}'">&gt;</button>
    </c:if>
  </div>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
