<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

.buttons {
	display: flex;
	gap: 10px;
}

.buttons button {
	background: transparent;
	color: white;
	border: 1px solid #ccc;
	padding: 6px 12px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color .2s;
}

.buttons button:hover {
	background: #fff;
	color: #000;
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
</style>
</head>
<body>
	<c:if test="${ empty sessionScope.loginUser }">
		<jsp:forward page="/WEB-INF/views/user/login.jsp" />
	</c:if>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />
	
	<h1 align="center">목표: ${ requestScope.job.jobName }</h1>
	<h3>${ requestScope.job.jobExplain }</h3>
	<form action="insertSpec.do" method="post">
		<input type="text" name="jobId" value="${ requestScope.job.jobId }" hidden>
		<table align="center" width="1000" border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>목표 스펙*</th>
				<td><input type="text" name="specName" required></td>
			</tr>
			<tr>
				<th>스펙 종류*</th>
				<td>
					<input type="radio" name="specType" id="a" value="어학 능력" required>
						<label for="a">어학 능력 </label>
					<input type="radio" name="specType" id="b" value="자격증" required>
						<label for="b">자격증 </label>
					<input type="radio" name="specType" id="c" value="인턴십 및 현장실습" required>
						<label for="c">인턴십 및 현장실습 </label>
					<input type="radio" name="specType" id="d" value="대외 활동" required>
						<label for="d">대외 활동 </label>
					<input type="radio" name="specType" id="e" value="연구 활동" required>
						<label for="e">연구 활동 </label>
					<input type="radio" name="specType" id="f" value="기타" required>
						<label for="f">기타 </label>
				</td>
			</tr>
			<tr>
				<th>스펙 내용</th>
				<td><textarea name="specExplain" rows="4" cols="50"></textarea></td>
			</tr>
		</table>
		
		<div class="buttons">
			<button type="submit">목표 스펙으로 설정</button>
		</div>
	</form>
	<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>