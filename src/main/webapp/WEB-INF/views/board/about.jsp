<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사이트 소개 - 이루미</title>
  <style>
    body {
      margin: 0;
      background-color: #000;
      color: #fff;
      overflow-x: hidden;
    }

    .about-wrapper {
      max-width: 900px;
      margin: 80px auto;
      padding: 0 20px;
      text-align: center;
    }

    .about-logo-container {
      display: flex;
      justify-content: center;
      margin-bottom: 50px;
    }

    .rotating-logo {
      width: 220px;
      height: 220px;
      animation: spin 20s linear infinite;
      filter: drop-shadow(0 0 10px #BAAC80);
      opacity: 0.92;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    .typewriter {
      width: 100%;
      margin-bottom: 40px;
      font-size: 22px;
      font-weight: bold;
      color: #fff;
      overflow: hidden;
      white-space: nowrap;
      filter: drop-shadow(0 0 10px #BAAC80);
      
    }

    @keyframes typing {
      from { width: 0 }
      to { width: 100% }
    }

    .about-content p {
      font-size: 16px;
      line-height: 1.8;
      color: #ccc;
      margin-bottom: 20px;
      text-align: justify;
      filter: drop-shadow(0 0 10px #BAAC80);
    }

    .gold { color: #BAAC80; font-weight: bold; }
    .blue { color: #43B7B7; font-weight: bold; }
    .purple { color: #A983A3; font-weight: bold; }

    .mystic-glow {
      text-shadow: 0 0 8px rgba(186, 172, 128, 0.5);
    }

    .hidden-note {
      margin-top: 50px;
      font-size: 13px;
      color: #666;
      font-style: italic;
      opacity: 0.6;
      transition: opacity 0.4s ease;
      height: 20px;
    }
  </style>
</head>
<body>
<c:import url="/WEB-INF/views/common/header.jsp" />
<div class="about-wrapper">

  <!-- 로고 -->
  <div class="about-logo-container">
    <img src="/irumi/resources/images/ill2.png" alt="이루미 로고" class="rotating-logo" />
  </div>

  <!-- 타자 애니메이션 -->
  <div class="typewriter">빛은 어둠 속에서 가장 또렷하게 보인다.</div>

  <!-- 설명 -->
  <div class="about-content">
    <p><strong class="mystic-glow">이루미</strong>는 <em>‘꿈을 이루어주는 도우미’</em>라는 의미를 가진 웹 서비스이며, 개발팀 <strong class="mystic-glow">이루미나티</strong>의 철학을 담고 있습니다.</p>
    <p><strong>이루미나티</strong>는 <em>'이루다 + 일루미나티'</em>의 합성어로, 사용자의 진로 여정을 계몽한다는 의미를 담고 있습니다. 즉, 어두운 길 위에서 <strong>빛을 밝혀주는 안내자</strong>가 되는 것이죠.</p>
    <p><span class="gold">대화형 AI 도우미</span>를 통해 성격, 강점, 가치관에 기반한 직무를 추천하고, 해당 직무에 필요한 자격증, 공모전, 시험 일정을 맞춤 제공하며, <span class="blue">나만의 성장 로드맵</span>을 그릴 수 있도록 돕습니다.</p>
    <p>또한, 내가 보유한 스펙과 목표를 <span class="blue">대시보드</span>에 저장하고, <span class="purple">커뮤니티 게시판</span>에서 다른 사용자들과 팁과 후기를 공유하며 함께 성장할 수 있는 공간을 제공합니다.</p>
  </div>

  <!-- 자동 흐르는 메시지 -->
  <div class="hidden-note" id="mysticMessage">※ 모든 시작은 사소한 깨달음에서 비롯됩니다.</div>

</div>

<script>
  const messages = [
    "※ 모든 시작은 사소한 깨달음에서 비롯됩니다.",
    "※ 진로는 선택이 아니라 탐색입니다.",
    "※ 이루미는 빛으로 이끄는 당신만의 나침반입니다.",
    "※ 궁금함은 성장의 첫 걸음입니다."
  ];

  let currentIndex = 0;
  const noteEl = document.getElementById('mysticMessage');

  setInterval(() => {
    currentIndex = (currentIndex + 1) % messages.length;
    noteEl.style.opacity = 0;
    setTimeout(() => {
      noteEl.textContent = messages[currentIndex];
      noteEl.style.opacity = 0.6;
    }, 500);
  }, 5000);
</script>

</body>
</html>