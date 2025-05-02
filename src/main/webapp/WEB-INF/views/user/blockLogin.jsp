<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi - 탈퇴유저</title>
<style type="text/css">
body {
    background-color: #111;
    color: white;
    font-family: 'Noto Sans KR', sans-serif;
    margin: 0;
    padding: 0;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 50px;
    background-color: #111;
    position: fixed;
    width: 100%;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1000;
    box-sizing: border-box;
}
</style>
</head>
<body>
    <c:import url="/WEB-INF/views/common/header.jsp" />
    <h1>안녕하세요. 탈퇴이력이 있어 해당 페이지로 이동되셨습니다. 상세문의는 아래의 이메일로 부탁드립니다.<br>
    irumi@gamil.com</h1>
</body>
</html>