<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style>
.clearfix::after {
	content: "";
	display: table;
	clear: both;
}

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
    position: fixed;
    top: 100px; /* Adjust this value to position it vertically */
    left: 50px; /* Adjust this value to position it horizontally */
    z-index: 1000; /* Ensures it stays above other content */
}

.main {
	margin: auto;
	padding: 30px;
	width: 800px;
	background: #303030;
	border-radius: 10px;
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

.progress-bar {
	background: darkgray;
	width: 100%;
	height: 20px;
	border-radius: 10px;
	overflow: hidden;
	margin-top: 10px;
}

.progress {
	background: #00f7d7;
	height: 100%;
	line-height: 20px;
	text-align: center;
	color: black;
}

#certSection {
	margin-top: 20px;
}

#certToggle {
	cursor: pointer;
	color: #fff;
	display: inline-block;
	margin-bottom: 10px;
}

#certCards {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	margin-top: 10px;
}

.certCard {
	background: #404040;
	border-radius: 10px;
	padding: 20px;
	width: 300px;
}

.certCard table {
	width: 100%;
	border-collapse: collapse;
	font-size: 12px;
	margin-bottom: 15px;
}

.certCard table td {
	padding: 5px 0;
	border-bottom: 1px solid #555;
}

.certCard a {
	color: #00f7d7;
	text-decoration: underline;
}
</style>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		$.ajax({
			url: 'userSpecView.do',
			method: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(data) {
				$('#university').append(data.userUniversity || ' 대학정보를 기입해주세요');
				$('#degree').append(data.userDegree || ' 학위정보를 기입해주세요');
				$('#graduation').append(data.userGraduate || ' 졸업정보를 기입해주세요');
				$('#gpa').append(data.userPoint || ' 학점을 기입해주세요');
			}
		});

		$.ajax({
			url: 'userJobView.do',
			method: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(data) {
				data.forEach(function(item) {
					/* TODO: 이 부분 수정 */
					$('<button>')
						.text(item.jobName)
						.on('click', function() {
							$('#targetJob').empty();
							$('#targetJob').html('목표 직무: ' + item.jobName);
							viewSpecs(item.jobId);
							$('#jobExplain').html(item.jobExplain);
							$('#specExplain').empty();
						})
						.appendTo('#jobs');
				});
				$('<button>').text('목표 직업 추가하기').on('click', addJob).appendTo('#jobs');
				$('<button>').text('목표 직업 탐색하기').on('click', searchJob).appendTo('#jobs');
			}
		});

		$('#certToggle').click(function() {
			$('#certCards').slideToggle(300);
		});
	});

	function viewSpecs(jobId) {
		$.ajax({
			url: 'userSpecsView.do',
			method: 'POST',
			data: { jobId: jobId },
			dataType: 'json',
			success: function(data) {
				
				$.each(data, function(index, item) {
					$('#certCards').html($('#certCards').html() + '<div class=\"certCard\"><h3>' + item.specName + '</h3><h5>' + item.specType + '</h5><div style=\"font-size: 13px; margin-bottom: 15px;\">' + item.specExplain + '</div></div>');
					$.ajax({
						url: 'userSpecStuff.do',
						method: 'POST',
						data: { jobId: jobId, specId: item.specId },
						dataType: 'json',
						success: function(data) {
							
						}
					});
				});
			}
		});
	}

	function addJob() {
		location.href = 'addJob.do';
	}

	function searchJob() {
		location.href = 'searchJob.do';
	}

	function addSpec() {
		location.href = 'addSpec.do';
	}

	function searchSpec() {
		location.href = 'searchSpec.do';
	}

	function movetoUpDash() {
		location.href = 'upDash.do';
	}
</script>
</head>

