<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사이트 소개 - 이루미</title>
  <style>
    body {
      margin: 0;
      background-color: #111;
      color: #fff;
      font-family: 'Noto Sans KR', sans-serif;
    }

    .about-wrapper {
      max-width: 960px;
      margin: 60px auto;
      padding: 0 16px;
      text-align: center;
    }

    .about-logo-container {
      display: flex;
      justify-content: center;
      margin-bottom: 50px;
    }

    .rotating-logo {
      width: 160px;
      height: 160px;
      animation: spin 10s linear infinite;
      opacity: 0.9;
      filter: drop-shadow(0 0 8px #BAAC80);
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    .about-content h1 {
      font-size: 28px;
      margin-bottom: 30px;
      color: #fff;
    }

    .about-content p {
      font-size: 16px;
      line-height: 1.8;
      color: #ccc;
      margin-bottom: 18px;
    }

    .gold { color: #BAAC80; font-weight: bold; }
    .blue { color: #43B7B7; font-weight: bold; }
    .purple { color: #A983A3; font-weight: bold; }
  </style>
</head>
<body>

  <div class="about-wrapper">

    <!-- ✅ 로고 영역 -->
    <div class="about-logo-container">
      <img src="/irumi/resources/images/eye.png" alt="이루미 로고" class="rotating-logo" />
    </div>

    <!-- ✅ 설명 영역 -->
    <div class="about-content">
      <h1>About irumi</h1>
      <p><strong>이루미</strong>는 <em>‘꿈을 이루어주는 도우미’</em>라는 의미를 가진 웹 서비스이며, 개발팀 <strong>이루미나티</strong>의 철학을 담고 있습니다.</p>
      <p><strong>이루미나티</strong>는 <em>'이루다 + 일루미나티'</em>의 합성어로, 사용자의 진로 여정을 계몽한다는 의미를 담고 있습니다. 즉, 어두운 길 위에서 <strong>빛을 밝혀주는 안내자</strong>가 되는 것이죠.</p>
      <p><span class="gold">대화형 AI 도우미를 통해 성격, 강점, 가치관에 기반한 직무를 추천하고, 해당 직무에 필요한 자격증, 공모전, 시험 일정을 맞춤 제공</span>하며, <span class="blue">나만의 성장 로드맵</span>을 그릴 수 있도록 돕습니다.</p>
      <p>또한, 내가 보유한 <span class="blue">스펙과 목표를 대시보드에 저장</span>하고, <span class="purple">커뮤니티 게시판에서 다른 사용자들과 팁과 후기를 공유하며 함께 성장할 수 있는 공간</span>을 제공합니다.</p>
    </div>

  </div>

  <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>