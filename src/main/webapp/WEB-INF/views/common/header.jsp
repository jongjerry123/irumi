<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" />
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<style>
* {
    font-family: 'Pretendard', sans-serif !important;
}

header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 9999;
    background-color: #000;
    height: 70px;
    padding: 0 50px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    box-sizing: border-box;
}

.logo-area {
    display: flex;
    align-items: center;
    gap: 5px;
    cursor: pointer;
    transition: transform 0.2s ease;
    font-size: 30px;
    font-weight: bold;
    color: white;
}

.logo-area:hover {
    transform: scale(1.1);
}

.triangle-img {
    width: 32px;
    height: 32px;
    vertical-align: middle;
}

.login-actions {
    display: flex;
    align-items: center;
    gap: 12px;
}

.login-actions button {
    background-color: transparent;
    border: 1px solid #222;
    color: white;
    padding: 8px 18px;
    border-radius: 10px;
    font-size: 15px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.login-actions button:hover {
    border-color: #fff;
    transform: translateY(-2px);
}
</style>

<script type="text/javascript">
function moveToLogin() {
    location.href = 'loginPage.do';
}

function logout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        const token = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
        const header = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';

        const headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        };
        if (token && header) headers[header] = token;

        fetch('logout.do', {
            method: 'POST',
            headers: headers
        })
        .then(response => {
            if (response.ok) {
                window.location.href = '/irumi';
            } else {
                alert('로그아웃에 실패했습니다.');
            }
        })
        .catch(() => alert('로그아웃 중 오류가 발생했습니다.'));
    }
}

function moveToMain() {
    location.href = 'main.do';
}
</script>

<script>
window.addEventListener('DOMContentLoaded', () => {
    const headerHeight = document.querySelector('header').offsetHeight;
    document.body.style.paddingTop = headerHeight + 'px';
});
</script>

<header>
    <div class="logo-area" onclick="moveToMain()">
        <img src="/irumi/resources/images/eye.png" class="triangle-img" alt="로고" />
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