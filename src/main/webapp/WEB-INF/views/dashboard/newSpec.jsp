<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style>
/* 컨테이너 카드 스타일 */
.container {
  max-width: 1000px;
  margin: 40px auto;
  background: #1a1a1a;
  padding: 20px;
  border-radius: 12px;            /* 둥근 모서리 */
  box-shadow: 0 4px 20px rgba(0,0,0,0.7); /* 그림자 */
}

/* 제목 */
.container h1 {
  color: #00bfae;
  margin-bottom: 20px;
  font-size: 2rem;
  text-align: center;
  text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
}

/* 테이블 래퍼 & 스트라이프 */
.table-wrapper { overflow-x: auto; margin-bottom: 20px; }
table {
  width: 100%;
  border-collapse: collapse;
  background: #222;
  border-radius: 8px;
  overflow: hidden;
}
th, td {
  padding: 12px 15px;
  text-align: left;
}
th {
  background: #009688;
  position: sticky; top: 0;       /* 헤더 고정 */
  color: #fff;
  font-weight: 600;
}

tbody tr:hover { background: #2a2a2a; }

/* 버튼 공통 */
.btn {
  background: #009688;
  color: #fff;
  border: none;
  padding: 8px 16px;
  margin: 5px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background 0.2s, transform 0.1s;
}
.btn:hover {
  background: #00bfae;
  transform: translateY(-2px);
}
.btn-danger {
  background: #e64a19;
}
.btn-danger:hover { background: #ff5722; }

/* 입력 필드 */
input[type="text"], input[type="date"], textarea {
  width: calc(100% - 200px);
  padding: 8px 10px;
  margin: 4px 0;
  background: #333;
  color: #eee;
  border: 1px solid #444;
  border-radius: 4px;
  font-size: 0.9rem;
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

@keyframes ripple {to { width:200%;
	height: 200%;
	opacity: 0;
	}
}

/* 일정·활동 블록 */
.schedule-set, .act-set {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}
</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
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
							'<div class="schedule-set">'
									+ '일정: <input type=\"text\" name=\"ssType\" class=\"ssType\" style=\"width: 300px;\" required>'
									+ '날짜: <input type=\"date\" name=\"ssDate\" class=\"ssDate\" style=\"width: 100px;\" required>'
									+ '<button type=\"button\" class=\"btn btn-danger\" onclick=\"removeSchedule(this)\">삭제</button>'
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
			$('#actRow').append('<div class="act-set">'
									+ '<input type=\"text\" name=\"actContent\" class=\"actContent\" required>&nbsp;'
									+ '<button type=\"button\" class="btn btn-danger" onclick=\"removeAct(this)\">삭제</button>'
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
		const val = $('#specName').val();
		
		if (val.trim() === '') {
			alert('목표 스펙에 공백이 입력되었습니다.');
			event.preventDefault();
		}
		
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
	<div class="container">
	<h1 align="center">목표: ${ requestScope.job.jobName }</h1>
	<pre style="white-space: pre-wrap; word-wrap: break-word; overflow-wrap: break-word; max-width: 100%; overflow-x: auto; color: lightgray;">
		<h3>${ requestScope.job.jobExplain }</h3>
	</pre>
	<form action="insertSpec.do" method="post">
		<input type="hidden" name="jobId" value="${ requestScope.job.jobId }">
		<table align="center" width="1000" border="1" cellspacing="0" cellpadding="5">
			<tr>
				<th>목표 스펙*</th>
				<td><input type="text" id="specName" name="specName" required></td>
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
			<tr>
				<th>주요 일정</th>
				<td id="scheduleRow">
					<div class="schedule-set">
						일정: <input type="text" name="ssType" class="ssType" style="width: 300px;">
						날짜: <input type="date" name="ssDate" class="ssDate" style="width: 100px;">
						<button type="button" class="btn" onclick="addSchedule()">일정 더 추가하기</button>
					</div>
				</td>
			</tr>
			<tr>
				<th>목표 활동</th>
				<td id="actRow">
					<div class="act-set">
						<input type="text" name="actContent" class="actContent">&nbsp;<button type="button" class="btn" onclick="addAct()">활동 더 추가하기</button>
					</div>
				</td>
			</tr>
		</table>
		
		<div class="buttons" style="padding-top: 25px; text-align:center;">
			<button type="submit" class="btn" style="display: inline-block; margin: 0 auto;" onclick="checkSchedule(event)">목표 스펙으로 설정</button>
		</div>
	</form>
	</div>
	<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>

