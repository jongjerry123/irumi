<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link
	href="https://cdn.jsdelivr.net/npm/pretendard@1.3.6/dist/web/static/pretendard.css"
	rel="stylesheet">
<meta charset="UTF-8">
<title>irumi</title>
<style>
body {
	background-color: #000;
	color: white;
	margin: 0;
	padding: 0;
}

.change-pwd-container {
	display: flex;
	justify-content: center;
	align-items: center;
	height: calc(100vh - 80px);
}

.change-pwd-box {
	background-color: #000;
	padding: 40px;
	border-radius: 12px;
	width: 300px;
	text-align: center;
	border: 1px solid #333;
}

.input-group {
	margin-bottom: 10px;
	text-align: left;
}

.change-pwd-box h2 {
	margin-bottom: 5px;
}

.change-pwd-box h5 {
	font-size: 12px;
	margin-bottom: 20px;
	color: red;
}

.change-pwd-box input {
	width: 100%;
	padding: 10px;
	height: 40px;
	border: none;
	border-radius: 6px;
	background-color: #333;
	color: white;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.change-btn {
	background-color: #fff;
	color: black;
	border: none;
	width: 100%;
	padding: 10px;
	height: 40px;
	border-radius: 6px;
	margin-bottom: 10px;
	cursor: pointer;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.defer-btn {
	background-color: #ccc;
	color: black;
	border: none;
	width: 100%;
	padding: 10px;
	height: 40px;
	border-radius: 6px;
	margin-bottom: 20px;
	cursor: pointer;
	box-sizing: border-box;
	font-size: 14px;
	line-height: 20px;
}

.change-btn:disabled, .defer-btn:disabled {
	background-color: #999;
	color: #666;
	cursor: not-allowed;
}

.input-group .error-message, .input-group .success-message {
	margin-top: 4px;
}

.error-message, .success-message {
	font-size: 11px;
	text-align: left;
}

.error-message.error {
	color: #ff5a5a;
}

.success-message.success {
	color: #00ffaa;
}
</style>
</head>
<body>
	<div class="change-pwd-container">
		<div class="change-pwd-box">
			<h2>비밀번호 변경</h2>
			<h5>
				6개월 간 비밀번호가 변경되지 않았습니다. <br>보안을 위하여 비밀번호를 변경해 주시기 바랍니다.
			</h5>
			<form id="changePwdForm">
				<input type="hidden" name="_csrf" value="${_csrf.token}" />

				<div class="input-group">
					<input type="password" name="newPassword" placeholder="새 비밀번호"
						id="newPassword" maxlength="16" required>
					<div class="error-message" id="newPasswordMessage"></div>
				</div>

				<div class="input-group">
					<input type="password" name="confirmPassword" placeholder="비밀번호 확인"
						id="confirmPassword" maxlength="16" required>
					<div class="error-message success-message"
						id="confirmPasswordMessage"></div>
				</div>

				<button type="button" class="change-btn" id="changeBtn" disabled>변경
					완료</button>
				<button type="button" class="defer-btn" id="deferBtn">2개월간
					보지 않기</button>
			</form>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		$(document)
				.ready(
						function() {
							const $newPasswordInput = $('#newPassword');
							const $confirmPasswordInput = $('#confirmPassword');
							const $newPasswordMessage = $('#newPasswordMessage');
							const $confirmPasswordMessage = $('#confirmPasswordMessage');
							const $changeBtn = $('#changeBtn');
							const $deferBtn = $('#deferBtn');
							let isPasswordSameAsCurrent = false;

							// 비밀번호 유효성 검사
							function validatePassword(password) {
								const hasLetter = /[A-Za-z]/.test(password);
								const hasNumber = /\d/.test(password);
								const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/
										.test(password);
								const isValidLength = password.length >= 8;
								if (!password) {
									$newPasswordMessage.text('').removeClass(
											'error');
									return false;
								} else if (hasLetter && hasNumber
										&& hasSpecialChar && isValidLength) {
									return true;
								} else {
									$newPasswordMessage
											.text(
													'8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.')
											.addClass('error');
									return false;
								}
							}

							// 현재 비밀번호와 동일한지 확인
							function checkPasswordSameAsCurrent(password) {
								if (!password || !$newPasswordInput) {
									isPasswordSameAsCurrent = false;
									$newPasswordMessage.text('').removeClass(
											'error');
									validatePasswordMatch();
									return;
								}
								$
										.ajax({
											url : '${pageContext.request.contextPath}/checkPassword.do',
											type : 'POST',
											contentType : 'application/json',
											data : JSON.stringify({
												password : password
											}),
											headers : {
												'X-CSRF-TOKEN' : $(
														'[name=_csrf]').val()
											},
											success : function(response) {
												console
														.log(
																'Check password response:',
																response);
												if (response.success) {
													isPasswordSameAsCurrent = response.isSame;
													if (isPasswordSameAsCurrent) {
														$newPasswordMessage
																.text(
																		response.message)
																.addClass(
																		'error');
													} else if (validatePassword(password)) {
														$newPasswordMessage
																.text('')
																.removeClass(
																		'error');
													} else {
														$newPasswordMessage
																.text(
																		'8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.')
																.addClass(
																		'error');
													}
												} else {
													$newPasswordMessage.text(
															response.message)
															.addClass('error');
													isPasswordSameAsCurrent = false;
												}
												validatePasswordMatch();
											},
											error : function(jqXHR, textStatus,
													errorThrown) {
												console
														.error(
																'Check password error:',
																textStatus,
																errorThrown);
												$newPasswordMessage
														.text(
																'비밀번호 확인 중 오류가 발생했습니다.')
														.addClass('error');
												isPasswordSameAsCurrent = false;
												validatePasswordMatch();
											}
										});
							}

							// 비밀번호 확인 일치 여부
							function validatePasswordMatch() {
								if (!$newPasswordInput
										|| !$confirmPasswordInput)
									return false;
								const newPassword = $newPasswordInput.val()
										.trim();
								const confirmPassword = $confirmPasswordInput
										.val().trim();
								if (!confirmPassword) {
									$confirmPasswordMessage.text('')
											.removeClass('error success');
									return false;
								} else if (newPassword === confirmPassword) {
									if (isPasswordSameAsCurrent) {
										$confirmPasswordMessage.text(
												'새 비밀번호는 현재 비밀번호와 달라야 합니다.')
												.addClass('error').removeClass(
														'success');
										return false;
									}
									$confirmPasswordMessage
											.text('비밀번호가 일치합니다.').removeClass(
													'error')
											.addClass('success');
									return true;
								} else {
									$confirmPasswordMessage.text(
											'비밀번호가 일치하지 않습니다.').removeClass(
											'success').addClass('error');
									return false;
								}
							}

							// 입력값 검증 및 버튼 활성화
							function validateInputs() {
								const newPassword = $newPasswordInput.val()
										.trim();
								const confirmPassword = $confirmPasswordInput
										.val().trim();
								const isValid = validatePassword(newPassword)
										&& validatePasswordMatch()
										&& !isPasswordSameAsCurrent;
								$changeBtn.prop('disabled', !isValid);
							}

							// 입력 이벤트 처리
							$newPasswordInput.on('input', function() {
								const password = $(this).val().trim();
								checkPasswordSameAsCurrent(password);
							});

							$confirmPasswordInput.on('input', function() {
								validatePasswordMatch();
								validateInputs();
							});

							// 변경 완료 버튼 클릭
							$changeBtn
									.on(
											'click',
											function() {
												const newPassword = $newPasswordInput
														.val().trim();
												const userId = '${loginUser.userId}';
												if (!userId) {
													$newPasswordMessage.text(
															'로그인 정보가 없습니다.')
															.addClass('error');
													return;
												}
												$
														.ajax({
															url : '${pageContext.request.contextPath}/updatePassword.do',
															type : 'POST',
															data : {
																userId : userId,
																newPassword : newPassword,
																_csrf : $(
																		'[name=_csrf]')
																		.val()
															},
															success : function(
																	response) {
																console
																		.log(
																				'Update password response:',
																				response);
																if (response.success) {
																	alert(response.message);
																	if (response.isPasswordChanged) {
																		console
																				.log('Password changed, redirecting to logout.do');
																		window.location.href = '${pageContext.request.contextPath}/logout.do';
																	} else {
																		console
																				.log('Redirecting to main.do');
																		window.location.href = '${pageContext.request.contextPath}/main.do';
																	}
																} else {
																	$newPasswordMessage
																			.text(
																					response.message
																							|| '비밀번호 변경 중 오류가 발생했습니다.')
																			.addClass(
																					'error');
																}
															},
															error : function(
																	jqXHR,
																	textStatus,
																	errorThrown) {
																console
																		.error(
																				'Update password error:',
																				textStatus,
																				errorThrown,
																				'Status:',
																				jqXHR.status);
																$newPasswordMessage
																		.text(
																				'비밀번호 변경 중 오류가 발생했습니다: '
																						+ textStatus)
																		.addClass(
																				'error');
																if (jqXHR.status === 403) {
																	alert('보안 토큰이 유효하지 않습니다. 페이지를 새로고침해주세요.');
																} else if (jqXHR.status === 404) {
																	alert('main.do 경로를 찾을 수 없습니다.');
																}
															}
														});
											});

							// 2개월간 보지 않기 버튼 클릭
							$deferBtn
									.on(
											'click',
											function() {
												console
														.log('Defer button clicked');
												const userId = '${loginUser.userId}';
												const csrfToken = $(
														'[name=_csrf]').val();
												console
														.log('userId:', userId,
																'csrfToken:',
																csrfToken);
												if (!userId) {
													$newPasswordMessage.text(
															'로그인 정보가 없습니다.')
															.addClass('error');
													return;
												}
												$
														.ajax({
															url : '${pageContext.request.contextPath}/deferPasswordChange.do',
															type : 'POST',
															data : {
																userId : userId,
																_csrf : csrfToken
															},
															success : function(
																	response) {
																console
																		.log(
																				'Defer password change response:',
																				response);
																if (response.success) {
																	alert('비밀번호 변경이 2개월 연기되었습니다.');
																	window.location.href = '${pageContext.request.contextPath}/main.do';
																} else {
																	$newPasswordMessage
																			.text(
																					response.message
																							|| '연기 처리 중 오류가 발생했습니다.')
																			.addClass(
																					'error');
																}
															},
															error : function(
																	jqXHR,
																	textStatus,
																	errorThrown) {
																console
																		.error(
																				'Defer password change error:',
																				textStatus,
																				errorThrown);
																$newPasswordMessage
																		.text(
																				'연기 처리 중 오류가 발생했습니다.')
																		.addClass(
																				'error');
															}
														});
											});
						});
	</script>
</body>
</html>