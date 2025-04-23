<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>커뮤니티</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #111;
      color: #fff;
    }
    .container {
      display: flex;
    }
    .sidebar {
      width: 220px;
      background-color: #000;
      padding: 30px 20px;
      height: 100vh;
    }
    .sidebar button {
      display: block;
      width: 100%;
      margin-bottom: 20px;
      background: #333;
      color: #fff;
      border: none;
      padding: 12px;
      text-align: left;
      cursor: pointer;
      border-radius: 8px;
    }
    .main-content {
      flex: 1;
      padding: 40px;
    }
    .tabs {
      display: flex;
      gap: 12px;
      margin-bottom: 30px;
    }
    .tabs button {
      background-color: #333;
      color: #fff;
      padding: 10px 24px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
    }
    .tabs .active {
      background-color: #600c7a;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="sidebar">
      <button onclick="moveToDash()">스펙 대시보드</button>
      <button onclick="moveToAi()">대화형 도우미</button>
      <button onclick="moveToCommu()">유저 커뮤니티</button>
    </div>
    <div class="main-content">
      <div class="tabs">
        <button class="active">자유게시판</button>
        <button>Q&A</button>
        <button>공지사항</button>
      </div>
      <!-- 여기서부터 본문 콘텐츠가 들어갑니다 -->
    </div>
  </div>

  <script>
    function moveToLogin() {
      location.href = 'loginPage.do';
    }
    function moveToAi() {
      location.href = 'Ai.do';
    }
    function moveToDash() {
      location.href = 'dashboard.do';
    }
    function moveToCommu() {
      location.href = 'boardPage.do';
    }
  </script>
</body>
</html>