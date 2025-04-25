<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>chatbot</title>
<script>

	function moveJobPage() {
		location.href = 'viewJobRecChat.do';
	}

	function moveActPage() {
		location.href = 'viewActRecChat.do';
	}
</script>
<style>
body {
	background-color: #111;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
}

header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 50px;
}

</style>

</head>
<body>
<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
<hr>
<h1>챗봇 시작화면</h1>
<hr>
<button onclick="moveJobPage();">직무 페이지로 이동</button>
<button onclick="moveActPage();">활동 페이지로 이동</button>









<hr color="white">
<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>


</body>
</html>