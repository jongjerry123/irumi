<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style type="text/css">
body {
    background-color: #000;
    color: white;
    margin: 0;
    padding: 0;
    min-height: 90vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.container {
    text-align: center;
    max-width: 600px;
    padding: 40px;
    background-color: #000;
    border-radius: 16px;
    box-shadow: 0 0 20px rgba(255, 0, 0, 0.3);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

.container img {
    width: 300px;
    height: auto;
    margin-bottom: 30px;
    filter: drop-shadow(0 0 10px #ff4e4e);
}

.container h1 {
    font-size: 20px;
    line-height: 1.7;
    color: #ff9999;
    margin: 0;
}

</style>
</head>
<body>
    <c:import url="/WEB-INF/views/common/header.jsp" />
    
    <div class="container">
        <img src="/irumi/resources/images/ill3.png" alt="이루미 로고" class="img" />
    <h1>
            안녕하세요. <br>다량의 신고건이 확인되어 불량 유저로 등록되셨습니다. <br>
            <br>
            📩 상세 문의는 아래 이메일로 부탁드립니다. <br>
            <b>irumi@gmail.com</b>
        </h1>
</body>
</html>