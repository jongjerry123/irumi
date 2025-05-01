<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<style>
header {
    display: flex;
    align-items: center;
    justify-content: space-between; /* 좌우 끝 정렬 */
    padding: 20px 50px;
    max-width: 1200px; /* 좀 더 넓게 */
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
    cursor: pointer;
    margin-right: auto; /* 왼쪽 정렬 강제 */
}

.triangle-img {
    height: 1.2em;
    vertical-align: middle;
    transition: transform 0.2s ease; /* 부드럽게 확대 */
}

.logo-area:hover .triangle-img {
    transform: scale(1.4); /* 호버 시 삼각형 확대 */
}

.login-actions {
    display: flex;
    gap: 10px;
    margin-left: auto; /* 오른쪽 정렬 강제 */
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
                window.location.href = '/irumi';
            } else {
                alert('로그아웃에 실패했습니다.');
            }
        })
        .catch(error => {
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
            window.location.href = '/irumi';
        } else {
            alert('로그아웃에 실패했습니다.');
        }
    })
    .catch(error => {
        alert('로그아웃 중 오류가 발생했습니다.');
    });
}

// 삼각형 + irumi 클릭 시 메인페이지 이동
function moveToMain() {
    location.href = 'main.do';
}
</script>

<header>
    <div class="logo-area" onclick="moveToMain()">
        <svg class="triangle-img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <polygon points="12,6 6,18 18,18" fill="white" />
        </svg>
        <span>irumi</span>
    </div>

    <div class="login-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <c:if test="${sessionScope.loginUser.userAuthority == '2'}">
                    <button onclick="location.href='changeManage.do'">관리자 기능</button>
                </c:if>
                <c:if test="${sessionScope.loginUser.userAuthority == '1'}">
                    <button onclick="location.href='myPage.do'">마이페이지</button>
                </c:if>
                <button onclick="logout()">로그아웃</button>
            </c:when>
            <c:otherwise>
                <button onclick="moveToLogin()">로그인</button>
            </c:otherwise>
        </c:choose>
    </div>
</header>