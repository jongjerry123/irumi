<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true" %>

 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi : error</title>
</head>
<body>
<h1>오류 발생</h1>

 <c:set var="e" value="<%= exception %>" />
 <c:if test="${ !empty e }">
 	<h3>jsp 페이지 오류 : ${ e.message }</h3>
 </c:if>
 <c:if test="${ empty e }">
 	<h3>백앤드 서버측 오류 : ${ requestScope.message }</h3>
</c:if>

  <a href="main.do">메인 페이지로 이동</a>
</body>
</html>