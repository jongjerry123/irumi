<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재설정</title>
    <style>
        body {
            background-color: #121212;
            font-family: Arial, sans-serif;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #1e1e1e;
            border-radius: 10px;
            padding: 40px;
            width: 400px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .input-group {
            margin-bottom: 20px;
        }
        input[type="password"] {
            width: 100%;
            height: 40px;
            padding: 0 12px;
            border: 1px solid #444;
            border-radius: 6px;
            background-color: #121212;
            color: white;
            box-sizing: border-box;
            font-size: 14px;
        }
        .btn {
            width: 100%;
            height: 40px;
            padding: 0 12px;
            border: none;
            border-radius: 6px;
            background-color: #2ccfcf;
            color: black;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
            box-sizing: border-box;
        }
        .btn:disabled {
            background-color: black;
            color: white;
            cursor: not-allowed;
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
    </style>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <div class="container">
        <h2>비밀번호 재설정</h2>
        <form id="resetPasswordForm" action="updatePassword.do" method="post">
            <input type="hidden" name="_csrf" value="${_csrf.token}" />
            <input type="hidden" name="userId" value="${userId}" />
            <div class="input-group">
                <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호" maxlength="16">
                <div id="password-message" class="message"></div>
            </div>
            <div class="input-group">
                <input type="password" id="confirmPassword" placeholder="비밀번호 확인" maxlength="16">
                <div id="confirm-message" class="message"></div>
            </div>
            <button type="submit" class="btn" id="submit-btn" disabled>비밀번호 변경</button>
        </form>
    </div>
    <script>
    $(document).ready(function() {
        const $newPassword = $('#newPassword');
        const $confirmPassword = $('#confirmPassword');
        const $passwordMessage = $('#password-message');
        const $confirmMessage = $('#confirm-message');
        const $submitBtn = $('#submit-btn');

        // 비밀번호 규칙 검증
        function validatePassword(password) {
            const hasLetter = /[A-Za-z]/.test(password);
            const hasNumber = /\d/.test(password);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const isValidLength = password.length >= 8;
            if (!password) {
                $passwordMessage.text('').removeClass('error success');
                return false;
            } else if (hasLetter && hasNumber && hasSpecialChar && isValidLength) {
                $passwordMessage.text('유효한 비밀번호입니다.').addClass('success').removeClass('error');
                return true;
            } else {
                $passwordMessage.text('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.').addClass('error').removeClass('success');
                return false;
            }
        }

        // 비밀번호 확인 일치 여부 검증
        function checkPasswordMatch() {
            const password = $newPassword.val().trim();
            const confirmPassword = $confirmPassword.val().trim();
            if (!confirmPassword) {
                $confirmMessage.text('').removeClass('error success');
                return false;
            } else if (password === confirmPassword) {
                $confirmMessage.text('비밀번호가 일치합니다.').addClass('success').removeClass('error');
                return true;
            } else {
                $confirmMessage.text('비밀번호가 일치하지 않습니다.').addClass('error').removeClass('success');
                return false;
            }
        }

        // 폼 유효성 검증
        function validateForm() {
            const passwordValid = validatePassword($newPassword.val().trim());
            const confirmValid = checkPasswordMatch();
            const isFormValid = passwordValid && confirmValid;
            $submitBtn.prop('disabled', !isFormValid);
            if (isFormValid) {
                $submitBtn.css({ 'backgroundColor': '#2ccfcf', 'color': 'black', 'cursor': 'pointer' });
            } else {
                $submitBtn.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
            }
        }

        // 이벤트 리스너
        $newPassword.on('input', function() {
            validatePassword($newPassword.val().trim());
            checkPasswordMatch();
            validateForm();
        });

        $confirmPassword.on('input', function() {
            checkPasswordMatch();
            validateForm();
        });

        // 폼 제출 시 추가 검증
        $('#resetPasswordForm').on('submit', function(e) {
            const passwordValid = validatePassword($newPassword.val().trim());
            const confirmValid = checkPasswordMatch();
            if (!passwordValid || !confirmValid) {
                e.preventDefault();
                $passwordMessage.text('비밀번호를 올바르게 입력해주세요.').addClass('error').removeClass('success');
            }
        });
    });
    </script>
</body>
</html>