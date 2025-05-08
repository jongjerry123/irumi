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
	border-left: 3px solid #2ccfcf;
	border-top: 1px solid #2ccfcf;
	border-bottom: 1px solid #2ccfcf;
	border-right: 3px solid #2ccfcf;
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
		<form id="resetPasswordForm" action="updatePassword1.do" method="post">
			<input type="hidden" name="_csrf" value="${_csrf.token}" />
			<input type="hidden" name="userId" value="${param.userId}" />
			<div class="input-group">
				<input type="password" id="newPassword" name="newPassword"
					placeholder="새 비밀번호" maxlength="16">
				<div id="password-message" class="message"></div>
			</div>
			<div class="input-group">
				<input type="password" id="confirmPassword" placeholder="비밀번호 확인"
					maxlength="16">
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
			const userId = $('input[name="userId"]').val();

			let isPasswordValid = false;
			let isPasswordDifferent = false;
			let isConfirmValid = false;

			// 비밀번호 규칙 검증
			function validatePassword(password) {
				const hasLetter = /[A-Za-z]/.test(password);
				const hasNumber = /\d/.test(password);
				const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
				const isValidLength = password.length >= 8;
				if (!password) {
					$passwordMessage.text('').removeClass('error success');
					isPasswordValid = false;
					return false;
				} else if (hasLetter && hasNumber && hasSpecialChar && isValidLength) {
					$passwordMessage.text('유효한 비밀번호입니다.').addClass('success').removeClass('error');
					isPasswordValid = true;
					return true;
				} else {
					$passwordMessage.text('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.')
							.addClass('error').removeClass('success');
					isPasswordValid = false;
					return false;
				}
			}

			// 현재 비밀번호와 동일한지 확인
			function checkPasswordDifferent(password) {
				if (!password) {
					isPasswordDifferent = false;
					validateForm();
					return;
				}
				$.ajax({
					url: 'checkPassword1.do',
					type: 'POST',
					contentType: 'application/json',
					data: JSON.stringify({ password: password, userId: userId, _csrf: $('[name=_csrf]').val() }),
					dataType: 'json',
					success: function(response) {
						console.log('checkPassword response:', response);
						if (response.success && !response.isSame) {
							$passwordMessage.text('유효한 비밀번호입니다.').addClass('success').removeClass('error');
							isPasswordDifferent = true;
						} else {
							$passwordMessage.text(response.message || '새 비밀번호는 현재 비밀번호와 달라야 합니다.')
									.addClass('error').removeClass('success');
							isPasswordDifferent = false;
						}
						validateForm();
					},
					error: function(xhr, status, error) {
						console.error('checkPassword error:', status, error, xhr.responseText);
						$passwordMessage.text('비밀번호 확인 중 오류가 발생했습니다.').addClass('error');
						isPasswordDifferent = false;
						validateForm();
					}
				});
			}

			// 비밀번호 확인 일치 여부 검증
			function checkPasswordMatch() {
				const password = $newPassword.val().trim();
				const confirmPassword = $confirmPassword.val().trim();
				if (!confirmPassword) {
					$confirmMessage.text('').removeClass('error success');
					isConfirmValid = false;
					return false;
				} else if (password === confirmPassword) {
					$confirmMessage.text('비밀번호가 일치합니다.').addClass('success').removeClass('error');
					isConfirmValid = true;
					return true;
				} else {
					$confirmMessage.text('비밀번호가 일치하지 않습니다.').addClass('error').removeClass('success');
					isConfirmValid = false;
					return false;
				}
			}

			// 폼 유효성 검증
			function validateForm() {
				const isFormValid = isPasswordValid && isPasswordDifferent && isConfirmValid;
				console.log('validateForm:', {
					isPasswordValid: isPasswordValid,
					isPasswordDifferent: isPasswordDifferent,
					isConfirmValid: isConfirmValid,
					isFormValid: isFormValid
				});
				$submitBtn.prop('disabled', !isFormValid);
				if (isFormValid) {
					$submitBtn.css({
						'backgroundColor': '#2ccfcf',
						'color': 'black',
						'cursor': 'pointer'
					});
				} else {
					$submitBtn.css({
						'backgroundColor': 'black',
						'color': 'white',
						'cursor': 'not-allowed'
					});
				}
			}

			// 이벤트 리스너
			$newPassword.on('input', function() {
				const password = $newPassword.val().trim();
				isPasswordValid = validatePassword(password);
				if (isPasswordValid) {
					checkPasswordDifferent(password);
				} else {
					isPasswordDifferent = false;
					validateForm();
				}
				checkPasswordMatch();
				validateForm();
			});

			$confirmPassword.on('input', function() {
				checkPasswordMatch();
				validateForm();
			});

			// 폼 제출 시 AJAX 처리
			$('#resetPasswordForm').on('submit', function(e) {
				e.preventDefault();
				if (!isPasswordValid || !isPasswordDifferent || !isConfirmValid) {
					$passwordMessage.text('비밀번호를 올바르게 입력해주세요.').addClass('error').removeClass('success');
					return;
				}

				$.ajax({
					url: 'updatePassword1.do',
					type: 'POST',
					data: $(this).serialize() + '&_csrf=' + encodeURIComponent($('[name=_csrf]').val()),
					dataType: 'json',
					success: function(response) {
						console.log('updatePassword1 response:', response);
						if (response.success) {
							$passwordMessage.text(response.message).addClass('success').removeClass('error');
							if (response.redirectUrl) {
								setTimeout(function() {
									window.location.href = response.redirectUrl;
								}, 1000); // 1초 후 리다이렉션
							} else {
								$passwordMessage.text('리다이렉션 URL이 없습니다.').addClass('error').removeClass('success');
							}
						} else {
							$passwordMessage.text(response.message).addClass('error').removeClass('success');
						}
					},
					error: function(xhr, status, error) {
						console.error('updatePassword1 error:', status, error, xhr.responseText);
						$passwordMessage.text('비밀번호 변경 중 오류가 발생했습니다.').addClass('error').removeClass('success');
					}
				});
			});
		});
	</script>
</body>
</html>