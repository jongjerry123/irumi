<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if>
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
</style>
</head>
<body>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />
	
	<h1 align="center">${ requestScope.jobList.jobName }</h1>
	<form action="insertJob.do" method="post">
		<input type="text" name="jobName" readonly value="${ requestScope.jobList.jobName }" hidden>
		<table align="center" width="1000" border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>내용</th>
				<td><input type="text" size="100" name="jobExplain" readonly value="${ requestScope.jobList.jobExplain }"></td>
			</tr>
		</table>
		
		<div class="buttons">
			<button type="submit">목표 직무에 추가하고 스펙 설정하러 가기</button>
		</div>
	</form>
	<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>