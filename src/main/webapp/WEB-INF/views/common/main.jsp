<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>이루미 메인</title>
<style>
body {
	background-color: #111;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
}

header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 50px;
}


.main-container {
	max-width: 1000px;
	margin: 80px auto 0; /* 중앙 정렬 + 상단 여백 */
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
	background-color: #1e1e1e;
	border-radius: 16px;
	padding: 30px 20px;
	width: 240px;
	cursor: pointer;
	transition: transform 0.2s ease;
}

.card:nth-child(1) .icon-circle {
	background-color: #43B7B7; /* 대시보드: 초록 */
}

.card:nth-child(2) .icon-circle {
	background-color: #BAAC80; /* AI 도우미: 파랑 */
}

.card:nth-child(3) .icon-circle {
	background-color: #92748E; 
}

.card:hover {
	transform: scale(1.05);
}

/* .card:hover .icon-circle {
	background-color: #00c896;
} */



.card:nth-child(1):hover {
	background-color: rgba(67, 183, 183, 0.30); /* 초록빛 */
}

.card:nth-child(2):hover {
	background-color: rgba(186, 172, 128, 0.30); /* 연갈색빛 */
}

.card:nth-child(3):hover {
	background-color: rgba(146, 116, 142, 0.3); /* 핑크빛 */
}

.icon-circle {
	width: 80px;
	height: 80px;
	margin: 0 auto 20px;
	border-radius: 50%;
	background-color: #444;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 32px;
	transition: background-color 0.3s;
}

.card.active .icon-circle {
	background-color: #00c896;
}

.card-title {
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 10px;
}

.card-desc {
	font-size: 14px;
	color: #bbb;
}
.icon-img {
	width: 60px;
	height: 60px;
	object-fit: contain;
	display: block;
	margin: 0 auto;
}
</style>

<script>
    function activateCard(el) {
        document.querySelectorAll('.card').forEach(card => {
            card.classList.remove('active');
        });
        el.classList.add('active');
    }

    function moveToLogin() {
        location.href = 'loginPage.do';
    }

    function moveToAi() {
        location.href = 'Ai.do';
    }
    function moveToDash() {
        location.href = 'viewDash.do';
    }
    function moveToCommu() {
        location.href = 'viewPost.do';
    }
</script>
</head>

<body>
<!-- 	<header>
		<div class="logo-area">
			 <img src="/irumi/resources/images/triangle.png" alt="삼각형" class="triangle-img" />
			<svg class="triangle-img" xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24">
  	<polygon points="12,6 6,18 18,18" fill="white" />
</svg>
			irumi
			<div class="triangle-icon"></div>
			또는 이미지로 삼각형 대체 가능
			<img src="/irumi/resources/images/triangle.png" alt="삼각형" class="triangle-img" />
		</div>
		<div class="login-actions">
			<button onclick="moveToLogin()">로그인</button>
		</div>
	</header> -->
		<c:import url="/WEB-INF/views/common/header.jsp" />

	

	<div class="main-container">
		<h2>
			<strong>이루미</strong>와 함께<br> 희망하는 <strong>직무와 관련된 스펙</strong>을
			찾고<br> 진행 상황을 관리하세요
		</h2>

		<div class="card-section">
			<div class="card" onclick="moveToDash()">
				<div class="icon-circle">
					<img src="/irumi/resources/images/dashboard.png" alt="대시보드"
						class="icon-img" />
				</div>
				<div class="card-title">내 스펙 대시보드</div>
				<div class="card-desc">
					내가 설정한 목표에 따른<br>실행 상황을 살펴볼 수 있습니다.
				</div>
			</div>

			<div class="card" onclick="moveToAi()">
				<div class="icon-circle">
					<img src="/irumi/resources/images/ai.png" alt="ai" class="icon-img" />
				</div>
				<div class="card-title">대화형 도우미</div>
				<div class="card-desc">
					최신 정보를 AI와의 대화를 통해<br>스펙 대시보드에 저장할 수 있습니다.
				</div>
			</div>

			<div class="card" onclick="moveToCommu()">
				<div class="icon-circle">
					<img src="/irumi/resources/images/community.png" alt="커뮤니티"
						class="icon-img" />
				</div>
				<div class="card-title">유저 커뮤니티</div>
				<div class="card-desc">
					유저들과 취업 팁, 후기를 공유하고<br>스터디 그룹을 구할 수 있습니다.
				</div>
			</div>
		</div>
	</div>
<%-- 	<c:import url="/WEB-INF/views/common/footer.jsp" />--%>
</body>
</html>
