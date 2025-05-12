<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
		color: #f1f1f1;
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

	h1 {
		text-align: center;
		margin-top: 40px;
		font-size: 32px;
		color: #009688;
	}

	form {
		max-width: 1000px;
		margin: 30px auto;
		padding: 30px;
		background-color: #1a1a1a;
		border-radius: 10px;
		box-shadow: 0 0 10px rgba(0,0,0,0.6);
	}

	table {
		width: 100%;
		border-collapse: collapse;
		background-color: #2a2a2a;
		color: #eee;
		margin-bottom: 20px;
	}

	th, td {
		padding: 15px;
		border: 1px solid #444;
	}

	th {
		background-color: #333;
		text-align: left;
		width: 20%;
		color: #bbb;
	}

	td textarea {
		width: 90%;
		padding: 10px;
		border: none;
		border-radius: 5px;
		background-color: #444;
		color: #fff;
	}

	.buttons {
		text-align: center;
		margin-top: 20px;
	}

	button {
		background: #1a1a1a;
		color: #009688;
		border: 1px solid #009688;
		padding: 12px 24px;
		font-size: 16px;
		border-radius: 6px;
		cursor: pointer;
		transition: background-color 0.2s, color 0.2s;
	}

	button:hover {
		background-color: #009688;
		color: #fff;
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
				<td><textarea name="jobExplain" rows="10" readonly>${ requestScope.jobList.jobExplain }</textarea></td>
			</tr>
		</table>
		
		<div class="buttons">
			<button type="submit">목표 직무에 추가하고 스펙 설정하러 가기</button>
		</div>
	</form>
	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>