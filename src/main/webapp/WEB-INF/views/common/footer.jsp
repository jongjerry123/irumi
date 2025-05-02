<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi : footer</title>
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

  .menu-items.active {
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
<c:if test="${empty menu}">
  <c:set var="menu" value="community" scope="request" />
</c:if>

<div class="floating-menu">
  <!-- 메인 아이콘 -->
  <div class="main-icon">
    <c:choose>
      <c:when test="${menu eq 'dashboard'}">
        <img id="activeIcon" src="/irumi/resources/images/dashboard.png" alt="대시보드" />
      </c:when>
      <c:when test="${menu eq 'chat'}">
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
        class="${menu eq 'dashboard' ? 'active' : ''}"
        onclick="location.href = 'dashboard.do'">
      <img src="/irumi/resources/images/dashboard.png" alt="대시보드" class="icon-img" />
      <span>스펙 대시보드</span>
    </li>
    <li data-icon="<c:url value='/resources/icons/chat-icon.png' />"
        class="${menu eq 'chat' ? 'active' : ''}"
        onclick="location.href = 'Ai.do'">
      <img src="/irumi/resources/images/ai.png" alt="AI" class="icon-img" />
      <span>대화형 도우미</span>
    </li>
    <li data-icon="<c:url value='/resources/icons/globe-icon.png' />"
        class="${menu eq 'community' ? 'active' : ''}"
        onclick="location.href = 'freeBoard.do'">
      <img src="/irumi/resources/images/community.png" alt="커뮤니티" class="icon-img" />
      <span>유저 커뮤니티</span>
    </li>
  </ul>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
	  const floatingMenu = document.querySelector('.floating-menu');
	  const mainIcon = document.querySelector('.main-icon');
	  const menuItems = document.querySelector('.menu-items');

	  let isMouseInPath = false;
	  let hideTimeout = null;
	  let lastMouseMoveTime = 0;
	  const throttleDelay = 16; // 약 60fps에 해당하는 딜레이 (1000ms / 60)

	  // 디바운싱된 마우스 이동 이벤트 리스너
	  function throttleMouseMove(callback) {
	    return function(e) {
	      const now = Date.now();
	      if (now - lastMouseMoveTime >= throttleDelay) {
	        lastMouseMoveTime = now;
	        callback(e);
	      }
	    };
	  }

	  // 마우스 이동 처리
	  const handleMouseMove = throttleMouseMove(function(e) {
	    const iconRect = mainIcon.getBoundingClientRect();
	    const itemsRect = menuItems.getBoundingClientRect();
	    const mouseX = e.clientX;
	    const mouseY = e.clientY;

	    // .main-icon 안에 마우스가 있는 경우
	    if (mouseX >= iconRect.left && mouseX <= iconRect.right &&
	        mouseY >= iconRect.top && mouseY <= iconRect.bottom) {
	      isMouseInPath = true;
	      clearTimeout(hideTimeout); // 숨김 타이머 취소
	      showMenuItems();
	    }
	    // .menu-items 안에 마우스가 있는 경우
	    else if (mouseX >= itemsRect.left && mouseX <= itemsRect.right &&
	             mouseY >= itemsRect.top && mouseY <= itemsRect.bottom) {
	      if (!isMouseInPath) {
	        hideMenuItems(); // 직접 이동한 경우 숨김
	      } else {
	        clearTimeout(hideTimeout); // 숨김 타이머 취소
	        showMenuItems(); // .main-icon에서 이동한 경우 유지
	      }
	    }
	    // .floating-menu 밖에 있는 경우
	    else {
	      if (isMouseInPath) {
	        // .main-icon에서 밖으로 나간 경우 1초 후 숨김
	        hideTimeout = setTimeout(() => {
	          hideMenuItems();
	          isMouseInPath = false;
	        }, 500);
	      }
	    }
	  });

	  document.addEventListener('mousemove', handleMouseMove);

	  // .floating-menu에서 떠날 때
	  floatingMenu.addEventListener('mouseleave', function() {
	    hideTimeout = setTimeout(() => {
	      hideMenuItems();
	      isMouseInPath = false;
	    }, 1000);
	  });

	  // .main-icon에 다시 진입하면 타이머 취소
	  mainIcon.addEventListener('mouseenter', function() {
	    clearTimeout(hideTimeout);
	    isMouseInPath = true;
	    showMenuItems();
	  });

	  // .menu-items 클릭 이벤트 추가
	  menuItems.addEventListener('click', function(e) {
	    const target = e.target.closest('li');
	    if (!target) return;

	    const action = target.getAttribute('data-action');
	    if (action) {
	      handleMenuItemClick(action);
	    }
	  });

	  function showMenuItems() {
	    menuItems.classList.add('active');
	  }

	  function hideMenuItems() {
	    menuItems.classList.remove('active');
	  }

	  // 메뉴 항목 클릭 처리
	  function handleMenuItemClick(action) {
	    console.log(`Menu item clicked: ${action}`);
	    // 실제 동작 구현 예시
	    switch (action) {
	      case 'item1':
	        alert('Item 1 clicked!');
	        break;
	      case 'item2':
	        alert('Item 2 clicked!');
	        break;
	      case 'item3':
	        alert('Item 3 clicked!');
	        break;
	      default:
	        console.log('Unknown action:', action);
	    }
	  }
	});
</script>

</body>
</html>
