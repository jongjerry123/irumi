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
	font-family: 'Noto Sans KR', sans-serif;
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
	margin-bottom: 6px;
}

.card-desc {
	font-size: 14px;
	line-height: 1.4;
}

.irumi-link {
	color: inherit;
	text-decoration: none;
	transition: color 0.3s ease;
}

.irumi-link:hover {
	color: #ff4c4c;
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

// [인트로 클릭 시 전체 콘텐츠 활성화]
window.addEventListener("DOMContentLoaded", function () {
	const main = document.querySelector(".main-container");
	const header = document.querySelector("header");

	<c:choose>
		<c:when test="${empty loginUser}">
			// 비로그인: 클릭 시 보여지도록 설정
			const intro = document.getElementById("introOverlay");
			intro.querySelector("img").addEventListener("click", () => {
				intro.style.opacity = "0";
				setTimeout(() => {
					intro.style.display = "none";
					main.classList.add("active");
					header.classList.add("active");
				}, 500);
			});
		</c:when>
		<c:otherwise>
			// 로그인: 처음부터 바로 보이도록 설정
			main.classList.add("active");
			header.classList.add("active");
		</c:otherwise>
	</c:choose>
});
</script>
</head>
<body>
	<c:if test="${empty loginUser}">
	<!-- ✅ 인트로 오버레이 (비로그인 유저만) -->
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
			원하는 <strong>직무</strong>에 꼭 맞는 <strong>스펙</strong>을 발견하고<br> 나만의
			성장 스토리를 쌓아보세요.
		</h2>

		<div class="card-section">
			<div class="card" onclick="moveToDash()">
				<img src="/irumi/resources/images/dashboard5.png" class="card-image"
					alt="대시보드 이미지" />
				<div class="card-info dashboard">
					<div class="card-title">내 스펙 대시보드</div>
					<div class="card-desc">
						내가 설정한 목표에 따른<br>실행 상황을 살펴볼 수 있습니다.
					</div>
				</div>
			</div>

			<div class="card" onclick="moveToAi()">
				<img src="/irumi/resources/images/ai1.png" class="card-image"
					alt="AI 도우미 이미지" />
				<div class="card-info ai">
					<div class="card-title">대화형 도우미</div>
					<div class="card-desc">
						최신 정보를 AI와의 대화를 통해<br>스펙 대시보드에 저장할 수 있습니다.
					</div>
				</div>
			</div>

			<div class="card" onclick="moveToCommu()">
				<img src="/irumi/resources/images/community3.png" class="card-image"
					alt="유저 커뮤니티 이미지" />
				<div class="card-info community">
					<div class="card-title">유저 커뮤니티</div>
					<div class="card-desc">
						유저들과 취업 팁, 후기를 공유하고<br>스터디 그룹을 구할 수 있습니다.
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>