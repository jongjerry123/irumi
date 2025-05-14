<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
body {
	background-color: #000;
	color: white;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.about-wrapper {
      max-width: 900px;
      margin: 80px auto;
      padding: 0 20px;
      text-align: center;
    }

.about-logo-container {
      display: flex;
      justify-content: center;
      margin-bottom: 30px;
    }

    .rotating-logo {
      width: 120px;
      height: 120px;
      animation: spin 20s linear infinite;
      filter: drop-shadow(0 0 10px #BAAC80);
      opacity: 0.92;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

.container {
	background-color: #000;
	border-radius: 10px;
	padding: 40px;
	width: 400px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	border-left: 1px solid #333;
	border-top: 1px solid #333;
	border-bottom: 1px solid #333;
	border-right: 1px solid #333;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
}

.input-group {
	margin-bottom: 20px;
}

input[type="text"], input[type="password"], input[type="email"] {
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

.btn, #send-verification, #check-id, #verify-code {
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

.btn:disabled, #send-verification:disabled, #check-id:disabled,
	#verify-code:disabled {
	background-color: black;
	color: white;
	cursor: not-allowed;
	border-left: 1px solid #333;
	border-top: 1px solid #333;
	border-bottom: 1px solid #333;
	border-right: 1px solid #333;
}

.inline-group {
	display: flex;
	gap: 10px;
	align-items: center;
}

.inline-group input[type="text"], .inline-group input[type="email"] {
	flex: 1;
	height: 40px;
}

.inline-group #send-verification, .inline-group #check-id, .inline-group #verify-code
	{
	width: auto;
	min-width: 100px;
	height: 40px;
}

.verification-group {
	position: relative;
}

#verification-code {
	width: 100%;
	height: 40px;
	padding-right: 60px;
}

#check-id {
	transition: background-color 0.3s ease, color 0.3s ease, cursor 0.3s
		ease;
}

#timer {
	display: none;
	position: absolute;
	right: 10px;
	top: 50%;
	transform: translateY(-50%);
	color: #fff;
	font-size: 12px;
	pointer-events: none;
	z-index: 10;
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
	<c:import url="/WEB-INF/views/common/header.jsp" />
<div class="about-wrapper">
	<!-- 로고 -->
  <div class="about-logo-container">
    <img src="/irumi/resources/images/ill.png" alt="이루미 로고" class="rotating-logo" />
  </div>
	<div class="container">
		<h2>회원가입</h2>
		<form id="register-form">
			<input type="hidden" name="_csrf" value="${_csrf.token}" />
			<!-- 아이디 입력 -->
			<div class="input-group">
				<div class="inline-group">
					<input type="text" id="username" name="username"
						placeholder="아이디 입력(커뮤니티에 사용됩니다.)" maxlength="12">
					<button type="button" id="check-id">중복확인</button>
				</div>
				<div id="id-message" class="message"></div>
			</div>

			<!-- 이름 입력 -->
			<div class="input-group">
				<input type="text" id="userName" name="userName"
					placeholder="닉네임 입력" maxlength="4">
				<div id="name-message" class="message"></div>
			</div>

			<!-- 비밀번호 -->
			<div class="input-group">
				<input type="password" id="password" name="password"
					placeholder="비밀번호" maxlength="16">
				<div id="password-message" class="message error"></div>
			</div>

			<!-- 비밀번호 확인 -->
			<div class="input-group">
				<input type="password" id="confirm-password" placeholder="비밀번호 확인"
					maxlength="16">
				<div id="confirm-message" class="message error"></div>
			</div>

			<!-- 이메일 -->
			<div class="input-group">
				<div class="inline-group">
					<input type="email" id="email" name="userEmail"
						placeholder="이메일 주소" maxlength="30">
					<button type="button" id="send-verification" disabled>인증전송</button>
				</div>
				<div id="email-message" class="message"></div>
			</div>

			<!-- 인증번호 -->
			<div class="input-group verification-group">
				<div class="inline-group">
					<input type="text" id="verification-code" name="verification-code"
						placeholder="인증번호" maxlength="6" disabled>
					<button type="button" id="verify-code" disabled>인증확인</button>
				</div>
				<div id="timer">00:00</div>
				<div id="verification-message" class="message"></div>
			</div>

			<button type="button" class="btn" id="complete-registration" disabled>회원가입
				완료</button>
		</form>
	</div>
</div>
	<script>
	document.addEventListener('DOMContentLoaded', () => {
	    const usernameInput = document.getElementById('username');
	    const checkIdButton = document.getElementById('check-id');
	    const idMessage = document.getElementById('id-message');
	    const userNameInput = document.getElementById('userName');
	    const nameMessage = document.getElementById('name-message');
	    const passwordInput = document.getElementById('password');
	    const confirmPasswordInput = document.getElementById('confirm-password');
	    const passwordMessage = document.getElementById('password-message');
	    const confirmMessage = document.getElementById('confirm-message');
	    const emailInput = document.getElementById('email');
	    const emailMessage = document.getElementById('email-message');
	    const sendVerificationButton = document.getElementById('send-verification');
	    const verifyCodeButton = document.getElementById('verify-code');
	    const timerDisplay = document.getElementById('timer');
	    const verificationCodeInput = document.getElementById('verification-code');
	    const verificationMessage = document.getElementById('verification-message');
	    const completeRegistrationButton = document.getElementById('complete-registration');

	    let isIdAvailable = false;
	    let isEmailValid = false;
	    let isEmailAvailable = false;
	    let isEmailVerified = false;
	    let timerInterval = null;

	    // 아이디 유효성 검사
	    function validateUsernameInput(username) {
	    	const idRegex = /^[a-zA-Z0-9~!@#$%^&*()]+$/;
	        const isValidLength = username.length >= 3;
	        const isValidFormat = idRegex.test(username);

	        if (!username) {
	            idMessage.textContent = '';
	            idMessage.classList.remove('success', 'error');
	            checkIdButton.disabled = true;
	            checkIdButton.style.backgroundColor = 'black';
	            checkIdButton.style.color = 'white';
	            checkIdButton.style.cursor = 'not-allowed';
	            return false;
	        } else if (!isValidLength) {
	            idMessage.textContent = '아이디는 3자 이상이어야 합니다.';
	            idMessage.classList.remove('success');
	            idMessage.classList.add('error');
	            checkIdButton.disabled = true;
	            checkIdButton.style.backgroundColor = 'black';
	            checkIdButton.style.color = 'white';
	            checkIdButton.style.cursor = 'not-allowed';
	            return false;
	        } else if (!isValidFormat) {
	            idMessage.textContent = '아이디는 영어(소문자, 대문자)와 숫자, ~!@#$%^&*()만 사용할 수 있습니다.';
	            idMessage.classList.remove('success');
	            idMessage.classList.add('error');
	            checkIdButton.disabled = true;
	            checkIdButton.style.backgroundColor = 'black';
	            checkIdButton.style.color = 'white';
	            checkIdButton.style.cursor = 'not-allowed';
	            return false;
	        } else {
	            idMessage.textContent = '중복 확인을 진행해주세요.';
	            idMessage.classList.remove('success', 'error');
	            checkIdButton.disabled = false;
	            checkIdButton.style.backgroundColor = '#fff';
	            checkIdButton.style.color = 'black';
	            checkIdButton.style.cursor = 'pointer';
	            return true;
	        }
	    }

	    // 아이디 중복 확인
	    function dupIdCheck() {
	        const username = usernameInput.value.trim();
	        if (!validateUsernameInput(username)) {
	            isIdAvailable = false;
	            validateForm();
	            return;
	        }
	        $.ajax({
	            url: 'idchk.do',
	            type: 'POST',
	            data: { 
	                userId: username,
	                _csrf: $('[name=_csrf]').val()
	            },
	            dataType: 'json',
	            success: function(data) {
	                idMessage.textContent = data.message;
	                idMessage.classList.toggle('success', data.available);
	                idMessage.classList.toggle('error', !data.available);
	                isIdAvailable = data.available;
	                if (data.available) {
	                    userNameInput.focus();
	                } else {
	                    usernameInput.select();
	                }
	                validateForm();
	            },
	            error: function(jqXHR) {
	                let errorMsg = '중복 확인 중 오류가 발생했습니다.';
	                if (jqXHR.status === 403) errorMsg = '권한이 없습니다.';
	                else if (jqXHR.status === 400) errorMsg = '잘못된 요청입니다.';
	                idMessage.textContent = errorMsg;
	                idMessage.classList.remove('success');
	                idMessage.classList.add('error');
	                isIdAvailable = false;
	                validateForm();
	            }
	        });
	    }

	    // 이름 검증
	    function validateUserName(name) {
	        const isValidLength = name.length >= 2;
	        if (!name) {
	            nameMessage.textContent = '';
	            nameMessage.classList.remove('error');
	            return false;
	        } else if (isValidLength) {
	            nameMessage.textContent = '';
	            nameMessage.classList.remove('error');
	            return true;
	        } else {
	            nameMessage.textContent = '이름은 2자 이상이어야 합니다.';
	            nameMessage.classList.add('error');
	            return false;
	        }
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

	    // 이메일 중복 확인
	    function checkEmailAvailability(email) {
	        $.ajax({
	            url: 'checkEmail.do',
	            type: 'POST',
	            data: {
	                email: email,
	                _csrf: $('[name=_csrf]').val()
	            },
	            dataType: 'json',
	            success: function(data) {
	                if (data.available) {
	                    emailMessage.textContent = '사용 가능한 이메일입니다.';
	                    emailMessage.classList.add('success');
	                    emailMessage.classList.remove('error');
	                    isEmailAvailable = true;
	                    sendVerificationButton.disabled = false;
	                    sendVerificationButton.style.backgroundColor = '#fff';
	                    sendVerificationButton.style.color = 'black';
	                    sendVerificationButton.style.cursor = 'pointer';
	                } else {
	                    emailMessage.textContent = '이미 등록된 이메일입니다. 다른 이메일을 입력해주세요.';
	                    emailMessage.classList.add('error');
	                    emailMessage.classList.remove('success');
	                    isEmailAvailable = false;
	                    sendVerificationButton.disabled = true;
	                    sendVerificationButton.style.backgroundColor = 'black';
	                    sendVerificationButton.style.color = 'white';
	                    sendVerificationButton.style.cursor = 'not-allowed';
	                }
	                validateForm();
	            },
	            error: function(jqXHR) {
	                let errorMsg = '이메일 확인 중 오류가 발생했습니다.';
	                if (jqXHR.status === 403) errorMsg = '권한이 없습니다.';
	                else if (jqXHR.status === 400) errorMsg = '잘못된 요청입니다.';
	                emailMessage.textContent = errorMsg;
	                emailMessage.classList.add('error');
	                emailMessage.classList.remove('success');
	                isEmailAvailable = false;
	                sendVerificationButton.disabled = true;
	                sendVerificationButton.style.backgroundColor = 'black';
	                sendVerificationButton.style.color = 'white';
	                sendVerificationButton.style.cursor = 'not-allowed';
	                validateForm();
	            }
	        });
	    }

	    // 인증번호 전송
	    async function sendVerification() {
	        const email = emailInput.value.trim();
	        if (!isEmailValid || !isEmailAvailable) {
	            emailMessage.textContent = '유효한 이메일을 먼저 확인해주세요.';
	            emailMessage.classList.add('error');
	            return;
	        }
	        sendVerificationButton.disabled = true;
	        sendVerificationButton.style.backgroundColor = 'black';
	        sendVerificationButton.style.color = 'white';
	        sendVerificationButton.style.cursor = 'not-allowed';
	        try {
	            const formData = new FormData();
	            formData.append('email', email);
	            formData.append('_csrf', $('[name=_csrf]').val());
	            const response = await fetch('sendVerification.do', {
	                method: 'POST',
	                body: formData
	            });
	            const result = await response.json();
	            if (result.success) {
	                emailMessage.textContent = '인증번호 전송 완료!';
	                emailMessage.classList.remove('error');
	                emailMessage.classList.add('success');
	                verificationMessage.textContent = '인증번호를 입력해주세요.';
	                verificationMessage.classList.remove('error');
	                verificationMessage.classList.add('success');
	                verificationCodeInput.disabled = false;
	                verifyCodeButton.disabled = false;
	                verifyCodeButton.style.backgroundColor = '#fff';
	                verifyCodeButton.style.color = 'black';
	                verifyCodeButton.style.cursor = 'pointer';
	                verificationCodeInput.focus();
	                sendVerificationButton.textContent = '재발송';
	                startTimer();
	            } else {
	                emailMessage.textContent = result.message || '인증번호 전송에 실패했습니다.';
	                emailMessage.classList.remove('success');
	                emailMessage.classList.add('error');
	                verificationMessage.textContent = '';
	                verificationCodeInput.disabled = true;
	                verifyCodeButton.disabled = true;
	                verifyCodeButton.style.backgroundColor = 'black';
	                verifyCodeButton.style.color = 'white';
	                verifyCodeButton.style.cursor = 'not-allowed';
	            }
	            setTimeout(() => {
	                if (isEmailValid && isEmailAvailable) {
	                    sendVerificationButton.disabled = false;
	                    sendVerificationButton.style.backgroundColor = '#fff';
	                    sendVerificationButton.style.color = 'black';
	                    sendVerificationButton.style.cursor = 'pointer';
	                }
	            }, 5000);
	            validateForm();
	        } catch (error) {
	            emailMessage.textContent = '인증번호 전송 중 오류가 발생했습니다.';
	            emailMessage.classList.remove('success');
	            emailMessage.classList.add('error');
	            verificationMessage.textContent = '';
	            verificationCodeInput.disabled = true;
	            verifyCodeButton.disabled = true;
	            verifyCodeButton.style.backgroundColor = 'black';
	            verifyCodeButton.style.color = 'white';
	            verifyCodeButton.style.cursor = 'not-allowed';
	            setTimeout(() => {
	                if (isEmailValid && isEmailAvailable) {
	                    sendVerificationButton.disabled = false;
	                    sendVerificationButton.style.backgroundColor = '#fff';
	                    sendVerificationButton.style.color = 'black';
	                    sendVerificationButton.style.cursor = 'pointer';
	                }
	            }, 5000);
	            validateForm();
	        }
	    }

	    // 인증번호 검증
	    function verifyCode() {
	        const code = verificationCodeInput.value.trim();
	        if (code.length !== 6 || !/^\d+$/.test(code)) {
	            verificationMessage.textContent = '6자리 숫자를 입력해주세요.';
	            verificationMessage.classList.remove('success');
	            verificationMessage.classList.add('error');
	            isEmailVerified = false;
	            validateForm();
	            return;
	        }
	        $.ajax({
	            url: 'verifyCode.do',
	            type: 'POST',
	            data: {
	                code: code,
	                _csrf: $('[name=_csrf]').val()
	            },
	            dataType: 'json',
	            success: function(data) {
	                verificationMessage.textContent = data.message;
	                verificationMessage.classList.toggle('success', data.success);
	                verificationMessage.classList.toggle('error', !data.success);
	                isEmailVerified = data.success;
	                if (data.success) {
	                    verificationCodeInput.disabled = true;
	                    verifyCodeButton.disabled = true;
	                    verifyCodeButton.style.backgroundColor = 'black';
	                    verifyCodeButton.style.color = 'white';
	                    verifyCodeButton.style.cursor = 'not-allowed';
	                    clearInterval(timerInterval);
	                    timerInterval = null;
	                    timerDisplay.style.display = 'none';
	                    passwordInput.focus();
	                } else {
	                    verificationCodeInput.select();
	                }
	                validateForm();
	            },
	            error: function(jqXHR) {
	                let errorMsg = '인증번호 확인 중 오류가 발생했습니다.';
	                if (jqXHR.status === 403) errorMsg = '권한이 없습니다.';
	                else if (jqXHR.status === 400) errorMsg = '잘못된 요청입니다.';
	                verificationMessage.textContent = errorMsg;
	                verificationMessage.classList.remove('success');
	                verificationMessage.classList.add('error');
	                isEmailVerified = false;
	                validateForm();
	            }
	        });
	    }

	    // 타이머 시작
	    function startTimer() {
	        if (timerInterval !== null) {
	            clearInterval(timerInterval);
	            timerInterval = null;
	        }
	        let timeLeft = 300; // 5분
	        try {
	            if (!timerDisplay) {
	                verificationMessage.textContent = '타이머를 표시할 수 없습니다.';
	                verificationMessage.classList.add('error');
	                return;
	            }
	            timerDisplay.style.display = 'block';
	            timerDisplay.textContent = formatTime(timeLeft);
	            timerInterval = setInterval(() => {
	                timeLeft--;
	                timerDisplay.textContent = formatTime(timeLeft);
	                if (timeLeft <= 0) {
	                    clearInterval(timerInterval);
	                    timerInterval = null;
	                    timerDisplay.textContent = '00:00';
	                    timerDisplay.style.display = 'none';
	                    verificationCodeInput.disabled = true;
	                    verifyCodeButton.disabled = true;
	                    verifyCodeButton.style.backgroundColor = 'black';
	                    verifyCodeButton.style.color = 'white';
	                    verifyCodeButton.style.cursor = 'not-allowed';
	                    verificationMessage.textContent = '인증 시간이 만료되었습니다. 재발송해주세요.';
	                    verificationMessage.classList.remove('success');
	                    verificationMessage.classList.add('error');
	                    isEmailVerified = false;
	                    validateForm();
	                }
	            }, 1000);
	        } catch (error) {
	            verificationMessage.textContent = '타이머 시작 중 오류가 발생했습니다.';
	            verificationMessage.classList.add('error');
	        }
	    }

	    // 시간 포맷팅 (mm:ss)
	    function formatTime(seconds) {
	        try {
	            const minutes = Math.floor(seconds / 60);
	            const sec = seconds % 60;
	            return `${minutes.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
	        } catch (error) {
	            return '00:00';
	        }
	    }

	    // 폼 유효성 검증
	    function validateForm() {
	        const username = usernameInput.value.trim();
	        const userNameValid = validateUserName(userNameInput.value.trim());
	        const passwordValid = validatePassword(passwordInput.value);
	        const confirmValid = checkPasswordMatch();
	        const emailValid = isEmailValid && isEmailAvailable;
	        const verificationValid = isEmailVerified;
	        const isFormValid = username && isIdAvailable && userNameValid && passwordValid && confirmValid && emailValid && verificationValid;
	        completeRegistrationButton.disabled = !isFormValid;
	    }

	    // 회원가입 완료 버튼 클릭
	    completeRegistrationButton.addEventListener('click', async () => {
	        try {
	            const formData = {
	                userId: usernameInput.value.trim(),
	                userName: userNameInput.value.trim(),
	                userEmail: emailInput.value.trim(),
	                userPwd: passwordInput.value
	            };
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
	                window.location.href = 'loginPage.do';
	            } else {
	                alert(result.message);
	            }
	        } catch (error) {
	            alert('회원가입 중 오류가 발생했습니다.');
	        }
	    });

	    // 이벤트 리스너
	    checkIdButton.addEventListener('click', dupIdCheck);
	    sendVerificationButton.addEventListener('click', async () => {
	        const email = emailInput.value.trim();
	        if (!isEmailValid || !isEmailAvailable) {
	            emailMessage.textContent = '유효한 이메일을 먼저 확인해주세요.';
	            emailMessage.classList.add('error');
	            return;
	        }
	        await sendVerification();
	    });
	    verifyCodeButton.addEventListener('click', verifyCode);
	    usernameInput.addEventListener('input', () => {
	        isIdAvailable = false;
	        validateUsernameInput(usernameInput.value.trim());
	        validateForm();
	    });
	    userNameInput.addEventListener('input', () => {
	        validateUserName(userNameInput.value);
	        validateForm();
	    });
	    passwordInput.addEventListener('input', () => {
	        validatePassword(passwordInput.value);
	        validateForm();
	    });
	    confirmPasswordInput.addEventListener('input', () => {
	        checkPasswordMatch();
	        validateForm();
	    });
	    emailInput.addEventListener('blur', () => {
	        const email = emailInput.value.trim();
	        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	        isEmailVerified = false;
	        verificationCodeInput.disabled = true;
	        verifyCodeButton.disabled = true;
	        verifyCodeButton.style.backgroundColor = 'black';
	        verifyCodeButton.style.color = 'white';
	        verifyCodeButton.style.cursor = 'not-allowed';
	        verificationCodeInput.value = '';
	        verificationMessage.textContent = '';
	        if (timerInterval) {
	            clearInterval(timerInterval);
	            timerInterval = null;
	            timerDisplay.style.display = 'none';
	        }
	        if (!email || !emailRegex.test(email)) {
	            emailMessage.textContent = '유효한 이메일 주소를 입력해주세요.';
	            emailMessage.classList.add('error');
	            isEmailValid = false;
	            isEmailAvailable = false;
	            sendVerificationButton.disabled = true;
	            sendVerificationButton.style.backgroundColor = 'black';
	            sendVerificationButton.style.color = 'white';
	            sendVerificationButton.style.cursor = 'not-allowed';
	            validateForm();
	            return;
	        }
	        isEmailValid = true;
	        emailMessage.textContent = '';
	        emailMessage.classList.remove('error');
	        checkEmailAvailability(email);
	    });
	});
  </script>
</body>
</html>