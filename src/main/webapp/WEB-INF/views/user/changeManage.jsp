<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
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
    border-left: 3px solid #ff4c4c;
    border-top: 1px solid #ff4c4c;
    border-bottom: 1px solid #ff4c4c;
    border-right: 3px solid #ff4c4c;
}

h2 {
    text-align: center;
    margin-bottom: 30px;
    font-size: 24px;
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

input[type="text"] {
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

.authority-group {
    margin: 20px 0;
    text-align: left;
    display: none;
}

.authority-group label {
    font-size: 14px;
    margin-right: 20px;
}

.authority-group input[type="radio"] {
    margin-right: 5px;
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
    transition: background-color 0.3s ease;
    width: 100%;
    max-width: 180px;
    margin: 0 auto;
}

.btn:hover {
    background-color: #3ddfdf;
}

.btn:active {
    background-color: #1aabaa;
}

.btn:disabled {
    background-color: #000;
    color: #fff;
    cursor: not-allowed;
}
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(document).ready(function() {
    try {
        const $userIdInput = $('#user-id');
        const $userIdMessage = $('#user-id-message');
        const $authorityGroup = $('.authority-group');
        const $authorityUser = $('#authority-user');
        const $authorityAdmin = $('#authority-admin');
        const $authorityReport = $('#authority-report');
        const $authorityExit = $('#authority-exit');
        const $submitButton = $('#submit');
        const $authorityMessage = $('#authority-message');

        let selectedUserId = null;
        let debounceTimer = null;

        // 유저 ID 입력 시 디바운싱 처리
        $userIdInput.on('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                const userId = $userIdInput.val().trim();
                console.log('Input userId:', userId);
                if (!userId) {
                    $userIdMessage.text('유저 ID를 입력해주세요.').addClass('error').removeClass('success');
                    $authorityGroup.hide();
                    $submitButton.prop('disabled', true).css({
                        'background-color': '#000',
                        'color': '#fff',
                        'cursor': 'not-allowed'
                    });
                    selectedUserId = null;
                    console.log('selectedUserId reset to:', selectedUserId);
                    return;
                }

                $.ajax({
                    url: 'checkMaUser.do',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ userId: userId }),
                    headers: {
                        'X-CSRF-TOKEN': $('[name=_csrf]').val()
                    },
                    success: function(response) {
                        console.log('Check user response:', response);
                        if (response.success && response.exists) {
                            $userIdMessage.text(response.message || '유저를 찾았습니다.').addClass('success').removeClass('error');
                            $authorityGroup.show();
                            selectedUserId = response.userId || userId;
                            console.log('selectedUserId set to:', selectedUserId);

                            // 권한에 따라 라디오 버튼 체크
                            $authorityUser.prop('checked', response.currentAuthority === '1');
                            $authorityAdmin.prop('checked', response.currentAuthority === '2');
                            $authorityReport.prop('checked', response.currentAuthority === '3');
                            $authorityExit.prop('checked', response.currentAuthority === '4');
                            
                            $submitButton.prop('disabled', false).css({
                                'background-color': '#2ccfcf',
                                'color': 'black',
                                'cursor': 'pointer'
                            });
                        } else {
                            $userIdMessage.text(response.message || '유저를 찾을 수 없습니다.').addClass('error').removeClass('success');
                            $authorityGroup.hide();
                            $submitButton.prop('disabled', true).css({
                                'background-color': '#000',
                                'color': '#fff',
                                'cursor': 'not-allowed'
                            });
                            selectedUserId = null;
                            console.log('selectedUserId reset to:', selectedUserId);
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('Check user error:', textStatus, errorThrown);
                        $userIdMessage.text('유저 확인 중 오류가 발생했습니다.').addClass('error').removeClass('success');
                        $authorityGroup.hide();
                        $submitButton.prop('disabled', true).css({
                            'background-color': '#000',
                            'color': '#fff',
                            'cursor': 'not-allowed'
                        });
                        selectedUserId = null;
                        console.log('selectedUserId reset to:', selectedUserId);
                    }
                });
            }, 300);
        });

        // 권한 변경 버튼 클릭
        $submitButton.on('click', function(event) {
            event.preventDefault();
            console.log('Submit clicked, selectedUserId:', selectedUserId);
            if (!selectedUserId) {
                $authorityMessage.text('유저를 먼저 선택해주세요.').addClass('error').removeClass('success');
                console.log('No selectedUserId, showing error');
                return;
            }

            const authority = $('input[name="authority"]:checked').val();
            console.log('Submitting authority:', authority, 'for userId:', selectedUserId);
            $.ajax({
                url: 'updateAuthority.do',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    userId: selectedUserId,
                    authority: authority
                }),
                headers: {
                    'X-CSRF-TOKEN': $('[name=_csrf]').val()
                },
                success: function(response) {
                    console.log('Update authority response:', response);
                    $authorityMessage.text(response.message || '권한이 변경되었습니다.').toggleClass('success', response.success).toggleClass('error', !response.success);
                    if (response.success) {
                        $submitButton.prop('disabled', false).css({
                            'background-color': '#2ccfcf',
                            'color': 'black',
                            'cursor': 'pointer'
                        });
                        // 권한 상태 동기화
                        $authorityUser.prop('checked', authority === '1');
                        $authorityAdmin.prop('checked', authority === '2');
                        $authorityReport.prop('checked', authority === '3');
                        $authorityExit.prop('checked', authority === '4');
                        console.log('Authority updated, selectedUserId retained:', selectedUserId);
                        // 메시지 2초 후 제거
                        setTimeout(() => $authorityMessage.text(''), 2000);
                    } else {
                        console.log('Authority update failed, selectedUserId:', selectedUserId);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error('Update authority error:', textStatus, errorThrown);
                    $authorityMessage.text('권한 변경 중 오류가 발생했습니다.').addClass('error').removeClass('success');
                    console.log('Authority update error, selectedUserId:', selectedUserId);
                    setTimeout(() => $authorityMessage.text(''), 2000);
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
        <h2>매니저 관리</h2>
        <div class="input-group">
            <label for="user-id">유저 ID 검색</label>
            <input type="text" id="user-id" placeholder="유저 ID를 입력하세요">
            <div class="message" id="user-id-message"></div>
        </div>
        <div class="authority-group">
            <label><input type="radio" name="authority" id="authority-user" value="1"> 유저</label>
            <label><input type="radio" name="authority" id="authority-admin" value="2"> 관리자</label>
            <label><input type="radio" name="authority" id="authority-report" value="3"> 불량</label>
            <label><input type="radio" name="authority" id="authority-exit" value="4"> 탈퇴</label>
            <div class="message" id="authority-message"></div>
        </div>
        <button type="button" class="btn" id="submit" disabled>권한 변경</button>
    </div>
</body>
</html>