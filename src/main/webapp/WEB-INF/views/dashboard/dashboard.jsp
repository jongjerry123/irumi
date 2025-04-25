<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

.education-info {
	padding: 20px;
	background: #303030;
	border-radius: 10px;
	width: 300px;
	margin-left: 50px;
	margin-top: 100px;
	color: white;
	float:left;
}

.menu {
    list-style: none;
    padding: 0;
}

.menu li {
    margin: 20px 0;
    color: #888;
    cursor: pointer;
}

.menu li.active {
    color: #00f7d7;
}

.main {
    margin: auto;
    padding: 30px;
    width: 800px;
    background: #303030;
	border-radius: 10px;
}

.header {
    position: relative;
    margin-bottom: 30px;
}

.title {
    font-size: 18px;
    display: inline-block;
}

.content h2 {
    margin-top: 30px;
}

.job-tags {
    margin: 15px 0;
}

.job-tags button {
    background: none;
    border: 1px solid #00f7d7;
    color: #00f7d7;
    padding: 5px 10px;
    margin-right: 10px;
    cursor: pointer;
    border-radius: 5px;
}

.progress-bar {
    background-color: darkgray;
    width: 100%;
    height: 20px;
    border-radius: 10px;
    overflow: hidden;
    margin-top: 10px;
}

.progress {
    background-color: #00f7d7;
    height: 100%;
    line-height: 20px;
    text-align: center;
    color: black;
}

.buttons {
	margin-left: auto;
	display: flex;
	gap: 10px;
}

.buttons button {
	background-color: transparent;
	color: white;
	border: 1px solid #ccc;
	padding: 6px 12px;
	border-radius: 5px;
	font-size: 14px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.buttons button:hover {
	background-color: #fff;
	color: #000;
}

.buttons button.active {
	background-color: #00f7d7;   /* 강조 배경색 :contentReference[oaicite:0]{index=0} */
	color: #000;                  /* 강조 글자색 :contentReference[oaicite:1]{index=1} */
	border-color: #00f7d7;        /* 테두리도 강조색과 맞춤 :contentReference[oaicite:2]{index=2} */
}

</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
<script>
function movetoUpDash() {
	location.href = 'upDash.do';
}
function viewSpecs(jobId) {
	$.ajax({
		url: 'userSpecsView.do',
		method: 'POST',
		data: { 'jobId': jobId },
		dataType: 'json',
		success: function(data) {
			
			// 결과를 저장할 변수
			var output = '';
			$.each(data, function(index, item) {
				output += '<button>' + item.specName + '</button>';
			});
			
			output += '<button onclick="addSpec()">목표 스펙 추가하기</button>';
			output += '<button onclick="searchSpec()">목표 스펙 탐색하기</button>';
			$('#specs').html(output);
		},
		error: function(xhr, status, error) {
			console.error("에러 발생:", error);
		}
	});
}

function addJob() {
	location.href = 'addJob.do';
}

function searchJob() {
	location.href = 'searchJob.do';
}

// 학력정보를 표시함
$(function() {
	$.ajax({
		url: "userSpecView.do",
		method: "POST",
		dataType: "json",
		contentType: 'application/json; charset:UTF-8',
		success: function(data) {
			console.log("Dashboard: " + data);
			if (data.userUniversity == null) {
				$('#university').html($('#university').html() + ' 대학정보를 기입해주세요');
			}
			else {
				$('#university').html($('#university').html() + ' ' + data.userUniversity);
			}
			if (data.userDegree == null) {
				$('#degree').html($('#degree').html() + ' 학위정보를 기입해주세요');
			}
			else {
				$('#degree').html($('#degree').html() + ' ' + data.userDegree);
			}
			if (data.userGraduate == null) {
				$('#graduation').html($('#graduation').html() + ' 졸업정보를 기입해주세요');
			}
			else {
				$('#graduation').html($('#graduation').html() + ' ' + data.userGraduate);
			}
			if (data.userPoint == null) {
				$('#gpa').html($('#gpa').html() + ' 학점을 기입해주세요');
			}
			else {
				$('#gpa').html($('#gpa').html() + ' ' + data.userPoint);
			}
			
		},
		error: function(xhr, status, error) {
			console.error("에러 발생:", error);
		}
	});
	
	$.ajax({
		url: 'userJobView.do',
		method: 'POST',
		dataType: 'json',
		contentType: 'application/json; charset:UTF-8',
		success: function(data) {
			$.each(data, function(index, item) {
				$('#jobs').html($('#jobs').html() + '<button onclick="viewSpecs(\'' + item.jobId + '\')">' + item.jobName + '</button>');
			});
			$('#jobs').html($('#jobs').html() + '<button onclick="addJob()">목표 직업 추가하기</button>');
			$('#jobs').html($('#jobs').html() + '<button onclick="searchJob()">목표 직업 탐색하기</button>');
			
		},
		error: function(xhr, status, error) {
			console.error("에러 발생:", error);
		}
	});
	
	// 버튼에 active 클래스로 색깔 처리하기
	$('.buttons').each(function(){
		var $grp = $(this);
		$grp.on('click', 'button', function(){
			$grp.find('button').removeClass('active');
			$(this).addClass('active');
		});
	});
	
});
</script>

</head>
<body>

<!-- TODO: 로그인 상태가 아닌 경우 로그인 페이지로 이동 -->
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if>

<!-- footer에 페이지를 제대로 표시하기 위해 menu를 request scope에서 dashboard로 설정함 -->
<c:set var="menu" value="dashboard" scope="request" />

<!-- header 표시 -->
<c:import url="/WEB-INF/views/common/header.jsp" />
<br>

<!-- 대시보드 제목 -->
<h1 style="text-align: center;">내 스펙 대시보드</h1>

<!-- 학력 정보 표시를 위한 칸 -->
<div class="education-info">
	<h2>학력 정보</h2>
	<div style="margin-bottom: 10px;">
		<label id="university">대학교: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="degree">학위: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="graduation">졸업 여부: </label><br>
	</div>
	<div style="margin-bottom: 10px;">
		<label id="gpa">학점: </label><br>
	</div>
	<div class="buttons">
		<button onclick="movetoUpDash()">수정하기</button>
	</div>
</div>

<!-- 직무, 스펙, 확동 표시 -->
<div class="main">
	<div class="content">
		<h2>목표 직무</h2>
		<div id="jobs" class="buttons"><!-- 여기에 직무 버튼이 생성됨 --></div>
		<div id="jobExplain"><!-- 여기에 직무에 관한 설명이 추가됨 --></div>
		<h2>목표 스펙 달성도</h2>
		<div class="progress-bar">
			<div class="progress" style="width: 35%">35%</div>
		</div>
		<br>
		<h2>목표 스펙</h2>
		<div id="specs" class="buttons"><!-- 여기에 스펙 버튼이 생성됨 --></div>
	</div>
</div>

<!-- footer 표시 -->
<c:import url="/WEB-INF/views/common/footer.jsp" />

</body>
</html>