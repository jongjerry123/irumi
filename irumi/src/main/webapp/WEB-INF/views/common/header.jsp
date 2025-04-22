<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
header {
	display: flex;
	align-items: center;
	padding: 20px 50px;
	max-width: 1000px;
	margin: 0 auto;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
}

.logo-area {
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 24px;
	font-weight: bold;
}

.triangle-img {
	height: 1.2em;
	vertical-align: middle;
}

.login-actions {
	margin-left: auto;
	display: flex;
	gap: 10px;
}

.login-actions button {
	background-color: transparent;
	color: white;
	border: 1px solid #ccc;
	padding: 6px 12px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.login-actions button:hover {
	background-color: #fff;
	color: #000;
}
</style>

<script type="text/javascript">
function moveToLogin() {
    location.href = 'loginPage.do';
}
</script>

<header>
	<div class="logo-area">
		<svg class="triangle-img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
			<polygon points="12,6 6,18 18,18" fill="white" />
		</svg>
		irumi
	</div>
	<div class="login-actions">
		<button onclick="moveToLogin()">로그인</button>
	</div>
</header>
