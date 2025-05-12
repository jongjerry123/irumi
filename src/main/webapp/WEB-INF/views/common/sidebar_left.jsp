
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="${ pageContext.servletContext.contextPath}/resources/css/sidebar_left.css" />

<script type="text/javascript">
// 삼각형 + irumi 클릭 시 메인페이지 이동
function moveToMain() {
    location.href = 'main.do';
}

const CHAT_TOPIC = "${chatTopic}";

document.addEventListener("DOMContentLoaded", function () {
    const btn = document.getElementById(CHAT_TOPIC);
    if (btn) {
        btn.classList.add("active");
    }
});
</script>
</head>
<body>

<div class="left-sidebar">
	

	<div class="sidebar">
		<button onclick="moveJobPage();" id="act">직무 찾기</button>
		<button onclick="moveSpecPage();" id="spec">스펙 찾기</button>
		<button onclick="moveSchedulePage();" id="ss">일정 찾기</button>
		<button onclick="moveActPage();" id="act">활동 찾기</button>
	</div>
	
</div>
</body>
</html>