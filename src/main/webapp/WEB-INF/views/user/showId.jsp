<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>irumi</title>
<style>
body {
	background-color: #000;
	color: white;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

.container {
	background-color: #000;
	border-radius: 10px;
	padding: 40px;
	width: 400px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	margin: 150px auto 50px;
	text-align: center;
	border: 1px solid #333;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
}

.result-group {
	margin-bottom: 20px;
}

.result-text {
	font-size: 16px;
	padding: 10px;
	background-color: #121212;
	border: 1px solid #444;
	border-radius: 6px;
	min-height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.btn {
	width: 100%;
	height: 40px;
	padding: 0 12px;
	border: none;
	border-radius: 6px;
	background-color: #fff;
	color: black;
	font-weight: bold;
	cursor: pointer;
	font-size: 14px;
	box-sizing: border-box;
}

.message {
	font-size: 12px;
	margin-top: 5px;
}

.message.success {
	color: #00ffaa;
}

.message.error {
	color: #ff5a5a;
}

@media screen and (max-width: 600px) {
	.container {
		margin-top: 120px;
		width: 90%;
		padding: 20px;
	}
	header {
		padding: 15px 20px;
	}
}

@media screen and (min-width: 1200px) {
	.container {
		margin-top: 180px;
	}
}
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="container">
		<h2>아이디 찾기 결과</h2>
		<div class="result-group">
			<c:choose>
				<c:when test="${not empty userId and userId != ''}">
					<div class="result-text">
						조회된 아이디:
						<c:out value="${userId}" />
					</div>
					<div class="message success">아이디를 성공적으로 조회했습니다.</div>
				</c:when>
				<c:otherwise>
					<div class="result-text">아이디를 찾을 수 없습니다.</div>
					<div class="message error">입력한 이메일로 등록된 아이가 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
		<button type="button" class="btn"
			onclick="location.href='loginPage.do'">로그인 페이지로 이동</button>
	</div>

	<script>
    $(document).ready(function() {
        const $goToLoginButton = $('#go-to-login');

        // 로그인 페이지로 이동
        $goToLoginButton.on('click', function() {
            window.location.href = 'loginPage.do';
        });
    });
    </script>
</body>
</html>