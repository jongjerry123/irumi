<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

input[type="text"], input[type="password"] {
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

.btn, #check-id {
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

.btn:disabled, #check-id:disabled {
    background-color: black;
    color: white;
    cursor: not-allowed;
}

.inline-group {
    display: flex;
    gap: 10px;
    align-items: center;
}

.inline-group input[type="text"] {
    flex: 1;
    height: 40px;
}

.inline-group #check-id {
    width: auto;
    min-width: 100px;
    height: 40px;
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
</head>
<body>
    <div class="container">
        <h2>회원가입</h2>
        <form id="register-form">
            <!-- CSRF 토큰 -->
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <!-- 아이디 입력 -->
            <div class="input-group">
                <div class="inline-group">
                    <input type="text" id="username" name="username" placeholder="아이디 입력" maxlength="12">
                    <button type="button" id="check-id">중복확인</button>
                </div>
                <div id="id-message" class="message"></div>
            </div>

            <!-- 비밀번호 -->
            <div class="input-group">
                <input type="password" id="password" name="password" placeholder="비밀번호" maxlength="16">
                <div id="password-message" class="message error"></div>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="input-group">
                <input type="password" id="confirm-password" placeholder="비밀번호 확인" maxlength="16">
                <div id="confirm-message" class="message error"></div>
            </div>

            <button type="button" class="btn" id="complete-registration" disabled>회원가입 완료</button>
        </form>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', () => {
        console.log('DOM fully loaded');

        const usernameInput = document.getElementById('username');
        const checkIdButton = document.getElementById('check-id');
        const idMessage = document.getElementById('id-message');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirm-password');
        const passwordMessage = document.getElementById('password-message');
        const confirmMessage = document.getElementById('confirm-message');
        const completeRegistrationButton = document.getElementById('complete-registration');

        let isIdAvailable = false;

        // 아이디 중복 확인
        function dupIdCheck() {
            const username = usernameInput.value.trim();
            console.log('Checking username:', username);
            if (username.length < 3) {
                idMessage.textContent = '아이디는 3자 이상이어야 합니다.';
                idMessage.classList.remove('success');
                idMessage.classList.add('error');
                isIdAvailable = false;
                validateForm();
                return;
            }

            $.ajax({
                url: 'idchk.do',
                type: 'post',
                data: { 
                    userId: username,
                    _csrf: $('[name=_csrf]').val()
                },
                dataType: 'json',
                success: function(data) {
                    console.log('success:', data);
                    idMessage.textContent = data.message;
                    idMessage.classList.toggle('success', data.available);
                    idMessage.classList.toggle('error', !data.available);
                    isIdAvailable = data.available;
                    if (data.available) {
                        passwordInput.focus();
                    } else {
                        usernameInput.select();
                    }
                    validateForm();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error('ID check error:', jqXHR, textStatus, errorThrown);
                    idMessage.textContent = '중복 확인 중 오류가 발생했습니다.';
                    idMessage.classList.remove('success');
                    idMessage.classList.add('error');
                    isIdAvailable = false;
                    validateForm();
                }
            });
        }

        // 비밀번호 규칙 검증
        function validatePassword(password) {
            const hasLetter = /[A-Za-z]/.test(password);
            const hasNumber = /\d/.test(password);
            const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const isValidLength = password.length >= 8;

            if (!password) {
                passwordMessage.textContent = '';
                passwordMessage.classList.remove('error');
                return false;
            } else if (hasLetter && hasNumber && hasSpecialChar && isValidLength) {
                passwordMessage.textContent = '';
                passwordMessage.classList.remove('error');
                return true;
            } else {
                passwordMessage.textContent = '비밀번호는 8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.';
                passwordMessage.classList.add('error');
                return false;
            }
        }

        // 비밀번호 확인 일치 여부 검증
        function checkPasswordMatch() {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (!confirmPassword) {
                confirmMessage.textContent = '';
                confirmMessage.classList.remove('error');
                return false;
            } else if (password !== confirmPassword) {
                confirmMessage.textContent = '비밀번호가 일치하지 않습니다.';
                confirmMessage.classList.add('error');
                return false;
            } else {
                confirmMessage.textContent = '';
                confirmMessage.classList.remove('error');
                return true;
            }
        }

        // 필수 입력 검증 (회원가입 완료 버튼)
        function validateForm() {
            const username = usernameInput.value.trim();
            const passwordValid = validatePassword(passwordInput.value);
            const confirmValid = checkPasswordMatch();
            const isFormValid = username && isIdAvailable && passwordValid && confirmValid;
            completeRegistrationButton.disabled = !isFormValid;
            console.log('Form validation:', { username, isIdAvailable, passwordValid, confirmValid });
        }

        // 회원가입 완료 버튼 클릭 시
        completeRegistrationButton.addEventListener('click', async () => {
            console.log('Complete registration button clicked');
            try {
                const formData = {
                    userId: usernameInput.value.trim(),
                    userPwd: passwordInput.value
                };
                console.log('Form data:', formData);

                const response = await fetch('registerUser.do', {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': $('[name=_csrf]').val()
                    },
                    body: JSON.stringify(formData)
                });

                const result = await response.json();
                if (result.success) {
                    console.log('Registration successful');
                    window.location.href = 'login.do';
                } else {
                    console.error('Registration failed:', result.message);
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error during registration:', error);
                alert('회원가입 중 오류가 발생했습니다.');
            }
        });

        // 이벤트 리스너
        checkIdButton.addEventListener('click', dupIdCheck);
        usernameInput.addEventListener('input', () => {
            console.log('Username input:', usernameInput.value);
            isIdAvailable = false;
            idMessage.textContent = '';
            validateForm();
        });
        passwordInput.addEventListener('input', () => {
            console.log('Password input');
            validatePassword(passwordInput.value);
            validateForm();
        });
        confirmPasswordInput.addEventListener('input', () => {
            console.log('Confirm password input');
            checkPasswordMatch();
            validateForm();
        });
    });
    </script>
</body>
</html>