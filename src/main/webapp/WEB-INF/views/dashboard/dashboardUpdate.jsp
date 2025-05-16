<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>irumi</title>
<style>
body {
    background-color: #000;
    color: white;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

.container {
    background-color: #000;
    border-radius: 10px;
    padding: 40px;
    width: 400px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
    margin: 150px auto 50px;
    text-align: center;
    border: 1px solid #43B7B7;
}

h2 {
    text-align: center;
    margin-bottom: 30px;
}

.input-group {
    margin-bottom: 20px;
    text-align: left;
}

.input-group label {
    display: block;
    font-size: 14px;
    margin-bottom: 5px;
}

input[type="text"], input[type="number"] {
    width: 100%;
    height: 40px;
    padding: 0 12px;
    border: 1px solid #444;
    border-radius: 6px;
    background-color: #121212;
    color: white;
    box-sizing: border-box;
    font-size: 14px;
}

input[type="number"] {
    width: 100px; /* Matches the narrower width for point input */
}

/* Radio button styling */
input[type="radio"] {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    width: 16px;
    height: 16px;
    border: 1px solid #444;
    border-radius: 50%;
    background-color: #121212;
    margin: 0 5px 0 0;
    vertical-align: middle;
    position: relative;
    cursor: pointer;
}

input[type="radio"]:checked::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 8px;
    height: 8px;
    background-color: #2ccfcf;
    border-radius: 50%;
    transform: translate(-50%, -50%);
}

.radio-group {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
}

.radio-group label {
    display: inline-flex;
    align-items: center;
    font-size: 14px;
    color: #ccc;
    cursor: pointer;
}

.btn-group {
    display: flex;
    gap: 10px;
    justify-content: center;
}

.btn {
    height: 40px;
    padding: 0 20px;
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
    font-size: 14px;
    box-sizing: border-box;
    background-color: #2ccfcf;
    color: black;
}

