<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
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

input[type="text"], input[type="password"], input[type="email"] {
  width: 100%;
  padding: 12px;
  border: 1px solid #444;
  border-radius: 6px;
  background-color: #121212;
  color: white;
  box-sizing: border-box;
}

.btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 6px;
  background-color: #2ccfcf;
  color: black;
  font-weight: bold;
  cursor: pointer;
}

.btn:disabled {
  background-color: black;
  color: white;
  cursor: not-allowed;
}

.inline-group {
  display: flex;
  gap: 10px;
  align-items: center;
}

.inline-group input[type="text"], .inline-group input[type="email"] {
  flex: 1;
}

.verification-group {
  position: relative;
  display: flex;
  align-items: center;
}

#verification-code {
  width: 200px; /* 인증번호 입력 칸 너비 고정 */
  padding-right: 50px; /* 타이머 공간 확보 */
}

#timer {
  display: none; /* 기본적으로 타이머 숨김 */
  position: absolute;
  right: 10px;
  width: 40px; /* 타이머 크기 최적화 */
  line-height: 36px;
  color: #2ccfcf;
  text-align: center;
  font-size: 10px; /* 글자 크기 조정 */
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

    <!-- 아이디 입력 -->
    <div class="input-group">
      <input type="text" id="username" placeholder="아이디 입력" maxlength="12">
    </div>

    <!-- 비밀번호 -->
    <div class="input-group">
      <input type="password" id="password" placeholder="비밀번호" maxlength="16">
      <div id="password-message" class="message error"></div>
    </div>

    <!-- 비밀번호 확인 -->
    <div class="input-group">
      <input type="password" id="confirm-password" placeholder="비밀번호 확인" maxlength="16">
      <div id="confirm-message" class="message error"></div>
    </div>

    <!-- 이메일 -->
    <div class="input-group inline-group">
      <input type="email" id="email" placeholder="이메일 주소" maxlength="30">
      <button id="send-verification" style="width: auto; padding: 10px 14px; background-color: black; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: not-allowed;" disabled>인증전송</button>
    </div>

    <!-- 인증번호 -->
    <div class="input-group verification-group">
      <input type="text" placeholder="인증번호" id="verification-code" disabled>
      <div id="timer">00:00</div>
    </div>

    <button class="btn" id="next-step" disabled>다음 단계로</button>
  </div>

  <script>
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirm-password');
    const passwordMessage = document.getElementById('password-message');
    const confirmMessage = document.getElementById('confirm-message');
    const emailInput = document.getElementById('email');
    const sendVerificationButton = document.getElementById('send-verification');
    const timerDisplay = document.getElementById('timer');
    const verificationCodeInput = document.getElementById('verification-code');
    const nextStepButton = document.getElementById('next-step');

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

    // 이메일 입력 검증 및 인증전송 버튼 스타일 제어
    function validateEmail() {
      const email = emailInput.value.trim();
      if (email) {
        sendVerificationButton.disabled = false;
        sendVerificationButton.style.backgroundColor = 'white';
        sendVerificationButton.style.color = 'black';
        sendVerificationButton.style.cursor = 'pointer';
      } else {
        sendVerificationButton.disabled = true;
        sendVerificationButton.style.backgroundColor = 'black';
        sendVerificationButton.style.color = 'white';
        sendVerificationButton.style.cursor = 'not-allowed';
        sendVerificationButton.textContent = '인증전송';
      }
      validateForm();
    }

    // 필수 입력 검증 (다음 단계 버튼)
    function validateForm() {
      const username = usernameInput.value.trim();
      const passwordValid = validatePassword(passwordInput.value);
      const confirmValid = checkPasswordMatch();
      nextStepButton.disabled = !(username && passwordValid && confirmValid);
    }

    // 인증 전송 버튼 클릭 시 타이머 시작
    let timerInterval = null;
    function startTimer() {
      console.log('Starting timer...');
      if (timerInterval !== null) {
        console.log('Clearing existing timer interval:', timerInterval);
        clearInterval(timerInterval);
      }
      let timeLeft = 120; // 2분
      timerDisplay.style.display = 'block';
      timerDisplay.textContent = formatTime(timeLeft);
      verificationCodeInput.disabled = false;
      sendVerificationButton.textContent = '재발송';
      timerInterval = setInterval(() => {
        console.log('Timer tick:', timeLeft);
        timeLeft--;
        timerDisplay.textContent = formatTime(timeLeft);
        if (timeLeft <= 0) {
          console.log('Timer stopped');
          clearInterval(timerInterval);
          timerInterval = null;
          timerDisplay.textContent = '00:00';
          timerDisplay.style.display = 'none';
          verificationCodeInput.disabled = true;
        }
      }, 1000);
    }

    // 시간 포맷팅 (mm:ss)
    function formatTime(seconds) {
      const minutes = Math.floor(seconds / 60);
      const sec = seconds % 60;
      const paddedMinutes = minutes < 10 ? `0${minutes}` : `${minutes}`;
      const paddedSec = sec < 10 ? `0${sec}` : `${sec}`;
      return `${paddedMinutes}:${paddedSec}`;
    }

    // 이벤트 리스너
    usernameInput.addEventListener('input', () => {
      console.log('Validating username:', usernameInput.value);
      validateForm();
    });

    passwordInput.addEventListener('input', () => {
      console.log('Validating password:', passwordInput.value);
      validatePassword(passwordInput.value);
      validateForm();
    });

    confirmPasswordInput.addEventListener('input', () => {
      console.log('Checking password match:', confirmPasswordInput.value);
      checkPasswordMatch();
      validateForm();
    });

    emailInput.addEventListener('input', () => {
      console.log('Validating email:', emailInput.value);
      validateEmail();
    });

    sendVerificationButton.addEventListener('click', () => {
      console.log('Verification button clicked');
      try {
        startTimer();
      } catch (error) {
        console.error('Error starting timer:', error);
      }
    });
  </script>
</body>
</html>