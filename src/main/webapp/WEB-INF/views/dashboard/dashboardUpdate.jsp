<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	color: #009688;
	border: 1px solid #009688;
	padding: 6px 12px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.buttons button:hover {
	background-color: #009688;
	color: #fff;
}

/* 기본 라디오 숨김 */
input[type="radio"] {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

/* 레이블 기본 */
label {
  display: inline-block;
  position: relative;
  padding: 0.5em 1em;
  margin-right: 0.5em;
  cursor: pointer;
  color: #fff;
  transition:
  color 0.3s;
}

/* 호버 언더라인 */
label::after {
  content: ""; position: absolute; left: 0; bottom: 0;
  width: 100%; height: 2px; background: #009688;
  transform: scaleX(0); transform-origin: left;
  transition: transform 0.3s;
}
label:hover { color: #009688; }
label:hover::after { transform: scaleX(1); }

/* 클릭 배경 및 물결 */
input[type="radio"]:checked + label {
  color: #fff; background: #009688; border-radius: 4px;
}

input[type="radio"]:checked + label::before {
  content: "";
  position: absolute;
  left: 50%;
  top: 50%;
  width: 0;
  height: 0;
  background: rgba(0,150,136,0.4);
  border-radius: 50%;
  transform: translate(-50%,-50%);
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  to { width: 200%; height: 200%; opacity: 0; }
}

input[type="text"] {
  padding: 0.5em 0.8em;
  border: 1px solid #ccc;
  border-radius: 0.25em;
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
  font-size: 1em;
  width: 7em;
  transition: border-color 0.2s, box-shadow 0.2s;
}

/* 기본 입력 필드 스타일 */
input[type="number"] {
  padding: 0.5em 0.8em;
  border: 1px solid #ccc;
  border-radius: 0.25em;
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
  font-size: 1em;
  width: 4em;
  transition: border-color 0.2s, box-shadow 0.2s;
}

/* 호버 시 테두리 색 변화 */
input[type="text"]:hover, input[type="number"]:hover {
  border-color: #888;
}

/* 포커스 시 강조 효과 */
input[type="text"]:focus, input[type="number"]:focus {
  outline: none;
  border-color: #66afe9;
  box-shadow: 0 0 5px rgba(102,175,233,0.5);
}

/* 선택적: 레이블과 정렬 */
div > input[type="text"], div > input[type="number"] {
  vertical-align: middle;  /* 레이블과 수직 중앙 정렬 :contentReference[oaicite:8]{index=8} */
  margin-left: 0.5em;
}

/* 컨테이너 기본 */
div {
  margin-bottom: 10px;
  font-family: Arial, sans-serif;
  font-size: 1em;
  color: #fff;
}

</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
</head>
<body>



<!-- footer에 페이지를 제대로 표시하기 위해 menu를 request scope에서 dashboard로 설정함 -->
<c:set var="menu" value="dashboard" scope="request" />

<!-- header 표시 -->
<c:import url="/WEB-INF/views/common/header.jsp" />

<!-- 학력 정보 수정을 위한 칸 -->
<form action="dashUpdate.do" method="post">
	<input type="hidden" name="userId" value="${ requestScope.dashboard.userId }">
	<div class="education-info" style="padding: 20px; background: #303030; border-radius: 10px; max-width: 400px; margin: auto;">
		<h2>학력 정보</h2>
		<div style="margin-bottom: 10px;">
			대학교: 
			<input type="text" name="userUniversity" value="${ requestScope.dashboard.userUniversity }">
			<br>
		</div>
		<div style="margin-bottom: 10px;">
			학위: <br>
			<!-- null일 때 -->
			<c:if test="${ empty requestScope.dashboard.userDegree }">
			<input type="radio" name="userDegree" id="bs" value="학사">
				<label for="bs">학사 </label>
			<input type="radio" name="userDegree" id="ms" value="석사">
				<label for="ms">석사 </label>
			<input type="radio" name="userDegree" id="phd" value="박사">
				<label for="phd">박사 </label>
			<input type="radio" name="userDegree" id="etc" value="기타">
				<label for="etc">기타 </label>
			</c:if>
			<!-- 학사일 때 -->
			<c:if test="${ requestScope.dashboard.userDegree eq '학사' }">
			<input type="radio" name="userDegree" id="bs" value="학사" checked>
				<label for="bs">학사 </label>
			<input type="radio" name="userDegree" id="ms" value="석사">
				<label for="ms">석사 </label>
			<input type="radio" name="userDegree" id="phd" value="박사">
				<label for="phd">박사 </label>
			<input type="radio" name="userDegree" id="etc" value="기타">
				<label for="etc">기타 </label>
			</c:if>
			<!-- 석사일 때 -->
			<c:if test="${ requestScope.dashboard.userDegree eq '석사' }">
			<input type="radio" name="userDegree" id="bs" value="학사">
				<label for="bs">학사 </label>
			<input type="radio" name="userDegree" id="ms" value="석사" checked>
				<label for="ms">석사 </label>
			<input type="radio" name="userDegree" id="phd" value="박사">
				<label for="phd">박사 </label>
			<input type="radio" name="userDegree" id="etc" value="기타">
				<label for="etc">기타 </label>
			</c:if>
			<!-- 박사일 때 -->
			<c:if test="${ requestScope.dashboard.userDegree eq '박사' }">
			<input type="radio" name="userDegree" id="bs" value="학사">
				<label for="bs">학사 </label>
			<input type="radio" name="userDegree" id="ms" value="석사">
				<label for="ms">석사 </label>
			<input type="radio" name="userDegree" id="phd" value="박사" checked>
				<label for="phd">박사 </label>
			<input type="radio" name="userDegree" id="etc" value="기타">
				<label for="etc">기타 </label>
			</c:if>
			<!-- 기타일 때 -->
			<c:if test="${ requestScope.dashboard.userDegree eq '기타' }">
			<input type="radio" name="userDegree" id="bs" value="학사">
				<label for="bs">학사 </label>
			<input type="radio" name="userDegree" id="ms" value="석사">
				<label for="ms">석사 </label>
			<input type="radio" name="userDegree" id="phd" value="박사">
				<label for="phd">박사 </label>
			<input type="radio" name="userDegree" id="etc" value="기타" checked>
				<label for="etc">기타 </label>
			</c:if>
			<br>
		</div>
		<div style="margin-bottom: 10px;">
			졸업 여부: <br>
			<!-- null일 때 -->
			<c:if test="${ empty requestScope.dashboard.userGraduate }">
			<input type="radio" name="userGraduate" id="grad" value="졸업">
				<label for="grad">졸업 </label>
			<input type="radio" name="userGraduate" id="curr" value="재학">
				<label for="curr">재학 </label>
			<input type="radio" name="userGraduate" id="loa" value="휴학">
				<label for="loa">휴학 </label>
			<input type="radio" name="userGraduate" id="none" value="기타">
				<label for="none">기타 </label>
			</c:if>
			<!-- 졸업일 때 -->
			<c:if test="${ requestScope.dashboard.userGraduate eq '졸업' }">
			<input type="radio" name="userGraduate" id="grad" value="졸업" checked>
				<label for="grad">졸업 </label>
			<input type="radio" name="userGraduate" id="curr" value="재학">
				<label for="curr">재학 </label>
			<input type="radio" name="userGraduate" id="loa" value="휴학">
				<label for="loa">휴학 </label>
			<input type="radio" name="userGraduate" id="none" value="기타">
				<label for="none">기타 </label>
			</c:if>
			<!-- 재학일 때 -->
			<c:if test="${ requestScope.dashboard.userGraduate eq '재학' }">
			<input type="radio" name="userGraduate" id="grad" value="졸업">
				<label for="grad">졸업 </label>
			<input type="radio" name="userGraduate" id="curr" value="재학" checked>
				<label for="curr">재학 </label>
			<input type="radio" name="userGraduate" id="loa" value="휴학">
				<label for="loa">휴학 </label>
			<input type="radio" name="userGraduate" id="none" value="기타">
				<label for="none">기타 </label>
			</c:if>
			<!-- 휴학일 때 -->
			<c:if test="${ requestScope.dashboard.userGraduate eq '휴학' }">
			<input type="radio" name="userGraduate" id="grad" value="졸업">
				<label for="grad">졸업 </label>
			<input type="radio" name="userGraduate" id="curr" value="재학">
				<label for="curr">재학 </label>
			<input type="radio" name="userGraduate" id="loa" value="휴학" checked>
				<label for="loa">휴학 </label>
			<input type="radio" name="userGraduate" id="none" value="기타">
				<label for="none">기타 </label>
			</c:if>
			<!-- 기타일 때 -->
			<c:if test="${ requestScope.dashboard.userGraduate eq '기타' }">
			<input type="radio" name="userGraduate" id="grad" value="졸업">
				<label for="grad">졸업 </label>
			<input type="radio" name="userGraduate" id="curr" value="재학">
				<label for="curr">재학 </label>
			<input type="radio" name="userGraduate" id="loa" value="휴학">
				<label for="loa">휴학 </label>
			<input type="radio" name="userGraduate" id="none" value="기타" checked>
				<label for="none">기타 </label>
			</c:if>
			<br>
		</div>
		<div style="margin-bottom: 10px;">
			학점: 
			<input type="number" name="userPoint" min="0" max="9.99" step=".01" value="${ requestScope.dashboard.userPoint }">
			<br>
		</div>
		<div class="buttons">
			<button type="submit">수정하기</button>	<!-- Submit button using the button element -->
			<button type="reset">수정취소</button>	<!-- Reset all input to default values -->
		</div>
	</div>
</form>


<!-- footer 표시 -->
<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>