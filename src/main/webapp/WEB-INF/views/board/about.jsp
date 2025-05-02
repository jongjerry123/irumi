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

    .about-container {
      display: flex;
      max-width: 1200px;
      margin: 60px auto;
      padding: 0 40px;
      align-items: center;
      justify-content: space-between;
      gap: 40px;
    }

    .about-text {
      flex: 1;
      font-size: 16px;
      line-height: 1.8;
      color: #ccc;
    }

    .about-text h2 {
      font-size: 28px;
      margin-bottom: 20px;
      color: #fff;
    }

    .about-text strong {
      color: #A983A3;
      font-weight: bold;
    }

    .about-text em {
      color: #BAAC80;
      font-style: normal;
    }

    .about-image {
      flex-shrink: 0;
    }

    .about-image img {
      width: 360px;
      height: auto;
      border-radius: 12px;
      box-shadow: 0 0 20px rgba(169, 131, 163, 0.3);
    }

    @media (max-width: 900px) {
      .about-container {
        flex-direction: column;
        text-align: center;
      }

      .about-image img {
        width: 80%;
      }
    }
  </style>
</head>
<body>
  <div class="about-container">
    <div class="about-text">
  <h2>이루미 소개</h2>
  <p>
    <strong>이루미</strong>는 <em>‘꿈을 이루어주는 도우미’</em>라는 의미를 가진 웹 서비스이며, 
    개발팀 <strong>이루미나티</strong>의 철학을 담고 있습니다.
  </p>
  <p>
    <strong>이루미나티</strong>는 <em>'이루다 + 일루미나티'</em>의 합성어로, 
    사용자의 진로 여정을 계몽한다는 의미를 담고 있습니다. 
    즉, 어두운 길 위에서 <strong>빛을 밝혀주는 안내자</strong>가 되는 것이죠.
  </p>
  <p>
    <span style="color: #BAAC80;">
      대화형 AI 도우미를 통해 성격, 강점, 가치관에 기반한 직무를 추천하고, 
      해당 직무에 필요한 자격증, 공모전, 시험 일정을 맞춤 제공
    </span>
    하며,
    <span style="color: #43B7B7;">나만의 성장 로드맵</span>을 그릴 수 있도록 돕습니다.
  </p>
  <p>
    또한, 내가 보유한 
    <span style="color: #43B7B7;">스펙과 목표를 대시보드에 저장</span>하고, 
    <span style="color: #A983A3;">
      커뮤니티 게시판에서 다른 사용자들과 팁과 후기를 공유하며 함께 성장할 수 있는 공간
    </span>
    을 제공합니다.
  </p>
</div>

    <div class="about-image">
      <img src="/irumi/resources/images/ai_robed_final.png" alt="이루미 소개 이미지" />
    </div>
  </div>

  <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>