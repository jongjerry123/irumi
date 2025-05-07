<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if>
<c:set var="nowpage" value="1" />
<c:if test="${ !empty requestScope.paging.currentPage }">
	<c:set var="nowpage" value="${ requestScope.paging.currentPage }" />
</c:if>
<!DOCTYPE html>
<html lang="ko">
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

form.sform {
	text-align: center;
	margin-top: 30px;
}

fieldset {
	border: 2px solid #009688;
	border-radius: 10px;
	display: inline-block;
	padding: 20px 30px;
	background-color: #222;
}

legend {
	font-size: 1.2em;
	font-weight: bold;
	color: #00bfa5;
}

input[type="search"] {
	padding: 8px;
	border: 1px solid #555;
	border-radius: 5px;
	width: 400px;
	background: #333;
	color: white;
}

input[type="submit"] {
	padding: 8px 16px;
	border: none;
	border-radius: 5px;
	background-color: #00bfa5;
	color: white;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.3s;
}

input[type="submit"]:hover {
	background-color: #00796b;
}

table {
	width: 1000px;
	margin: 40px auto;
	border-collapse: collapse;
	background-color: #1e1e1e;
	box-shadow: 0 0 10px rgba(0,0,0,0.5);
}

th, td {
	padding: 12px;
	border: 1px solid #444;
}

th {
	background-color: #009688;
	color: white;
}

td {
	color: #ccc;
}

td a {
	color: #80cbc4;
	text-decoration: none;
}

td a:hover {
	text-decoration: underline;
}
</style>
</head>
<body>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />
	
	<form action="jobSearch.do" id="jobform" class="sform" method="get">
	<fieldset>
		<legend>검색할 직업을 입력하세요.</legend>
			<input type="search" name="keyword" size="50"> &nbsp;
			<input type="submit" value="검색">
	</fieldset>
	</form>
	
	<table>
		<tr>
			<th width="100px">직업</th>
			<th>내용</th>
			<th width="100px">분류</th>
		</tr>
		<c:forEach items="${ requestScope.list }" var="jobList">
			<tr align="center">
				<td>
					<c:url var="link" value="jobDetail.do">
						<c:param name="jobListId" value="${ jobList.jobListId }" />
					</c:url>
					<a href="${ link }">${ jobList.jobName }</a>
				</td>
				<td align="left">${ jobList.jobExplain }</td>
				<td>${ jobList.jobType }</td>
			</tr>
		</c:forEach>
	</table>
	
	<c:import url="/WEB-INF/views/common/pagingView.jsp" />
	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>