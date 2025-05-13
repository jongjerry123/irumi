<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi</title>
<link
	href="https://fonts.googleapis.com/css2?family=Dancing+Script&display=swap"
	rel="stylesheet">
<style>
/* ✅ [인트로 오버레이 영역 추가] */
#introOverlay {
	position: fixed;
	inset: 0;
	background-color: black;
	z-index: 9999;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: opacity 1s ease;
}

#introOverlay img {
	width: 200px;
	height: 200px;
	cursor: pointer;
	transition: transform 0.4s ease, filter 0.4s ease, box-shadow 0.4s ease;
}

#introOverlay img:hover {
	transform: scale(1.2);
	filter: 
		brightness(2.5) /* 이미지 자체 밝기 증가 */
		contrast(110%)  /* 대비 증가 */
		drop-shadow(0 0 20px #fff)
		drop-shadow(0 0 40px #fff)
		drop-shadow(0 0 80px #BAAC80); /* 외곽 빛 퍼짐 효과 */
}

.intro-content {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	gap: 0;
}

.intro-subtitle {
	font-family: 'Dancing Script', cursive;
	font-size: 40px;
	color: #ccc;
	margin-top: 0px;
	margin: 0px;
	line-height: 1;
}

body {
	background-color: #000;
	color: white;
	margin: 0;
	padding: 0;
	transition: background-color 1.5s ease;
}

header {
	opacity: 0;
	transition: opacity 1s ease 0.2s; /* ✅ main-container와 동일하게 */
}

header.active {
	opacity: 1;
}

.main-container {
	max-width: 1100px;
	margin: 80px auto 0;
	padding: 0 16px;
	text-align: center;
	opacity: 0; /* ✅ 처음엔 숨김 */
	transition: opacity 1s ease 0.2s;
}

.main-container.active {
	opacity: 1;
}

.main-container h2 {
	font-size: 1.2rem;
	font-weight: normal;
	line-height: 1.6;
	margin-bottom: 50px;
	margin-left: 100px;
	text-align: left;
	filter: drop-shadow(0 0 10px #BAAC80);
}

.main-container h2 strong {
	font-weight: bold;
}

.card-section {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 40px;
}

.card {
	width: 280px;
	height: 480px;
	background-color: #1e1e1e;
	border-radius: 20px;
	overflow: hidden;
	cursor: pointer;
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	display: flex;
	flex-direction: column;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.2);
}

.card-section:hover .card:not(:hover) {
	filter: brightness(0.6);
	transform: scale(0.98);
	transition: filter 0.3s ease, transform 0.3s ease;
}

.card:hover {
	filter: brightness(1);
	transform: scale(1.05) translateY(-10px);
	z-index: 1;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
}

.card-image {
	width: 100%;
	height: 360px;
	object-fit: cover;
	transition: transform 0.4s ease, filter 0.4s ease;
	filter: grayscale(90%);
}

.card:hover .card-image {
	filter: grayscale(0%) brightness(1.05);
}

.card-info {
	flex-grow: 1;
	padding: 20px 16px;
	text-align: center;
	transition: background-color 0.3s ease;
	color: #fff;
	filter: grayscale(90%);
}

.card:hover .card-info {
	filter: grayscale(0%);
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
	font-size: 20px;
	font-weight: bold;
	margin-top: 20px;
	margin-bottom: 20px;
}

.card-desc { display: none; }

.irumi-link {
	color: inherit;
	text-decoration: none;
	transition: color 0.3s ease;
}

.irumi-link:hover {
	color: #ff4c4c;
}


.detail-section {
  background: #000;
  padding: 0;
  scroll-snap-type: y mandatory;
  scroll-behavior: smooth;
}

.detail-card {
  scroll-snap-align: start;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: row;
  padding: 1px 5vw;
  opacity: 0;
  transform: translateY(0);
  transition: all 0.8s ease;
  cursor: pointer;
}

.detail-card.active {
  opacity: 1;
  transform: translateY(0);
}

.detail-card:nth-child(even) { flex-direction: row-reverse; }

.detail-card img {
  width: 50%;
  height: 80%;
  object-fit: cover;
  border-radius: 20px;
  filter: grayscale(90%);
  transition: filter 0.4s ease;
}

.detail-card:hover img {
  filter: grayscale(0%) brightness(1.05);
}

.detail-content {
  width: 40%;
  padding: 0 40px;
  color: #fff;
}

.detail-content h3 {
  font-size: 32px;
  margin-bottom: 20px;
  filter: drop-shadow(0 0 5px #BAAC80);
}

.detail-content p {
  font-size: 18px;
  line-height: 1.6;
}

.detail-content button {
  margin-top: 24px;
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.detail-content.dashboard button {
  background: #43B7B7;
  color: #fff;
}
.detail-content.ai button {
  background: #BAAC80;
  color: #fff;
}
.detail-content.community button {
  background: #A983A3;
  color: #fff;
}

.detail-content.dashboard button:hover {
  background: #2f9797;
}

.detail-content.ai button:hover {
  background: #9d8f61;
}

.detail-content.community button:hover {
  background: #8c6c8c;
}



</style>

<script>
function moveToLogin() { location.href = 'loginPage.do'; }
function moveToAi() { location.href = 'Ai.do'; }
function moveToDash() { location.href = 'dashboard.do'; }
function moveToCommu() { location.href = 'freeBoard.do'; }

function scrollToDetail(index) {
  const cards = document.querySelectorAll('.detail-card');
  if (cards[index]) {
    cards[index].scrollIntoView({ behavior: 'smooth' });
  }
}

window.addEventListener("DOMContentLoaded", function () {
  const main = document.querySelector(".main-container");
  const header = document.querySelector("header");

  <c:choose>
    <c:when test="${empty loginUser}">
      const intro = document.getElementById("introOverlay");
      intro.querySelector("img").addEventListener("click", () => {
        intro.style.opacity = "0";
        setTimeout(() => {
          intro.style.display = "none";
          main.classList.add("active");
          header.classList.add("active");
          window.scrollTo({ top: 0, behavior: 'auto' });
        }, 500);
      });
    </c:when>
    <c:otherwise>
      main.classList.add("active");
      header.classList.add("active");
    </c:otherwise>
  </c:choose>

  const cards = document.querySelectorAll('.detail-card');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('active');
      } else {
        entry.target.classList.remove('active');
      }
    });
  }, { threshold: 0.6 });

  cards.forEach(card => observer.observe(card));
});
</script>
</head>
<body style="overflow-y: auto; font-family: 'Pretendard', sans-serif;">
  <c:if test="${empty loginUser}">
    <div id="introOverlay">
      <div class="intro-content">
        <img src="/irumi/resources/images/eye.png" alt="irumi 로고 클릭" />
        <p class="intro-subtitle">Project Irumi</p>
      </div>
    </div>
  </c:if>

  <c:import url="/WEB-INF/views/common/header.jsp" />


  <div class="main-container">
    <h2>
      <a href="about.do" class="irumi-link"><strong>이루미</strong></a>와 함께<br>
      원하는 <strong>직무</strong>에 꼭 맞는 <strong>스펙</strong>을 발견하고<br>
      나만의 성장 스토리를 쌓아보세<a href="worldCup.do" style="text-decoration: none; color: inherit;">요</a>.
    </h2>

    <div class="card-section">
      <div class="card" onclick="scrollToDetail(0)">
        <img src="/irumi/resources/images/dashboard5.png" class="card-image" alt="대시보드 이미지" />
        <div class="card-info dashboard">
          <div class="card-title">내 스펙 대시보드</div>
        </div>
      </div>

      <div class="card" onclick="scrollToDetail(1)">
        <img src="/irumi/resources/images/ai9.png" class="card-image" alt="AI 도우미 이미지" />
        <div class="card-info ai">
          <div class="card-title">대화형 도우미</div>
        </div>
      </div>

      <div class="card" onclick="scrollToDetail(2)">
        <img src="/irumi/resources/images/community3.png" class="card-image" alt="유저 커뮤니티 이미지" />
        <div class="card-info community">
          <div class="card-title">유저 커뮤니티</div>
        </div>
      </div>
    </div>
  </div>

  <section class="detail-section">
    <div class="detail-card">
      <img src="/irumi/resources/images/dashboard5.png" alt="대시보드 상세">
      <div class="detail-content dashboard">
        <h3>나의 스펙 대시보드</h3>
        <p>
          나의 스펙 여정을 한 눈에 살펴보고,<br>
          목표 달성을 위한 현재 위치를 가시적으로 파악할 수 있습니다.<br>
          실천 항목들을 설정하고 진행 상황을 추적하며,<br>
          나만의 커리어 트래커를 운영해 보세요.
        </p>
        <button onclick="moveToDash()">바로가기</button>
      </div>
    </div>

    <div class="detail-card">
      <img src="/irumi/resources/images/ai1.png" alt="AI 상세">
      <div class="detail-content ai">
        <h3>대화형 도우미</h3>
        <p>
          AI와 함께 진로를 설계해보세요.<br>
          이루미 도우미는 자격증, 활동, 일정까지 개인화된 정보를 제공하며,<br>
          궁금한 내용을 실시간으로 물어보고 곧바로 기록할 수 있는 강력한 도구입니다.
        </p>
        <button onclick="moveToAi()">바로가기</button>
      </div>
    </div>

    <div class="detail-card">
      <img src="/irumi/resources/images/community3.png" alt="커뮤니티 상세">
      <div class="detail-content community">
        <h3>유저 커뮤니티</h3>
        <p>
          같은 목표를 가진 사람들과 함께하세요.<br>
          취업 팁과 준비 경험을 공유하고,<br>
          실전적인 스터디 그룹이나 활동 정보를 통해 서로를 격려하고 도울 수 있습니다.
        </p>
        <button onclick="moveToCommu()">바로가기</button>
      </div>
    </div>
  </section>
  <c:import url="/WEB-INF/views/common/backToTop.jsp" />
</body>
</html>
