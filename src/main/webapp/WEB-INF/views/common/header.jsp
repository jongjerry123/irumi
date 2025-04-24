<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<style>
header {
    display: flex;
    align-items: center;
    padding: 20px 50px;
    max-width: 1000px;
    margin: 0 auto;
    color: white;
    font-family: 'Noto Sans KR', sans-serif;
}

.logo-area {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 24px;
    font-weight: bold;
}

.triangle-img {
    height: 1.2em;
    vertical-align: middle;
}

.login-actions {
    margin-left: auto;
    display: flex;
    gap: 10px;
}

.login-actions button {
    background-color: transparent;
    color: white;
    border: 1px solid #ccc;
    padding: 6px 12px;
    border-radius: 5px;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.login-actions button:hover {
    background-color: #fff;
    color: #000;
}
</style>

<script type="text/javascript">
function moveToLogin() {
    location.href = 'loginPage.do';
}

function logout() {
    const token = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
    const header = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';
    
    if (!token || !header) {
        console.warn('CSRF token or header not found, attempting logout without CSRF');
        fetch('logout.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
        .then(response => {
            if (response.ok) {
                console.log('Logout successful');
                window.location.href = '/irumi';
            } else {
                console.error('Logout failed:', response.status);
                alert('로그아웃에 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('Error during logout:', error);
            alert('로그아웃 중 오류가 발생했습니다.');
        });
        return;
    }

    fetch('logout.do', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            [header]: token
        }
    })
    .then(response => {
        if (response.ok) {
            console.log('Logout successful');
            window.location.href = '/irumi';
        } else {
            console.error('Logout failed:', response.status);
            alert('로그아웃에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('Error during logout:', error);
        alert('로그아웃 중 오류가 발생했습니다.');
    });
}
</script>

<header>
    <div class="logo-area">
        <svg class="triangle-img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <polygon points="12,6 6,18 18,18" fill="white" />
        </svg>
        irumi
    </div>
    <div class="login-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <!-- 권한이 1인 경우: 관리자 기능 버튼 표시 -->
                <c:if test="${sessionScope.loginUser.userAuthority == '1'}">
                    <button onclick="location.href='adminPage.do'">관리자 기능</button>
                </c:if>
                <!-- 권한이 2인 경우: 마이페이지 버튼 표시 -->
                <c:if test="${sessionScope.loginUser.userAuthority == '2'}">
                    <button onclick="location.href='myPage.do'">마이페이지</button>
                </c:if>
                <!-- 로그아웃 버튼 -->
                <button onclick="logout()">로그아웃</button>
            </c:when>
            <c:otherwise>
                <!-- 비로그인 상태: 로그인 버튼 -->
                <button onclick="moveToLogin()">로그인</button>
            </c:otherwise>
        </c:choose>
    </div>
</header>