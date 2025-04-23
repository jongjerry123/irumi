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
	color: black;
}
</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
<script>
$(function() {
	$.ajax({
		url: "userSpecView.do",
		method: "POST",
		dataType: "json",
		success: function(data) {
			console.log("Dashboard: " + data);
		},
		error: function(xhr, status, error) {
			console.error("에러 발생:", error);
		}
	});
});
</script>
</head>
<body>
<c:set var="menu" value="dashboard" scope="request" />
<c:import url="/WEB-INF/views/common/header.jsp" />
<div class="education-info" style="padding: 20px; background: #f9f9f9; border-radius: 10px; max-width: 500px; margin-left: 50px;">
  <h2>학력 정보</h2>
  <div style="margin-bottom: 10px;">
    <label for="university">대학교:</label><br>
  </div>
  <div style="margin-bottom: 10px;">
    <label for="degree">학위:</label><br>
  </div>
  <div style="margin-bottom: 10px;">
    <label for="graduation">졸업 여부:</label><br>
    </select>
  </div>
  <div style="margin-bottom: 10px;">
    <label for="gpa">학점:</label><br>
  </div>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>