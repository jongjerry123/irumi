<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link href="https://cdn.jsdelivr.net/npm/pretendard@1.3.6/dist/web/static/pretendard.css" rel="stylesheet">
<meta charset="UTF-8">
<title>irumi</title>
<style>
body {
	background-color: #000;
	color: white;
	margin: 0;
	padding: 0;
}

.register-container {
	display: flex;
	justify-content: center;
	align-items: center;
	height: calc(100vh - 80px);
}

.register-box {
	background-color: #1e1e1e;
	padding: 40px;
	border-radius: 12px;
	width: 300px;
	text-align: center;
	border-left: 3px solid #fff;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	border-right: 3px solid #fff;
}

.register-box h2 {
	margin-bottom: 20px;
}

.register-box input {
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

.submit-btn {
	background-color: #fff;
	color: black;
	border: none;
	width: 100%;
	padding: 10px;
	height: 40px;
	border-radius: 6px;
	cursor: pointer;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.submit-btn:disabled {
	background-color: #000;
	color: #fff;
	cursor: not-allowed;
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
	<div class="register-container">
		<div class="register-box">
			<!-- --- 소셜 로그인 통합 추가: 동적 제공자 이름 표시 --- -->
			<h2>${socialProvider}계정 회원가입</h2>
			<form action="registerSocialUser.do" method="post">
				<input type="hidden" name="_csrf" value="${_csrf.token}" /> <input
					type="text" name="userName" placeholder="닉네임 입력" id="userName"
					maxlength="10" pattern=".{1,}" title="닉네임을 입력하세요." required>
				<div class="error-message" id="error-message">
					<c:if test="${not empty message}">${message}</c:if>
				</div>
				<button type="submit" class="submit-btn" id="submitBtn" disabled>등록</button>
			</form>
		</div>
	</div>

	<script>
    const userName = document.getElementById('userName');
    const submitBtn = document.getElementById('submitBtn');
    const errorMessage = document.getElementById('error-message');

    // 초기 에러 메시지 표시
    if (errorMessage.textContent.trim()) {
        errorMessage.style.display = 'block';
    }

    function validateInput() {
        const nameValid = userName.value.trim().length >= 1;
        submitBtn.disabled = !nameValid;
    }

    userName.addEventListener('input', validateInput);
</script>
</body>
</html>