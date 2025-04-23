<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi</title>
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
.education-info {
	color: white;
}
.buttons {
	margin-left: auto;
	display: flex;
	gap: 10px;
}

.buttons button {
	background-color: transparent;
	color: white;
	border: 1px solid #ccc;
	padding: 6px 12px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.buttons button:hover {
	background-color: #fff;
	color: #000;
}
</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
<script>
function movetoUpDash() {
	// TODO: 로그인 기능 완성되면 주석 풀기
	// location.href = 'upDash.do?userId=${ sessionScope.loginUser.userId }';
	location.href = 'upDash.do?userId=user1';

}
// 학력정보를 표시함
$(function() {
	$.ajax({
		url: "userSpecView.do",
		method: "POST",
		dataType: "json",
		success: function(data) {
			console.log("Dashboard: " + data);
			if (data.userUniversity == null) {
				$('#university').html($('#university').html() + ' 대학정보를 기입해주세요');
			}
			else {
				$('#university').html($('#university').html() + ' ' + data.userUniversity);
			}
			if (data.userDegree == null) {
				$('#degree').html($('#degree').html() + ' 학위정보를 기입해주세요');
			}
			else {
				$('#degree').html($('#degree').html() + ' ' + data.userDegree);
			}
			if (data.userGraduate == null) {
				$('#graduation').html($('#graduation').html() + ' 졸업정보를 기입해주세요');
			}
			else {
				$('#graduation').html($('#graduation').html() + ' ' + data.userGraduate);
			}
			if (data.userPoint == null) {
				$('#gpa').html($('#gpa').html() + ' 학점을 기입해주세요');
			}
			else {
				$('#gpa').html($('#gpa').html() + ' ' + data.userPoint);
			}
			
		},
		error: function(xhr, status, error) {
			
			console.error("에러 발생:", error);
			
		}
	});
});
</script>

</head>
<body>

<!-- TODO: 로그인 상태가 아닌 경우 로그인 페이지로 이동 -->
<%-- <c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if> --%>

<!-- footer에 페이지를 제대로 표시하기 위해 menu를 request scope에서 dashboard로 설정함 -->
<c:set var="menu" value="dashboard" scope="request" />

<!-- header 표시 -->
<c:import url="/WEB-INF/views/common/header.jsp" />

<!-- 학력 정보 표시를 위한 칸 -->
<div class="education-info" style="padding: 20px; background: #303030; border-radius: 10px; max-width: 400px; margin-left: 50px;">
	<h2>학력 정보</h2>
	<div style="margin-bottom: 10px;">
		<label id="university">대학교: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="degree">학위: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="graduation">졸업 여부: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="gpa">학점: </label><br>
	</div>
	<div class="buttons">
		<button onclick="movetoUpDash()">수정하기</button>
	</div>
</div>




<!-- footer 표시 -->
<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>