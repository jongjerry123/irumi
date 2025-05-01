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
	
	<br>
	<br>
	
	<table align="center" width="1000" border="1" cellspacing="0" cellpadding="0">
		<tr>
			<th>직업</th>
			<th>내용</th>
			<th>분류</th>
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
	<br>
	
	<c:import url="/WEB-INF/views/common/pagingView.jsp" />
	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
