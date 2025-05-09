<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인 - Irumi</title>
<style>
body {
	background-color: #111;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
}

.login-container {
	display: flex;
	justify-content: center;
	align-items: center;
	height: calc(100vh - 80px);
}

.login-box {
	background-color: #1e1e1e;
	padding: 40px;
	border-radius: 12px;
	width: 300px;
	text-align: center;
	border-left: 3px solid #2ccfcf;
	border-top: 1px solid #2ccfcf;
	border-bottom: 1px solid #2ccfcf;
	border-right: 3px solid #2ccfcf;
}

.logo-area {
	display: flex;
	align-items: center;
	gap: 5px;
	font-size: 32px;
	font-weight: bold;
	cursor: pointer;
	justify-content: center;
	margin-bottom: 30px
}

.triangle-img {
	height: 50px;
	width: 50px;
	transition: transform 0.2s ease;
	vertical-align: middle;
}

.logo-area:hover .triangle-img {
	transform: scale(1.3);
}

.login-box input {
	width: 100%;
	padding: 10px;
	height: 40px;
	margin-bottom: 10px;
	border: none;
	border-radius: 6px;
	background-color: #333;
	color: white;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.login-btn {
	background-color: #3ccfcf;
	color: black;
	border: none;
	width: 100%;
	padding: 10px;
	height: 40px;
	border-radius: 6px;
	margin-bottom: 10px;
	cursor: pointer;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.login-btn:disabled {
	background-color: #000;
	color: #fff;
	cursor: not-allowed;
}

.signup-btn {
	background-color: white;
	color: black;
	border: none;
	width: 100%;
	padding: 10px;
	height: 40px;
	border-radius: 6px;
	margin-bottom: 20px;
	cursor: pointer;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.helper-links {
	display: flex;
	justify-content: space-between;
	margin-bottom: 20px;
}

.helper-links a {
	color: #ccc;
	font-size: 0.9em;
	text-decoration: none;
}

.social-login {
	display: flex;
	justify-content: space-around;
	margin-top: 10px;
}

.social-icon {
	width: 35px;
	height: 35px;
	cursor: pointer;
}

.error-message {
	color: #ff5a5a;
	font-size: 0.9em;
	margin-bottom: 10px;
	display: none;
	text-align: left;
}
</style>
</head>
<body>
	<div class="login-container">
		<div class="login-box">
			<div class="logo-area" onclick="moveToMain()">
				<img src="/irumi/resources/images/eye.png" class="triangle-img"
					alt="irumi 로고" /> <span>irumi</span>
			</div>
			<form action="login.do" method="post">
				<input type="hidden" name="_csrf" value="${_csrf.token}" /> <input
					type="text" name="userId" placeholder="아이디 입력" id="userId"
					maxlength="12" pattern=".{3,}" title="아이디를 올바르게 입력하세요." required>
				<input type="password" name="userPwd" placeholder="*********"
					id="userPwd" maxlength="16" pattern=".{8,}"
					title="비밀번호를 올바르게 입력하세요." required>
				<!-- 에러 메시지 비밀번호 입력란 아래로 이동 -->
				<div class="error-message" id="error-message">
					<c:if test="${not empty message}">${message}</c:if>
				</div>
				<button type="submit" class="login-btn" id="loginBtn" disabled>로그인</button>
				<button type="button" class="signup-btn"
					onclick="location.href='resister.do'">회원가입</button>
			</form>
			<div class="helper-links">
				<a href="findPassword.do">비밀번호 찾기</a> <a href="findId.do">아이디 찾기</a>
			</div>
			<div class="social-login">
				<img
					src="${pageContext.request.contextPath}/resources/images/naver.png"
					alt="네이버 로그인" class="social-icon"
					onclick="location.href='naverLogin.do'"> <img
					src="${pageContext.request.contextPath}/resources/images/google.png"
					alt="구글 로그인" class="social-icon"
					onclick="location.href='googleLogin.do'"> <img
					src="${pageContext.request.contextPath}/resources/images/kakao.png"
					alt="카카오 로그인" class="social-icon"
					onclick="location.href='kakaoLogin.do'">
			</div>
		</div>
	</div>

	<script>
    const userId = document.getElementById('userId');
    const userPwd = document.getElementById('userPwd');
    const loginBtn = document.getElementById('loginBtn');
    const errorMessage = document.getElementById('error-message');

    // 초기 에러 메시지 표시
    if (errorMessage.textContent.trim()) {
        errorMessage.style.display = 'block';
    }
 // 삼각형 + irumi 클릭 시 메인페이지 이동
    function moveToMain() {
        location.href = 'main.do';
    }
    function validateInputs() {
        const idValid = userId.value.trim().length >= 3;
        const pwdValid = userPwd.value.trim().length >= 8;

        loginBtn.disabled = !(idValid && pwdValid);
    }

    userId.addEventListener('input', validateInputs);
    userPwd.addEventListener('input', validateInputs);
</script>
</body>
</html>