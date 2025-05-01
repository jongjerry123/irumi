<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스펙 수정</title>
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

input[type="radio"] {
	appearance: none;
	position: absolute;
	opacity: 0;
	width: 0;
	height: 0;
}

label {
	display: inline-block;
	position: relative;
	padding: 0.5em 1em;
	margin-right: 0.5em;
	cursor: pointer;
	color: #fff;
	transition: color 0.3s;
}

label::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: 0;
	width: 100%;
	height: 2px;
	background: #009688;
	transform: scaleX(0);
	transform-origin: left;
	transition: transform 0.3s;
}

label:hover {
	color: #009688;
}

label:hover::after {
	transform: scaleX(1);
}

input[type="radio"]:checked+label {
	color: #fff;
	background: #009688;
	border-radius: 4px;
}

input[type="radio"]:checked+label::before {
	content: "";
	position: absolute;
	left: 50%;
	top: 50%;
	width: 0;
	height: 0;
	background: rgba(0, 150, 136, 0.4);
	border-radius: 50%;
	transform: translate(-50%, -50%);
	animation: ripple 0.6s ease-out;
}

@
keyframes ripple {to { width:200%;
	height: 200%;
	opacity: 0;
}
}
</style>
<script
	src="${pageContext.servletContext.contextPath}/resources/js/jquery-3.7.1.min.js"></script>
<script>
	function addSchedule() {

		let allFilled = true;
		$('.ssType, .ssDate').each(function() {
			if ($(this).val().trim() === '') {
				allFilled = false;
				return false;
			}
		});

		if (allFilled) {
			$('#scheduleRow')
					.append(
							'<div class=\"schedule-set\">'
									+ '일정 유형: <input type=\"text\" name=\"ssType\" class=\"ssType\" required>&nbsp;'
									+ '날짜: <input type=\"date\" name=\"ssDate\" class=\"ssDate\" required>&nbsp;'
									+ '<button type=\"button\" onclick=\"removeSchedule(this)\">삭제</button>'
									+ '</div>');
		}
		else {
			alert('일정 칸이 비어있습니다!');
		}
			
	}
	function removeSchedule(btn) {
		$(btn).closest('.schedule-set').remove();
	}
	function addAct() {
		let allFilled = true;
		$('.actContent').each(function() {
			if ($(this).val().trim() === '') {
				allFilled = false;
				return false;
			}
		});
		if (allFilled) {
			$('#actRow').append('<div class=\"act-set\">'
									+ '<input type=\"text\" name=\"actContent\" class=\"actContent\" required>&nbsp;'
									+ '<button type=\"button\" onclick=\"removeAct(this)">삭제</button>'
									+ '</div>');
		}
		else {
			alert('활동 칸이 비어있습니다!');
		}
			
	}
	function removeAct(btn) {
		$(btn).closest('.act-set').remove();
	}
	function checkSchedule(event) {
		if ((!$('.ssType').val() && $('.ssDate').val()) || ($('.ssType').val() && !$('.ssDate').val())) {
			alert("주요 일정에 입력란 모두 채워져야 합니다.");
			event.preventDefault();
		}
	}
</script>
</head>
<body>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />

	<h1 align="center">${ requestScope.job.jobName }의 스펙 수정</h1>
	<form action="deleteAndInsertSpec.do" method="post">
		<input type="hidden" name="jobId" value="${ requestScope.job.jobId }" />
		<input type="hidden" name="specId" value="${ requestScope.spec.specId }" />
		<table align="center" width="1000" border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>목표 스펙*</th>
				<td><input type="text" name="specName" value="${ requestScope.spec.specName }" required></td>
			</tr>
			<tr>
				<th>스펙 종류*</th>
				<td><c:forEach var="type" items="${ ['어학 능력','자격증','인턴십 및 현장실습','대외 활동','연구 활동','기타'] }">
						<input type="radio" name="specType" id="${ type }" value="${ type }" <c:if test="${ requestScope.spec.specType == type }">checked</c:if> required>
							<label for="${ type }">${ type }</label>
					</c:forEach></td>
			</tr>
			<tr>
				<th>스펙 내용</th>
				<td><textarea name="specExplain" rows="4" cols="50">${ requestScope.spec.specExplain }</textarea></td>
			</tr>
			<tr>
				<th>주요 일정</th>
				<td id="scheduleRow">
					<c:forEach var="ss" items="${ requestScope.ss }">
						<div class="schedule-set">
							일정 유형: <input type="text" name="ssType" class="ssType" value="${ ss.ssType }">&nbsp; 날짜: <input type="date" name="ssDate" class="ssDate" value="<fmt:formatDate value='${ss.ssDate}' pattern='yyyy-MM-dd'/>">&nbsp;<button type="button" onclick="removeSchedule(this)">삭제</button>
						</div>
					</c:forEach>
					일정: <input type="text" name="ssType" class="ssType">&nbsp;날짜: <input type="date" name="ssDate" class="ssDate">&nbsp;<button type="button" onclick="addSchedule()">일정 더 추가하기</button>
			</tr>
			<tr>
				<th>목표 활동</th>
				<td id="actRow">
					<c:forEach var="act" items="${ requestScope.acts }">
						<div class="act-set">
							<input type="text" name="actContent" class="actContent" value="${ act.actContent }" required>&nbsp;
							<button type="button" onclick="removeAct(this)">삭제</button>
						</div>
					</c:forEach>
					<input type="text" name="actContent" class="actContent">&nbsp;<button type="button" onclick="addAct()">활동 더 추가하기</button>
				</td>
			</tr>
		</table>
		<div class="buttons">
			<button type="submit" onclick="checkSchedule(event)">수정하기</button>
		</div>
	</form>
	<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
