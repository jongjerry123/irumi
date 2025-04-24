<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>불량 이용자 목록</title>
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

    .top-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 30px;
    }

    .section-title {
      font-size: 24px;
      font-weight: 600;
      margin-right: 30px;
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

    .admin-btn {
      background-color: #222;
      border: 1px solid #ff4c4c;
      border-radius: 10px;
      padding: 8px;
      margin-left: auto;
      cursor: pointer;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin: 40px 0 20px 0;
    }

    th, td {
      border: 1px solid #444;
      padding: 14px;
      text-align: center;
    }

    th {
      background-color: #222;
    }

    td {
      background-color: #1a1a1a;
    }

    .bottom-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 60px;
    }

    .bottom-bar .left {
      font-size: 14px;
    }

    .bottom-bar .right {
      display: flex;
      gap: 10px;
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
      border: 1px solid #ff4c4c;
      color: #ff4c4c;
    }

    .pagination {
      display: flex;
      gap: 10px;
      justify-content: center;
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

    .pagination button.selected {
      border: 1px solid #A983A3;
      color: #A983A3;
    }

    input[type="checkbox"] {
      accent-color: #A983A3;
      width: 18px;
      height: 18px;
    }
  </style>
</head>
<body>
<div class="main-content">
  <!-- 상단 구조 (타이틀 + 게시판 탭 + 벨버튼) -->
  <div class="top-bar">
    <h2 class="section-title">불량 이용자 관리</h2>

    <div class="tabs">
      <button onclick="location.href='boardPage.do'">자유 주제</button>
      <button onclick="location.href='qnaList.do'">QnA</button>
      <button onclick="location.href='noticeList.do'">공지사항</button>
    </div>

    <c:if test="${loginUser.userAuthority == '2'}">
      <button class="admin-btn" onclick="location.href='badUserList.do'">
        <img src="/resources/img/bell.png" alt="관리자 알림" height="20" />
      </button>
    </c:if>
  </div>

  <!-- 불량 관련 탭 -->
  <div class="tabs" style="margin-top: 30px;">
    <button onclick="location.href='reportedPosts.do'">신고된 게시글</button>
    <button onclick="location.href='reportedComments.do'">신고된 댓글</button>
    <button class="active">불량 이용자 목록</button>
  </div>

  <!-- 테이블 -->
  <table>
    <thead>
      <tr>
        <th>작성자</th>
        <th>등록 사유</th>
        <th>원본 게시글 제목</th>
        <th>등록 날짜</th>
        <th>선택</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="user" items="${badUserList}">
        <tr>
          <td>${user.userName}</td>
          <td>${user.reason}</td>
          <td>${user.originalPostTitle}</td>
          <td>${user.registDate}</td>
          <td><input type="checkbox" name="selectedUsers" value="${user.userId}" /></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 하단 영역 -->
  <div class="bottom-bar">
    <div class="left">등록된 불량 이용자 수: ${fn:length(badUserList)}명</div>
    <div class="right">
      <button class="btn-action">불량 이용자 등록 해제</button>
      <button class="btn-action btn-danger">탈퇴시키기</button>
    </div>
  </div>

  <!-- 페이징 -->
  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <button onclick="location.href='badUserList.do?page=${currentPage - 1}'">&lt;</button>
    </c:if>
    <c:forEach begin="1" end="${totalPages}" var="pageNum">
      <button onclick="location.href='badUserList.do?page=${pageNum}'" class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
      <button onclick="location.href='badUserList.do?page=${currentPage + 1}'">&gt;</button>
    </c:if>
  </div>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>