.btn.cancel {
    background-color: #444;
    color: white;
}
</style>
<script type="text/javascript" src="${pageContext.servletContext.contextPath}/resources/js/jquery-3.7.1.min.js"></script>
</head>
<body>
    <c:set var="menu" value="dashboard" scope="request" />
    <c:import url="/WEB-INF/views/common/header.jsp" />

    <div class="container">
        <h2>학력 정보</h2>
        <form action="dashUpdate.do" method="post">
            <input type="hidden" name="userId" value="${requestScope.dashboard.userId}">
            
            <!-- University -->
            <div class="input-group">
                <label for="userUniversity">대학교</label>
                <input type="text" id="userUniversity" name="userUniversity" value="${requestScope.dashboard.userUniversity}">
            </div>
            
            <!-- Degree -->
            <div class="input-group">
                <label>학위</label>
                <div class="radio-group">
                    <c:choose>
                        <c:when test="${empty requestScope.dashboard.userDegree}">
                            <input type="radio" name="userDegree" id="bs" value="학사">
                            <label for="bs">학사</label>
                            <input type="radio" name="userDegree" id="ms" value="석사">
                            <label for="ms">석사</label>
                            <input type="radio" name="userDegree" id="phd" value="박사">
                            <label for="phd">박사</label>
                            <input type="radio" name="userDegree" id="etc" value="기타">
                            <label for="etc">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userDegree eq '학사'}">
                            <input type="radio" name="userDegree" id="bs" value="학사" checked>
                            <label for="bs">학사</label>
                            <input type="radio" name="userDegree" id="ms" value="석사">
                            <label for="ms">석사</label>
                            <input type="radio" name="userDegree" id="phd" value="박사">
                            <label for="phd">박사</label>
                            <input type="radio" name="userDegree" id="etc" value="기타">
                            <label for="etc">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userDegree eq '석사'}">
                            <input type="radio" name="userDegree" id="bs" value="학사">
                            <label for="bs">학사</label>
                            <input type="radio" name="userDegree" id="ms" value="석사" checked>
                            <label for="ms">석사</label>
                            <input type="radio" name="userDegree" id="phd" value="박사">
                            <label for="phd">박사</label>
                            <input type="radio" name="userDegree" id="etc" value="기타">
                            <label for="etc">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userDegree eq '박사'}">
                            <input type="radio" name="userDegree" id="bs" value="학사">
                            <label for="bs">학사</label>
                            <input type="radio" name="userDegree" id="ms" value="석사">
                            <label for="ms">석사</label>
                            <input type="radio" name="userDegree" id="phd" value="박사" checked>
                            <label for="phd">박사</label>
                            <input type="radio" name="userDegree" id="etc" value="기타">
                            <label for="etc">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userDegree eq '기타'}">
                            <input type="radio" name="userDegree" id="bs" value="학사">
                            <label for="bs">학사</label>
                            <input type="radio" name="userDegree" id="ms" value="석사">
                            <label for="ms">석사</label>
                            <input type="radio" name="userDegree" id="phd" value="박사">
                            <label for="phd">박사</label>
                            <input type="radio" name="userDegree" id="etc" value="기타" checked>
                            <label for="etc">기타</label>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            
            <!-- Graduation Status -->
            <div class="input-group">
                <label>졸업 여부</label>
                <div class="radio-group">
                    <c:choose>
                        <c:when test="${empty requestScope.dashboard.userGraduate}">
                            <input type="radio" name="userGraduate" id="grad" value="졸업">
                            <label for="grad">졸업</label>
                            <input type="radio" name="userGraduate" id="curr" value="재학">
                            <label for="curr">재학</label>
                            <input type="radio" name="userGraduate" id="loa" value="휴학">
                            <label for="loa">휴학</label>
                            <input type="radio" name="userGraduate" id="none" value="기타">
                            <label for="none">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userGraduate eq '졸업'}">
                            <input type="radio" name="userGraduate" id="grad" value="졸업" checked>
                            <label for="grad">졸업</label>
                            <input type="radio" name="userGraduate" id="curr" value="재학">
                            <label for="curr">재학</label>
                            <input type="radio" name="userGraduate" id="loa" value="휴학">
                            <label for="loa">휴학</label>
                            <input type="radio" name="userGraduate" id="none" value="기타">
                            <label for="none">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userGraduate eq '재학'}">
                            <input type="radio" name="userGraduate" id="grad" value="졸업">
                            <label for="grad">졸업</label>
                            <input type="radio" name="userGraduate" id="curr" value="재학" checked>
                            <label for="curr">재학</label>
                            <input type="radio" name="userGraduate" id="loa" value="휴학">
                            <label for="loa">휴학</label>
                            <input type="radio" name="userGraduate" id="none" value="기타">
                            <label for="none">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userGraduate eq '휴학'}">
                            <input type="radio" name="userGraduate" id="grad" value="졸업">
                            <label for="grad">졸업</label>
                            <input type="radio" name="userGraduate" id="curr" value="재학">
                            <label for="curr">재학</label>
                            <input type="radio" name="userGraduate" id="loa" value="휴학" checked>
                            <label for="loa">휴학</label>
                            <input type="radio" name="userGraduate" id="none" value="기타">
                            <label for="none">기타</label>
                        </c:when>
                        <c:when test="${requestScope.dashboard.userGraduate eq '기타'}">
                            <input type="radio" name="userGraduate" id="grad" value="졸업">
                            <label for="grad">졸업</label>
                            <input type="radio" name="userGraduate" id="curr" value="재학">
                            <label for="curr">재학</label>
                            <input type="radio" name="userGraduate" id="loa" value="휴학">
                            <label for="loa">휴학</label>
                            <input type="radio" name="userGraduate" id="none" value="기타" checked>
                            <label for="none">기타</label>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            
            <!-- GPA -->
            <div class="input-group">
                <label for="userPoint">학점</label>
                <input type="number" id="userPoint" name="userPoint" min="0" max="9.99" step=".01" value="${requestScope.dashboard.userPoint}">
            </div>
            
            <!-- Buttons -->
            <div class="btn-group">
                <button type="reset" class="btn cancel">수정취소</button>
                <button type="submit" class="btn">수정하기</button>
            </div>
        </form>
    </div>

    <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>