<body>
	<c:if test="${ empty sessionScope.loginUser }">
		<jsp:forward page="/WEB-INF/views/user/login.jsp" />
	</c:if>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />

	<h1 style="text-align: center; margin-top: 20px;">내 스펙 대시보드</h1>

	<div class="dashboard-wrapper clearfix">
		<div class="education-info">
			<h2>학력 정보</h2>
			<label id="university">대학교: </label><br> <label id="degree">학위:
			</label><br> <label id="graduation">졸업 여부: </label><br> <label
				id="gpa">학점: </label><br>
			<div class="buttons">
				<button onclick="movetoUpDash()">수정하기</button>
			</div>
		</div>

		<div class="main">
			<div class="content">
				<h2 id="targetJob">목표 직무</h2>
				<div id="jobs" class="buttons"></div>
				<div id="jobExplain"></div>

				<h2>목표 스펙 달성도</h2>
				<div class="progress-bar">
					<div class="progress" style="width: 35%">35%</div>
				</div>
				<br>

				<h2>목표 스펙</h2>
				<div id="specs" class="buttons"></div>
				<div id="specExplain"></div>
				
				<h2 id="certToggle">정보처리기사 자격증</h2>
				<div id="certSection">
					

					<div id="certCards" style="display: none;">
						<div class="certCard">
							<h3>정보처리기사</h3>
							<h5>자격증</h5>
							<div style="font-size: 13px; margin-bottom: 15px;">소프트웨어
								개발, 시스템 운영, 데이터베이스 관리 등 IT 분야 전반의 이론·실무 능력을 평가하는 국가기술자격증입니다.</div>
							<table>
								<tr>
									<td>2025년 5월 11일</td>
									<td>필기시험</td>
									<td>D-27</td>
								</tr>
								<tr>
									<td>2025년 6월 14일</td>
									<td>실기시험</td>
									<td>D-50</td>
								</tr>
								<tr>
									<td>2025년 6월 24일</td>
									<td>구술 면접</td>
									<td>D-60</td>
								</tr>
							</table>
							<div style="font-size: 12px;">
								<div>
									<input type="checkbox" checked> <a href="#">신나공
										정보처리기사 기출문제집</a>
								</div>
								<div style="margin-top: 8px;">
									<input type="checkbox"> <a href="#">코세라 YY 강의 시청</a>
								</div>
							</div>
							<button class="button"
								style="margin-top: 15px; width: 100%; background: #00f7d7; color: #000; border: none; padding: 8px 0; border-radius: 5px;">
								스펙 달성</button>
						</div>

						<!-- 카드 복제 -->
						<div class="certCard">
							<div style="font-size: 13px; margin-bottom: 15px;">소프트웨어
								개발, 시스템 운영, 데이터베이스 관리 등 IT 분야 전반의 이론·실무 능력을 평가하는 국가기술자격증입니다.</div>
							<table>
								<tr>
									<td>2025년 5월 11일</td>
									<td>필기시험</td>
									<td>D-27</td>
								</tr>
								<tr>
									<td>2025년 6월 14일</td>
									<td>실기시험</td>
									<td>D-50</td>
								</tr>
								<tr>
									<td>2025년 6월 24일</td>
									<td>구술 면접</td>
									<td>D-60</td>
								</tr>
							</table>
							<div style="font-size: 12px;">
								<div>
									<input type="checkbox" checked> <a href="#">신나공
										정보처리기사 기출문제집</a>
								</div>
								<div style="margin-top: 8px;">
									<input type="checkbox"> <a href="#">코세라 YY 강의 시청</a>
								</div>
							</div>
							<button class="button"
								style="margin-top: 15px; width: 100%; background: #00f7d7; color: #000; border: none; padding: 8px 0; border-radius: 5px;">
								스펙 달성</button>
						</div>
						<div class="certCard">
							<div style="font-size: 13px; margin-bottom: 15px;">소프트웨어
								개발, 시스템 운영, 데이터베이스 관리 등 IT 분야 전반의 이론·실무 능력을 평가하는 국가기술자격증입니다.</div>
							<table>
								<tr>
									<td>2025년 5월 11일</td>
									<td>필기시험</td>
									<td>D-27</td>
								</tr>
								<tr>
									<td>2025년 6월 14일</td>
									<td>실기시험</td>
									<td>D-50</td>
								</tr>
								<tr>
									<td>2025년 6월 24일</td>
									<td>구술 면접</td>
									<td>D-60</td>
								</tr>
							</table>
							<div style="font-size: 12px;">
								<div>
									<input type="checkbox" checked> <a href="#">신나공
										정보처리기사 기출문제집</a>
								</div>
								<div style="margin-top: 8px;">
									<input type="checkbox"> <a href="#">코세라 YY 강의 시청</a>
								</div>
							</div>
							<button class="button"
								style="margin-top: 15px; width: 100%; background: #00f7d7; color: #000; border: none; padding: 8px 0; border-radius: 5px;">
								스펙 달성</button>
						</div>
					</div>
				</div>

			</div>
		</div>

	</div>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>