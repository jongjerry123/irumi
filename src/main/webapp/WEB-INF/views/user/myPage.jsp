<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>마이페이지</title>
    <style>
        body {
            background-color: #111;
            font-family: 'Noto Sans KR', sans-serif;
            color: white;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 50px;
            max-width: 1200px;
            margin: 0 auto;
            background-color: #111;
            position: fixed;
            width: 100%;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            box-sizing: border-box;
        }

        .container {
            background-color: #1e1e1e;
            border-radius: 10px;
            padding: 40px;
            width: 400px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            margin: 150px auto 50px;
            text-align: center;
        }

        h2 {
            text-align: center;
            margin-bottom: 10px;
        }

        .user-info {
            font-size: 14px;
            color: #ccc;
            margin-bottom: 30px;
        }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }

        input[type="password"], input[type="email"], input[type="text"], select {
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

        .inline-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .inline-group input[type="email"] {
            flex: 1;
        }

        .inline-group .btn {
            width: auto;
            min-width: 100px;
            height: 40px;
        }

        .verification-group {
            position: relative;
        }

        .verification-group input[type="text"] {
            width: 100%;
            height: 40px;
            padding-right: 60px;
        }

        .timer {
            display: none;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #2ccfcf;
            font-size: 12px;
            pointer-events: none;
            z-index: 10;
        }

        .btn {
            height: 40px;
            padding: 0 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
            box-sizing: border-box;
            background-color: #2ccfcf;
            color: black;
            position: relative;
            z-index: 10;
        }

        .btn:disabled {
            background-color: black;
            color: white;
            cursor: not-allowed;
        }

        .btn-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn.cancel {
            width: 120px;
            background-color: #444;
            color: white;
        }

        .btn.submit {
            width: 120px;
            background-color: #2ccfcf;
            color: black;
        }

        .message {
            font-size: 12px;
            margin-top: 5px;
            text-align: left;
        }

        .message.error {
            color: #ff5a5a;
        }

        .message.success {
            color: #00ffaa;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function() {
            try {
                // DOM 요소 캐싱
                const $newPasswordInput = $('#new-password');
                const $confirmPasswordInput = $('#confirm-password');
                const $emailInput = $('#email');
                const $changeEmailButton = $('#change-email');
                const $verificationCodeInput = $('#verification-code');
                const $verifyCodeButton = $('#verify-code');
                const $timerDisplay = $('#timer');
                const $universityInput = $('#university');
                const $degreeInput = $('#degree');
                const $graduatedInput = $('#graduated');
                const $pointInput = $('#point');
                const $newPasswordMessage = $('#new-password-message');
                const $confirmPasswordMessage = $('#confirm-password-message');
                const $emailMessage = $('#email-message');
                const $verificationMessage = $('#verification-message');
                const $universityMessage = $('#university-message');
                const $degreeMessage = $('#degree-message');
                const $graduatedMessage = $('#graduated-message');
                const $pointMessage = $('#point-message');
                const $verificationGroup = $('.verification-group');
                const $cancelButton = $('#cancel');
                const $submitButton = $('#submit');

                // 상태 변수
                let isPasswordValid = false;
                let isPasswordMatch = false;
                let isEmailValid = false;
                let isEmailAvailable = false;
                let isEmailVerified = false;
                let isEmailChanged = false;
                let timerInterval = null;

                // 비밀번호 유효성 검사
                function validatePassword(password) {
                    const hasLetter = /[A-Za-z]/.test(password);
                    const hasNumber = /\d/.test(password);
                    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
                    const isValidLength = password.length >= 8;
                    if (!password) {
                        $newPasswordMessage.text('').removeClass('error');
                        return false;
                    } else if (hasLetter && hasNumber && hasSpecialChar && isValidLength) {
                        $newPasswordMessage.text('').removeClass('error');
                        return true;
                    } else {
                        $newPasswordMessage.text('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.').addClass('error');
                        return false;
                    }
                }

                // 비밀번호 확인 일치 여부
                function validatePasswordMatch() {
                    const newPassword = $newPasswordInput.val().trim();
                    const confirmPassword = $confirmPasswordInput.val().trim();
                    if (!confirmPassword) {
                        $confirmPasswordMessage.text('').removeClass('error success');
                        return false;
                    } else if (newPassword === confirmPassword) {
                        $confirmPasswordMessage.text('비밀번호가 일치합니다.').removeClass('error').addClass('success');
                        return true;
                    } else {
                        $confirmPasswordMessage.text('비밀번호가 일치하지 않습니다.').removeClass('success').addClass('error');
                        return false;
                    }
                }

                // 이메일 유효성 검사
                function validateEmail(email) {
                    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                    if (!email) {
                        $emailMessage.text('').removeClass('error');
                        return false;
                    } else if (emailPattern.test(email)) {
                        $emailMessage.text('').removeClass('error');
                        return true;
                    } else {
                        $emailMessage.text('유효한 이메일 형식이 아닙니다.').addClass('error');
                        return false;
                    }
                }

                // 학점 유효성 검사
                function validatePoint(point) {
                    if (!point) return true;
                    const pointPattern = /^\d(\.\d)?$/;
                    if (!pointPattern.test(point)) {
                        $pointMessage.text('학점은 0.0~4.5 형식으로 입력해주세요.').addClass('error');
                        return false;
                    }
                    const pointValue = parseFloat(point);
                    if (pointValue < 0 || pointValue > 4.5) {
                        $pointMessage.text('학점은 0.0~4.5 사이여야 합니다.').addClass('error');
                        return false;
                    }
                    $pointMessage.text('').removeClass('error');
                    return true;
                }

                // 이메일 중복 확인
                function checkEmailAvailability(email) {
                    console.log('Checking email availability:', email);
                    $.ajax({
                        url: 'checkEmail.do',
                        type: 'POST',
                        data: {
                            email: email,
                            _csrf: $('[name=_csrf]').val()
                        },
                        dataType: 'json',
                        success: function(data) {
                            console.log('Email check response:', data);
                            if (data.available || email === '${sessionScope.loginUser.userEmail}') {
                                $emailMessage.text('사용 가능한 이메일입니다.').addClass('success').removeClass('error');
                                isEmailAvailable = true;
                                $changeEmailButton.prop('disabled', false).css({
                                    'background-color': '#2ccfcf',
                                    'color': 'black',
                                    'cursor': 'pointer'
                                });
                            } else {
                                $emailMessage.text('이미 등록된 이메일입니다. 다른 이메일을 입력해주세요.').addClass('error').removeClass('success');
                                isEmailAvailable = false;
                                $changeEmailButton.prop('disabled', true).css({
                                    'background-color': 'black',
                                    'color': 'white',
                                    'cursor': 'not-allowed'
                                });
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error('Email check error:', textStatus, errorThrown);
                            $emailMessage.text('이메일 확인 중 오류가 발생했습니다.').addClass('error').removeClass('success');
                            isEmailAvailable = false;
                            $changeEmailButton.prop('disabled', true).css({
                                'background-color': 'black',
                                'color': 'white',
                                'cursor': 'not-allowed'
                            });
                        }
                    });
                }

                // 인증번호 전송
                async function sendVerification() {
                    const email = $emailInput.val().trim();
                    console.log('Sending verification to:', email);
                    if (!isEmailValid || !isEmailAvailable) {
                        $emailMessage.text('유효한 이메일을 먼저 확인해주세요.').addClass('error').removeClass('success');
                        return;
                    }
                    $changeEmailButton.prop('disabled', true).css({
                        'background-color': 'black',
                        'color': 'white',
                        'cursor': 'not-allowed'
                    });
                    try {
                        const formData = new FormData();
                        formData.append('email', email);
                        formData.append('_csrf', $('[name=_csrf]').val());
                        const response = await fetch('sendVerification.do', {
                            method: 'POST',
                            body: formData
                        });
                        const result = await response.json();
                        console.log('Verification response:', result);
                        if (result.success) {
                            $emailMessage.text('인증번호 전송 완료!').addClass('success').removeClass('error');
                            $verificationMessage.text('인증번호를 입력해주세요.').addClass('success').removeClass('error');
                            $verificationGroup.show();
                            $verificationCodeInput.prop('disabled', false).val('');
                            $verifyCodeButton.prop('disabled', false).css({
                                'background-color': '#2ccfcf',
                                'color': 'black',
                                'cursor': 'pointer'
                            });
                            $changeEmailButton.text('재발송');
                            startTimer();
                        } else {
                            $emailMessage.text(result.message || '인증번호 전송에 실패했습니다.').addClass('error').removeClass('success');
                            $verificationGroup.hide();
                            $verificationCodeInput.prop('disabled', true);
                            $verifyCodeButton.prop('disabled', true).css({
                                'background-color': 'black',
                                'color': 'white',
                                'cursor': 'not-allowed'
                            });
                        }
                        setTimeout(() => {
                            if (isEmailValid && isEmailAvailable) {
                                $changeEmailButton.prop('disabled', false).css({
                                    'background-color': '#2ccfcf',
                                    'color': 'black',
                                    'cursor': 'pointer'
                                });
                            }
                        }, 5000);
                    } catch (error) {
                        console.error('Verification error:', error);
                        $emailMessage.text('인증번호 전송 중 오류가 발생했습니다.').addClass('error').removeClass('success');
                        $verificationGroup.hide();
                        $verificationCodeInput.prop('disabled', true);
                        $verifyCodeButton.prop('disabled', true).css({
                            'background-color': 'black',
                            'color': 'white',
                            'cursor': 'not-allowed'
                        });
                        setTimeout(() => {
                            if (isEmailValid && isEmailAvailable) {
                                $changeEmailButton.prop('disabled', false).css({
                                    'background-color': '#2ccfcf',
                                    'color': 'black',
                                    'cursor': 'pointer'
                                });
                            }
                        }, 5000);
                    }
                }

                // 인증번호 검증
                function verifyCode() {
                    console.log('Verifying code');
                    const code = $verificationCodeInput.val().trim();
                    if (code.length !== 6 || !/^\d+$/.test(code)) {
                        $verificationMessage.text('6자리 숫자를 입력해주세요.').addClass('error').removeClass('success');
                        isEmailVerified = false;
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
                            console.log('Verify code response:', data);
                            $verificationMessage.text(data.message).toggleClass('success', data.success).toggleClass('error', !data.success);
                            isEmailVerified = data.success;
                            if (data.success) {
                                $verificationCodeInput.prop('disabled', true);
                                $verifyCodeButton.prop('disabled', true).css({
                                    'background-color': 'black',
                                    'color': 'white',
                                    'cursor': 'not-allowed'
                                });
                                clearInterval(timerInterval);
                                timerInterval = null;
                                $timerDisplay.hide();
                            } else {
                                $verificationCodeInput.select();
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error('Verify code error:', textStatus, errorThrown);
                            $verificationMessage.text('인증번호 확인 중 오류가 발생했습니다.').addClass('error').removeClass('success');
                            isEmailVerified = false;
                        }
                    });
                }

                // 타이머 시작
                function startTimer() {
                    console.log('Starting timer');
                    if (timerInterval !== null) {
                        clearInterval(timerInterval);
                        timerInterval = null;
                    }
                    let timeLeft = 300; // 5분
                    $timerDisplay.show().text(formatTime(timeLeft));
                    timerInterval = setInterval(() => {
                        timeLeft--;
                        $timerDisplay.text(formatTime(timeLeft));
                        if (timeLeft <= 0) {
                            clearInterval(timerInterval);
                            timerInterval = null;
                            $timerDisplay.hide().text('00:00');
                            $verificationCodeInput.prop('disabled', true);
                            $verifyCodeButton.prop('disabled', true).css({
                                'background-color': 'black',
                                'color': 'white',
                                'cursor': 'not-allowed'
                            });
                            $verificationMessage.text('인증 시간이 만료되었습니다. 재발송해주세요.').addClass('error').removeClass('success');
                            isEmailVerified = false;
                        }
                    }, 1000);
                }

                // 시간 포맷팅 (mm:ss)
                function formatTime(seconds) {
                    const minutes = Math.floor(seconds / 60);
                    const sec = seconds % 60;
                    return `${minutes.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
                }

                // 비밀번호 입력 실시간 검사
                $newPasswordInput.on('input', function() {
                    isPasswordValid = validatePassword($newPasswordInput.val().trim());
                    validatePasswordMatch();
                });

                // 비밀번호 확인 입력 실시간 검사
                $confirmPasswordInput.on('input', function() {
                    isPasswordMatch = validatePasswordMatch();
                });

                // 이메일 입력 실시간 검사
                $emailInput.on('blur', function() {
                    console.log('Email blur:', $emailInput.val());
                    const email = $emailInput.val().trim();
                    isEmailValid = validateEmail(email);
                    isEmailVerified = false;
                    $verificationCodeInput.prop('disabled', true).val('');
                    $verifyCodeButton.prop('disabled', true).css({
                        'background-color': 'black',
                        'color': 'white',
                        'cursor': 'not-allowed'
                    });
                    $verificationMessage.text('');
                    $verificationGroup.hide();
                    if (timerInterval) {
                        clearInterval(timerInterval);
                        timerInterval = null;
                        $timerDisplay.hide();
                    }
                    if (!isEmailValid) {
                        isEmailAvailable = false;
                        $changeEmailButton.text('인증전송').prop('disabled', true).css({
                            'background-color': 'black',
                            'color': 'white',
                            'cursor': 'not-allowed'
                        });
                        return;
                    }
                    if (email !== '${sessionScope.loginUser.userEmail}') {
                        isEmailChanged = true;
                        checkEmailAvailability(email);
                    } else {
                        isEmailChanged = false;
                        isEmailAvailable = true;
                        isEmailVerified = true;
                        $emailMessage.text('').removeClass('error success');
                        $changeEmailButton.text('변경하기').prop('disabled', false).css({
                            'background-color': '#2ccfcf',
                            'color': 'black',
                            'cursor': 'pointer'
                        });
                    }
                });

                // 학점 입력 실시간 검사
                $pointInput.on('input', function() {
                    validatePoint($pointInput.val().trim());
                });

                // 이메일 변경 버튼 클릭
                $changeEmailButton.on('click', function(event) {
                    event.preventDefault();
                    console.log('Change email button clicked, disabled:', $(this).prop('disabled'));
                    if ($(this).prop('disabled')) return;
                    if ($(this).text() === '변경하기') {
                        $emailInput.prop('readonly', false).focus();
                        $(this).text('인증전송');
                    } else {
                        sendVerification();
                    }
                });

                // 인증 코드 확인
                $verifyCodeButton.on('click', function(event) {
                    event.preventDefault();
                    console.log('Verify code button clicked, disabled:', $(this).prop('disabled'));
                    if ($(this).prop('disabled')) return;
                    verifyCode();
                });

                // 취소 버튼 클릭
                $cancelButton.on('click', function(event) {
                    event.preventDefault();
                    console.log('Cancel button clicked');
                    location.href = 'main.do';
                });

                // 변경하기 버튼 클릭
                $submitButton.on('click', function(event) {
                    event.preventDefault();
                    console.log('Submit button clicked');
                    // 비밀번호 유효성 체크
                    const newPassword = $newPasswordInput.val().trim();
                    if (newPassword && (!isPasswordValid || !isPasswordMatch)) {
                        $newPasswordMessage.text('유효한 비밀번호를 입력해주세요.').addClass('error');
                        $confirmPasswordMessage.text('비밀번호가 일치하지 않습니다.').addClass('error');
                        return;
                    }
                    // 이메일 유효성 체크
                    const email = $emailInput.val().trim();
                    if (email && !isEmailValid) {
                        $emailMessage.text('유효한 이메일을 입력해주세요.').addClass('error').removeClass('success');
                        return;
                    }
                    if (isEmailChanged && !isEmailVerified) {
                        $emailMessage.text('이메일 인증을 완료해주세요.').addClass('error').removeClass('success');
                        return;
                    }
                    // 학점 유효성 체크
                    const point = $pointInput.val().trim();
                    if (!validatePoint(point)) return;

                    // 데이터 준비
                    const userData = {
                        password: newPassword || undefined,
                        email: isEmailChanged && isEmailVerified ? email : undefined,
                        university: $universityInput.val().trim() || undefined,
                        degree: $degreeInput.val() || undefined,
                        graduated: $graduatedInput.val() || undefined,
                        point: point ? parseFloat(point) : undefined
                    };

                    // AJAX 요청
                    $.ajax({
                        url: 'updateUserProfile.do',
                        type: 'POST',
                        data: JSON.stringify(userData),
                        contentType: 'application/json',
                        headers: {
                            'X-CSRF-TOKEN': $('[name=_csrf]').val()
                        },
                        success: function(response) {
                            console.log('Update response:', response);
                            if (response.success) {
                                alert('변경이 완료되었습니다.');
                                location.reload();
                            } else {
                                alert(response.message || '정보 업데이트 실패');
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error('Update error:', textStatus, errorThrown);
                            if (jqXHR.status === 403) {
                                alert('보안 토큰이 유효하지 않습니다. 페이지를 새로고침해주세요.');
                            } else {
                                alert('변경 중 오류가 발생했습니다: ' + textStatus);
                            }
                        }
                    });
                });
            } catch (error) {
                console.error('Initialization error:', error);
                alert('페이지 로드 중 오류가 발생했습니다.');
            }
        });
    </script>
</head>
<body>
    <c:import url="/WEB-INF/views/common/header.jsp" />
    <div class="container">
        <h2>마이페이지</h2>
        <c:if test="${not empty sessionScope.loginUser}">
            <div class="user-info">${sessionScope.loginUser.userName}님의 마이페이지</div>
        </c:if>
        <c:if test="${empty sessionScope.loginUser}">
            <div class="message error">로그인이 필요합니다.</div>
            <script>
                setTimeout(() => location.href = 'loginPage.do', 1000);
            </script>
        </c:if>
        <form id="myPageForm">
            <input type="hidden" name="_csrf" value="${_csrf.token}" />
            <!-- 비밀번호 변경 -->
            <c:if test="${sessionScope.loginUser.userLoginType != 3 && sessionScope.loginUser.userLoginType != 4 && sessionScope.loginUser.userLoginType != 5}">
                <div class="input-group">
                    <label for="new-password">새 비밀번호</label>
                    <input type="password" id="new-password" name="newPassword" placeholder="새 비밀번호 입력" maxlength="16">
                    <div id="new-password-message" class="message"></div>
                </div>
                <div class="input-group">
                    <label for="confirm-password">새 비밀번호 확인</label>
                    <input type="password" id="confirm-password" name="confirmPassword" placeholder="비밀번호 재입력" maxlength="16">
                    <div id="confirm-password-message" class="message"></div>
                </div>
            </c:if>
            <!-- 이메일 변경 -->
            <div class="input-group">
                <div class="inline-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" value="${sessionScope.loginUser.userEmail}" readonly>
                    <button type="button" class="btn" id="change-email">변경하기</button>
                </div>
                <div id="email-message" class="message"></div>
            </div>
            <!-- 인증번호 -->
            <div class="input-group verification-group" style="display: none;">
                <div class="inline-group">
                    <input type="text" id="verification-code" name="verification-code" placeholder="인증번호" maxlength="6" disabled>
                    <button type="button" class="btn" id="verify-code" disabled>인증확인</button>
                </div>
                <div id="timer" class="timer">00:00</div>
                <div id="verification-message" class="message"></div>
            </div>
            <!-- 대학교 -->
            <div class="input-group">
                <label for="university">대학교</label>
                <input type="text" id="university" name="university" placeholder="대학교 입력" value="${sessionScope.loginUser.userUniversity}">
                <div id="university-message" class="message"></div>
            </div>
            <!-- 학위 -->
            <div class="input-group">
                <label for="degree">학위</label>
                <select id="degree" name="degree">
                    <option value="" ${empty sessionScope.loginUser.userDegree ? 'selected' : ''}>선택하세요</option>
                    <option value="bachelor" ${sessionScope.loginUser.userDegree == 'bachelor' ? 'selected' : ''}>학사</option>
                    <option value="master" ${sessionScope.loginUser.userDegree == 'master' ? 'selected' : ''}>석사</option>
                    <option value="doctor" ${sessionScope.loginUser.userDegree == 'doctor' ? 'selected' : ''}>박사</option>
                </select>
                <div id="degree-message" class="message"></div>
            </div>
            <!-- 졸업 여부 -->
            <div class="input-group">
                <label for="graduated">졸업 여부</label>
                <select id="graduated" name="graduated">
                    <option value="" ${empty sessionScope.loginUser.userGradulate ? 'selected' : ''}>선택하세요</option>
                    <option value="Y" ${sessionScope.loginUser.userGradulate == 'Y' ? 'selected' : ''}>졸업</option>
                    <option value="N" ${sessionScope.loginUser.userGradulate == 'N' ? 'selected' : ''}>미졸업</option>
                </select>
                <div id="graduated-message" class="message"></div>
            </div>
            <!-- 학점 -->
            <div class="input-group">
                <label for="point">학점</label>
                <input type="text" id="point" name="point" placeholder="학점 입력 (예: 3.5)" value="${sessionScope.loginUser.userPoint}">
                <div id="point-message" class="message"></div>
            </div>
            <!-- 버튼 -->
            <div class="btn-group">
                <button type="button" class="btn cancel" id="cancel">취소</button>
                <button type="button" class="btn submit" id="submit">변경하기</button>
            </div>
        </form>
    </div>
</body>
</html>