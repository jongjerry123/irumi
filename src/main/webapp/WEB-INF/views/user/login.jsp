<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        }

        .login-box h2 {
            margin-bottom: 20px;
        }

        .login-box input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: none;
            border-radius: 6px;
            background-color: #333;
            color: white;
        }

        .login-btn {
            background-color: #3ccfcf;
            color: black;
            border: none;
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 10px;
            cursor: pointer;
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
            border-radius: 6px;
            margin-bottom: 20px;
            cursor: pointer;
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
            width: 32px;
            height: 32px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-box">
        <h2>로그인</h2>
        <form action="loginCheck.do" method="post">
            <input type="text" name="userId" placeholder="아이디 입력" id="userId" required>
            <input type="password" name="userPwd" placeholder="*********" id="userPwd" required>
            <button type="submit" class="login-btn" id="loginBtn" disabled>로그인</button>
            <button type="button" class="signup-btn" onclick="location.href='signup.do'">회원가입</button>
        </form>

        <div class="helper-links">
            <a href="findPassword.do">비밀번호 찾기</a>
            <a href="findId.do">아이디 찾기</a>
        </div>

        <div class="social-login">
            <img src="${pageContext.request.contextPath}/resources/images/naver.png" alt="네이버 로그인" class="social-icon">
            <img src="${pageContext.request.contextPath}/resources/images/google.png" alt="구글 로그인" class="social-icon">
            <img src="${pageContext.request.contextPath}/resources/images/kakao.png" alt="카카오 로그인" class="social-icon">
        </div>
    </div>
</div>

<script>
    const userId = document.getElementById('userId');
    const userPwd = document.getElementById('userPwd');
    const loginBtn = document.getElementById('loginBtn');

    function validateInputs() {
        if (userId.value.trim() && userPwd.value.trim()) {
            loginBtn.disabled = false;
        } else {
            loginBtn.disabled = true;
        }
    }

    userId.addEventListener('input', validateInputs);
    userPwd.addEventListener('input', validateInputs);
</script>

</body>
</html>
