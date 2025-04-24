<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>불량 이용자 관리</title>
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
    .tabs {
      display: flex;
      gap: 12px;
      margin-bottom: 30px;
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
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    th, td {
      border: 1px solid #444;
      padding: 12px;
      text-align: center;
    }
    th {
      background-color: #222;
    }
    td {
      background-color: #1a1a1a;
    }
    .btn-container {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 30px;
    }
    .btn-action {
      background-color: transparent;
      border: 1px solid #A983A3;
      color: #A983A3;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
    }
    .btn-danger {
      background-color: transparent;
      border: 1px solid #ff4c4c;
      color: #ff4c4c;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
    }
    .total-count {
      margin-top: 20px;
      font-size: 14px;
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
  </style>
</head>
<body>
<div class="main-content">
  <div class="tabs">
    <button class="active">신고된 게시글</button>
    <button onclick="location.href='reportedComments.do'">신고된 댓글</button>
    <button onclick="location.href='badUserList.do'">불량 이용자 목록</button>
  </div>

  <table>
    <thead>
      <tr>
        <th>작성자</th>
        <th>신고된 게시글 제목</th>
        <th>신고수</th>
        <th>선택</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="post" items="${reportedPostList}">
        <tr>
          <td>${post.writer}</td>
          <td>${post.title}</td>
          <td>${post.reportCount}</td>
          <td><input type="checkbox" name="selectedPosts" value="${post.id}" /></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div class="total-count">신고된 게시글 수: ${fn:length(reportedPostList)}개</div>

  <div class="btn-container">
    <button class="btn-action">선택한 게시글 삭제</button>
    <button class="btn-action">불량 이용자 등록</button>
  </div>

  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <button onclick="location.href='reportedPosts.do?page=${currentPage - 1}'">&lt;</button>
    </c:if>
    <c:forEach begin="1" end="${totalPages}" var="pageNum">
      <button onclick="location.href='reportedPosts.do?page=${pageNum}'" class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
      <button onclick="location.href='reportedPosts.do?page=${currentPage + 1}'">&gt;</button>
    </c:if>
  </div>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
