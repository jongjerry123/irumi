<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style>
body {
  background-color: #111;
  color: white;
  font-family: 'Noto Sans KR', sans-serif;
  margin: 0;
  padding: 0;
}

.main-container {
  max-width: 1000px;
  margin: 80px auto 0;
  text-align: center;
}

.main-container h2 {
  font-weight: normal;
  line-height: 1.8;
  margin-bottom: 50px;
}

.main-container h2 strong {
  font-weight: bold;
}

.card-section {
  display: flex;
  justify-content: center;
  gap: 40px;
}

.card {
  width: 240px;
  height: 480px;
  background-color: #1e1e1e;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.3s ease;
  display: flex;
  flex-direction: column;
}

.card:hover {
  transform: scale(1.05);
}

.card-image {
  width: 100%;
  height: 240px;
  object-fit: cover;
}

.card-info {
  flex-grow: 1;
  padding: 20px 12px;
  text-align: center;
  transition: background-color 0.3s ease;
}

.card-info.dashboard {
  background-color: #43B7B7;
}

.card:hover .card-info.dashboard {
  background-color: #2f9797;
}

.card-info.ai {
  background-color: #BAAC80;
}

.card:hover .card-info.ai {
  background-color: #9d8f61;
}

.card-info.community {
  background-color: #A983A3;
}

.card:hover .card-info.community {
  background-color: #8c6c8c;
}

.card-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #fff;
}

.card-desc {
  font-size: 14px;
  color: #fff;
}
</style>
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
    location.href = 'freeBoard.do';
  }
</script>
</head>
<body>
  <c:import url="/WEB-INF/views/common/header.jsp" />
  <div class="main-container">
    <h2>
      <strong>이루미</strong>와 함께<br>
      희망하는 <strong>직무와 관련된 스펙</strong>을 찾고<br>
      진행 상황을 관리하세요
    </h2>
    <div class="card-section">
      <div class="card" onclick="moveToDash()">
        <img src="/irumi/resources/images/dashboard2.png" class="card-image" alt="대시보드 이미지" />
        <div class="card-info dashboard">
          <div class="card-title">내 스펙 대시보드</div>
          <div class="card-desc">내가 설정한 목표에 따른<br>실행 상황을 살펴볼 수 있습니다.</div>
        </div>
      </div>

      <div class="card" onclick="moveToAi()">
        <img src="/irumi/resources/images/ai2.png" class="card-image" alt="AI 도우미 이미지" />
        <div class="card-info ai">
          <div class="card-title">대화형 도우미</div>
          <div class="card-desc">최신 정보를 AI와의 대화를 통해<br>스펙 대시보드에 저장할 수 있습니다.</div>
        </div>
      </div>

      <div class="card" onclick="moveToCommu()">
        <img src="/irumi/resources/images/community2.png" class="card-image" alt="유저 커뮤니티 이미지" />
        <div class="card-info community">
          <div class="card-title">유저 커뮤니티</div>
          <div class="card-desc">유저들과 취업 팁, 후기를 공유하고<br>스터디 그룹을 구할 수 있습니다.</div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>