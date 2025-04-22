<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title></title>
<style type="text/css">
  body {
    margin: 0;
    padding: 0;
    background-color: #111;
    font-family: 'Noto Sans KR', sans-serif;
    color: white;
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
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background-color: #222;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
  }

  .main-icon img {
    width: 32px;
    height: 32px;
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

  .floating-menu:hover .menu-items {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
  }

  .menu-items li {
    display: flex;
    align-items: center;
    gap: 12px;
    background-color: #2a2a2a;
    color: white;
    border-radius: 30px;
    padding: 12px 20px;
    font-size: 16px;
    cursor: pointer;
    opacity: 0.6;
    transition: background-color 0.3s, opacity 0.3s;
  }

  .menu-items li:hover {
    background-color: #444;
    opacity: 1;
  }

  .menu-items li.active {
    background-color: #555;
    opacity: 1;
  }

  .menu-items li img {
    width: 24px;
    height: 24px;
  }
</style>
</head>
<body>

<%
  String currentMenu = request.getParameter("menu");
  if (currentMenu == null) currentMenu = "community";
  request.setAttribute("currentMenu", currentMenu);
%>

<div class="floating-menu">
  <!-- 메인 아이콘 -->
  <div class="main-icon">
    <c:choose>
      <c:when test="${currentMenu eq 'dashboard'}">
        <img id="activeIcon" src="/irumi/resources/images/dashboard.png" alt="대시보드" />
      </c:when>
      <c:when test="${currentMenu eq 'chat'}">
        <img id="activeIcon" src="/irumi/resources/images/ai.png" alt="도우미" />
      </c:when>
      <c:otherwise>
        <img id="activeIcon" src="/irumi/resources/images/community.png" alt="커뮤니티" />
      </c:otherwise>
    </c:choose>
  </div>

  <!-- 펼쳐지는 메뉴 -->
  <ul class="menu-items">
    <li data-icon="<c:url value='/resources/icons/chart-icon.png' />"
        class="${currentMenu eq 'dashboard' ? 'active' : ''}"
        onclick="location.href = 'viewDash.do'">
      <img src="/irumi/resources/images/dashboard.png" alt="대시보드" class="icon-img" />
      <span>스펙 대시보드</span>
    </li>
    <li data-icon="<c:url value='/resources/icons/chat-icon.png' />"
        class="${currentMenu eq 'chat' ? 'active' : ''}"
        onclick="location.href = 'Ai.do'">
      <img src="/irumi/resources/images/ai.png" alt="AI" class="icon-img" />
      <span>대화형 도우미</span>
    </li>
    <li data-icon="<c:url value='/resources/icons/globe-icon.png' />"
        class="${currentMenu eq 'community' ? 'active' : ''}"
        onclick="location.href = 'viewPost.do'">
      <img src="/irumi/resources/images/community.png" alt="커뮤니티" class="icon-img" />
      <span>유저 커뮤니티</span>
    </li>
  </ul>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const menuItems = document.querySelectorAll('.menu-items li');
    const activeIcon = document.getElementById('activeIcon');

    menuItems.forEach(item => {
      item.addEventListener('click', () => {
        const newIcon = item.getAttribute('data-icon');
        activeIcon.src = newIcon;
      });
    });
  });
</script>

</body>
</html>
