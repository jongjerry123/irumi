<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>irumi : footer</title>
  <style>
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #000;
      color: white;
    }

    .page-wrapper {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    .main-content {
      flex: 1;
    }

    .footer-note {
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  font-size: 12px;
  opacity: 0.6;
  padding: 10px 0;
  
  width: max-content; /* ✅ 글자 크기에만 맞게 */
  z-index: 9999; /* ✅ 최상단 유지 */
}

    .footer-note a {
      color: #BAAC80;
      text-decoration: none;
    }

    .floating-menu {
      position: fixed;
      bottom: 20px;
      left: 20px;
      z-index: 1000;
      display: flex;
      flex-direction: column-reverse;
      align-items: flex-start;
    }

    .main-icon {
      cursor: pointer;
      transition: transform 0.3s;
    }

    .main-icon:hover {
      transform: scale(1.08);
    }

    .main-icon img {
      width: 48px;
      height: 48px;
      display: block;
      filter: drop-shadow(0 0 4px rgba(255,255,255,0.2));
    }

    .menu-items {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 12px;
      opacity: 0;
      pointer-events: none;
      transform: translateY(10px);
      transition: all 0.3s ease;
    }

    .menu-items.active {
      opacity: 1;
      pointer-events: auto;
      transform: translateY(0);
    }

    .menu-items li {
      display: flex;
      align-items: center;
      gap: 12px;
      background-color: #000;
      color: white;
      border-radius: 14px;
      padding: 12px 20px;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
      border-left: 8px solid transparent;
    }

    .menu-items li:hover {
      background-color: #111;
      transform: translateX(4px);
    }

    .menu-items li.active.dashboard { border-left-color: #43B7B7; }
    .menu-items li.active.chat { border-left-color: #BAAC80; }
    .menu-items li.active.community { border-left-color: #A983A3; }

    .menu-items li img {
      width: 30px;
      height: 30px;
      filter: drop-shadow(0 0 2px rgba(255,255,255,0.2));
    }
  </style>
</head>
<body>
<c:if test="${empty menu}">
  <c:set var="menu" value="community" scope="request" />
</c:if>


<footer class="footer-note">
    © 2025 이루미. by Team.iruminaty <a href="about.do">사이트 소개</a>
</footer>
  
<!-- 고정된 좌측 하단 사이드 메뉴 -->
<div class="floating-menu">
  <div class="main-icon">
    <c:choose>
      <c:when test="${menu eq 'dashboard'}">
        <img id="activeIcon" src="/irumi/resources/images/dash.png" alt="대시보드" />
      </c:when>
      <c:when test="${menu eq 'chat'}">
        <img id="activeIcon" src="/irumi/resources/images/bot.png" alt="도우미" />
      </c:when>
      <c:otherwise>
        <img id="activeIcon" src="/irumi/resources/images/comm.png" alt="커뮤니티" />
      </c:otherwise>
    </c:choose>
  </div>

  <ul class="menu-items">
    <li class="${menu eq 'dashboard' ? 'active dashboard' : ''}" onclick="location.href = 'dashboard.do'">
      <img src="/irumi/resources/images/dash.png" alt="대시보드" />
      <span>스펙 대시보드</span>
    </li>
    <li class="${menu eq 'chat' ? 'active chat' : ''}" onclick="location.href = 'Ai.do'">
      <img src="/irumi/resources/images/bot.png" alt="AI 도우미" />
      <span>대화형 도우미</span>
    </li>
    <li class="${menu eq 'community' ? 'active community' : ''}" onclick="location.href = 'freeBoard.do'">
      <img src="/irumi/resources/images/comm.png" alt="커뮤니티" />
      <span>유저 커뮤니티</span>
    </li>
  </ul>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const mainIcon = document.querySelector('.main-icon');
    const menuItems = document.querySelector('.menu-items');
    let hideTimeout = null;

    mainIcon.addEventListener('mouseenter', () => {
      clearTimeout(hideTimeout);
      showMenuItems();
    });

    mainIcon.addEventListener('mouseleave', () => {
      hideTimeout = setTimeout(() => {
        hideMenuItems();
      }, 500);
    });

    menuItems.addEventListener('mouseenter', () => {
      clearTimeout(hideTimeout);
    });

    menuItems.addEventListener('mouseleave', () => {
      hideTimeout = setTimeout(() => {
        hideMenuItems();
      }, 500);
    });

    function showMenuItems() {
      menuItems.classList.add('active');
    }

    function hideMenuItems() {
      menuItems.classList.remove('active');
    }
  });
</script>
</body>
</html>