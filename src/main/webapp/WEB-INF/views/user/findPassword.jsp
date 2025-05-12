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
	font-family: 'Noto Sans KR', sans-serif;
	color: white;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

.container {
	background-color: #1e1e1e;
	border-radius: 10px;
	padding: 40px;
	width: 400px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	margin: 150px auto 50px;
	text-align: center;
	border-left: 3px solid #fff;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	border-right: 3px solid #fff;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
}

.input-group {
	margin-bottom: 20px;
}

input[type="text"], input[type="email"] {
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

.btn, #send-verification, #verify-code {
	width: 100%;
	height: 40px;
	padding: 0 12px;
	border: none;
	border-radius: 6px;
	background-color: #000;
	color: #fff;
	font-weight: bold;
	cursor: pointer;
	font-size: 14px;
	box-sizing: border-box;
}

.btn:disabled, #send-verification:disabled, #verify-code:disabled {
	background-color: black;
	color: white;
	cursor: not-allowed;
	border-left: 1px solid #fff;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	border-right: 1px solid #fff;
}

.inline-group {
	display: flex;
	gap: 10px;
	align-items: center;
}

.inline-group input[type="email"], .inline-group input[type="text"] {
	flex: 1;
	height: 40px;
}

.inline-group #send-verification, .inline-group #verify-code {
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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
</head>
<body>
	<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="container">
		<h2>비밀번호 찾기</h2>
		<form id="findPasswordForm">
			<input type="hidden" name="_csrf" value="${_csrf.token}" />
			<!-- 아이디 입력 -->
			<div class="input-group">
				<input type="text" id="userId" name="userId" placeholder="아이디"
					maxlength="20">
				<div id="userId-message" class="message"></div>
			</div>
			<!-- 이메일 입력 -->
			<div class="input-group">
				<div class="inline-group">
					<input type="email" id="email" name="email" placeholder="이메일 주소"
						maxlength="30">
					<button type="button" id="send-verification" disabled>인증전송</button>
				</div>
				<div id="email-message" class="message"></div>
			</div>
			<!-- 인증번호 -->
			<div class="input-group verification-group" style="display: none;">
				<div class="inline-group">
					<input type="text" id="verification-code" name="verification-code"
						placeholder="인증번호" maxlength="6" disabled>
					<button type="button" id="verify-code" disabled>인증확인</button>
				</div>
				<div id="timer">00:00</div>
				<div id="verification-message" class="message"></div>
			</div>
			<button type="button" class="btn" id="reset-password" disabled>임시
				비밀번호 전송</button>
		</form>
	</div>

	<script>
        (function($) {
            if (typeof $ === 'undefined') {
                console.error('jQuery is not loaded');
                return;
            }

            $(document).ready(function() {
                const $userIdInput = $('#userId');
                const $emailInput = $('#email');
                const $userIdMessage = $('#userId-message');
                const $emailMessage = $('#email-message');
                const $sendVerificationButton = $('#send-verification');
                const $verificationGroup = $('.verification-group');
                const $verificationCode = $('#verification-code');
                const $verifyCodeButton = $('#verify-code');
                const $timerDisplay = $('#timer');
                const $verificationMessage = $('#verification-message');
                const $resetPasswordButton = $('#reset-password');

                let isUserIdValid = false;
                let isEmailValid = false;
                let isUserMatched = false;
                let isEmailVerified = false;
                let timerInterval = null;

                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

                // 아이디 입력 시 유효성 검사
                $userIdInput.on('blur', function() {
                    const userId = $userIdInput.val().trim();
                    if (!userId) {
                        $userIdMessage.text('아이디를 입력해주세요.').addClass('error');
                        isUserIdValid = false;
                    } else {
                        $userIdMessage.text('');
                        isUserIdValid = true;
                    }
                    checkUserMatch();
                });

                // 이메일 입력 시 유효성 검사
                $emailInput.on('blur', function() {
                    const email = $emailInput.val().trim();
                    if (!email || !emailRegex.test(email)) {
                        $emailMessage.text('유효한 이메일 주소를 입력해주세요.').addClass('error');
                        isEmailValid = false;
                    } else {
                        $emailMessage.text('');
                        isEmailValid = true;
                    }
                    checkUserMatch();
                });

                // 아이디와 이메일이 일치하는지 확인
                function checkUserMatch() {
                    if (isUserIdValid && isEmailValid) {
                        const userId = $userIdInput.val().trim();
                        const email = $emailInput.val().trim();
                        $.ajax({
                            url: 'checkUser.do',
                            type: 'POST',
                            data: { userId: userId, email: email, _csrf: $('[name=_csrf]').val() },
                            success: function(response) {
                                if (response.matched) {
                                    $emailMessage.text('아이디와 이메일이 일치합니다.').addClass('success').removeClass('error');
                                    $sendVerificationButton.prop('disabled', false);
                                    $sendVerificationButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                                    isUserMatched = true;
                                } else {
                                    $emailMessage.text('아이디와 이메일이 일치하지 않습니다.').addClass('error').removeClass('success');
                                    $sendVerificationButton.prop('disabled', true);
                                    $sendVerificationButton.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
                                    isUserMatched = false;
                                }
                            },
                            error: function() {
                                $emailMessage.text('사용자 확인 중 오류가 발생했습니다.').addClass('error');
                                $sendVerificationButton.prop('disabled', true);
                                $sendVerificationButton.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
                            }
                        });
                    } else {
                        $sendVerificationButton.prop('disabled', true);
                        $sendVerificationButton.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
                    }
                }

                // 인증번호 전송
                $sendVerificationButton.on('click', async function() {
                    if (!isUserMatched) {
                        $emailMessage.text('아이디와 이메일이 일치하지 않습니다.').addClass('error');
                        return;
                    }
                    const email = $emailInput.val().trim();
                    const userId = $userIdInput.val().trim();
                    $sendVerificationButton.prop('disabled', true);
                    $sendVerificationButton.css({ 'backgroundColor': 'white', 'color': 'black', 'cursor': 'not-allowed' });
                    try {
                        const formData = new FormData();
                        formData.append('email', email);
                        formData.append('userId', userId);
                        formData.append('_csrf', $('[name=_csrf]').val());
                        const response = await fetch('sendVerification.do', {
                            method: 'POST',
                            body: formData
                        });
                        const result = await response.json();
                        if (result.success) {
                            $verificationGroup.show();
                            $verificationMessage.text('인증번호를 입력해주세요.').addClass('success');
                            $verificationCode.prop('disabled', false);
                            $verifyCodeButton.prop('disabled', false);
                            $verifyCodeButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                            $verificationCode.focus();
                            $sendVerificationButton.text('재발송');
                            startTimer();
                        } else {
                            $verificationMessage.text(result.message || '인증번호 전송에 실패했습니다.').addClass('error');
                        }
                        setTimeout(() => {
                            if (isUserMatched) {
                                $sendVerificationButton.prop('disabled', false);
                                $sendVerificationButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                            }
                        }, 5000);
                    } catch (error) {
                        $verificationMessage.text('인증번호 전송 중 오류가 발생했습니다.').addClass('error');
                        setTimeout(() => {
                            if (isUserMatched) {
                                $sendVerificationButton.prop('disabled', false);
                                $sendVerificationButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                            }
                        }, 5000);
                    }
                });

                // 인증번호 검증
                $verifyCodeButton.on('click', function() {
                    const code = $verificationCode.val().trim();
                    const userId = $userIdInput.val().trim();
                    if (code.length !== 6 || !/^\d+$/.test(code)) {
                        $verificationMessage.text('6자리 숫자를 입력해주세요.').addClass('error');
                        return;
                    }
                    $.ajax({
                        url: 'verifyCode.do',
                        type: 'POST',
                        data: { code: code, userId: userId, _csrf: $('[name=_csrf]').val() },
                        success: function(response) {
                            if (response.success) {
                                $verificationMessage.text('인증 성공!').addClass('success');
                                $resetPasswordButton.prop('disabled', false);
                                $resetPasswordButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                                clearInterval(timerInterval);
                                $timerDisplay.hide();
                                isEmailVerified = true;
                            } else {
                                $verificationMessage.text(response.message || '인증 실패').addClass('error');
                            }
                        },
                        error: function() {
                            $verificationMessage.text('인증 중 오류가 발생했습니다.').addClass('error');
                        }
                    });
                });

                // 타이머 시작
                function startTimer() {
                    if (timerInterval !== null) {
                        clearInterval(timerInterval);
                    }
                    let timeLeft = 300; // 5분
                    $timerDisplay.text(formatTime(timeLeft)).show();
                    timerInterval = setInterval(() => {
                        timeLeft--;
                        $timerDisplay.text(formatTime(timeLeft));
                        if (timeLeft <= 0) {
                            clearInterval(timerInterval);
                            $timerDisplay.hide();
                            $verificationCode.prop('disabled', true);
                            $verifyCodeButton.prop('disabled', true);
                            $verifyCodeButton.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
                            $verificationMessage.text('인증 시간이 만료되었습니다. 재발송해주세요.').addClass('error');
                        }
                    }, 1000);
                }

                // 시간 포맷팅 (mm:ss)
                function formatTime(seconds) {
                    const minutes = Math.floor(seconds / 60);
                    const sec = seconds % 60;
                    return `${minutes.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
                }

                // 임시 비밀번호 전송 버튼 클릭
                $resetPasswordButton.on('click', function() {
                    if (!isEmailVerified) {
                        $verificationMessage.text('인증을 완료해주세요.').addClass('error');
                        return;
                    }
                    const userId = $userIdInput.val().trim();
                    const email = $emailInput.val().trim();

                    if (!userId || !email) {
                        $verificationMessage.text('아이디와 이메일을 입력해주세요.').addClass('error');
                        return;
                    }

                    // 버튼 비활성화 및 처리 중 메시지 표시
                    $resetPasswordButton.prop('disabled', true);
                    $resetPasswordButton.css({ 'backgroundColor': 'black', 'color': 'white', 'cursor': 'not-allowed' });
                    $verificationMessage.text('처리 중...').addClass('success').removeClass('error');

                    console.log('Sending reset password request for userId:', userId, 'email:', email);

                    $.ajax({
                        url: 'resetPassword.do',
                        type: 'GET',
                        data: { userId: userId, email: email },
                        success: function(response) {
                            console.log('resetPassword response:', response);
                            if (response.success) {
                                $verificationMessage.text(response.message).addClass('success').removeClass('error');
                                alert('처리 완료');
                                if (response.redirectUrl) {
                                    setTimeout(function() {
                                        window.location.href = response.redirectUrl;
                                    }, 1000);
                                }
                            } else {
                                $verificationMessage.text(response.message || '임시 비밀번호 전송에 실패했습니다.').addClass('error').removeClass('success');
                                if (response.redirectUrl) {
                                    setTimeout(function() {
                                        window.location.href = response.redirectUrl;
                                    }, 1000);
                                }
                            }
                            // 버튼 재활성화
                            $resetPasswordButton.prop('disabled', false);
                            $resetPasswordButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                        },
                        error: function(xhr, status, error) {
                            $verificationMessage.text('임시 비밀번호 전송에 실패했습니다: ' + error).addClass('error').removeClass('success');
                            console.error('AJAX error:', status, error);
                            // 버튼 재활성화
                            $resetPasswordButton.prop('disabled', false);
                            $resetPasswordButton.css({ 'backgroundColor': '#fff', 'color': 'black', 'cursor': 'pointer' });
                        }
                    });
                });
            });
        })(jQuery);
    </script>
</body>
</html>