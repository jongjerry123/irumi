<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
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
    top: 200px; /* Adjust this value to position it vertically */
    left: 300px; /* Adjust this value to position it horizontally */
    z-index: 1000; /* Ensures it stays above other content */
}

.spec-info {
    padding: 20px;
    background: #303030;
    border-radius: 10px;
    width: 300px;
    position: fixed;
    top: 200px; /* Adjust this value to position it vertically */
    right: 300px; /* Adjust this value to position it horizontally */
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

<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>

<script>
	$(document).ready(function() {
		$('#certCards').slideToggle(300);
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
			url: 'userCurrSpecView.do',
			method: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(data) {
				$('#currSpecs').html('<table>');
				data.forEach(function(item) {
					console.log(item.specId);
					$('#currSpecs').append('<tr><td width=\"250px\">' + item.specName + ' </td><td><button style="border-radius: 20px;" onclick=\"deleteSpec(' + item.specId + ')\">×</button></td></tr>');					
				});
				$('#currSpecs').append('</table>');
			}
		});
		
		$.ajax({
			url: 'userJobView.do',
			method: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(data) {
				data.forEach(function(item) {
					/* TODO: 이 부분에 클릭 시 토글 기능이 들어가도록 수정 */
					$('<button>')
						.text(item.jobName)
						.on('click', function() {
							$('#targetJob').empty();
							$('#targetJob').html('목표 직무: ' + item.jobName);
							viewSpecs(item.jobId);
							$('#jobExplain').html(item.jobExplain);
							$('#certCards').slideToggle(300);
							$('#certCards').slideToggle(300);
						})
						.appendTo('#jobs');
				});
				$('<button>').text('목표 직업 추가하기').on('click', addJob).appendTo('#jobs');
				$('<button>').text('목표 직업 탐색하기').on('click', searchJob).appendTo('#jobs');
			}
		});
	});

	function viewSpecs(jobId) {
	    $.ajax({
			url: 'userSpecsView.do',
			method: 'POST',
			data: { jobId: jobId },
			dataType: 'json',
			success: function(data) {
				$('#certCards').empty();
				if (!data || data.length === 0) {
	                $('#certCards').append('<div>등록된 스펙이 없습니다.</div>');
	                var buttonHtml = '<div class="buttons"><button onclick=\"movetoAddSpec(' + jobId + ')\" style=\"width: 340px;\">목표 스펙 추가하기</button></div>';
					$('#certCards').append(buttonHtml);
	                return;
				}
				
				let remaining = data.length;
				
				$.each(data, function(index, item) {
	                var cardHtml = 
	                    '<div class="certCard">' +
	                      '<h3>' + item.specName + '</h3>' +
	                      '<h5>' + item.specType + '</h5>' +
	                      '<div style=\"font-size:13px; margin-bottom:15px;\">' + item.specExplain + '</div>' +
	                      '<table>';

	                $.ajax({
	                    url: 'userSpecStuff.do',
	                    method: 'POST',
	                    data: { jobId: jobId, specId: item.specId },
	                    dataType: 'json',
	                    success: function(json) {
	                    	
	                    	cardHtml += '<h5>주요 일정<h5>';
	                        $.each(json.specSchedules, function(i, sch) {
	                            cardHtml += '<tr><td>' + formatDate(sch.ssDate) + '</td><td>' + sch.ssType + '</td></tr>';
	                        });
	                        cardHtml += '</table><div style=\"font-size:12px;\">';

	                        $.each(json.acts, function(i, act) {
	                            cardHtml +=
	                              '<div style=\"margin-top:12px;\">' +
	                                '<input type="checkbox" checked>' +
	                                '<a href=\"#\">' + act.actContent + '</a>' +
	                              '</div>';
	                        });
							
	                        cardHtml += '</div>' +
	                        			'<div class="buttons">' +
	                        			'<button onclick=\"movetoUpdateSpec(' + jobId + ', ' + item.specId + ')\" style=\"width: 150px;\">변경</button>' +
	                        			'<button onclick=\"deleteSpec(' + item.specId + ')\" style=\"width: 150px;\">삭제</button>' +
	                        			'</div>' +
	                        			'<div class="buttons">' +
	                        			'<button onclick=\"movetoAccomplishSpec(' + item.specId + ')\" style=\"width: 300px;\">스펙 달성</button>' +
	                        			'</div>' +
										'</div>';
	                        $('#certCards').append(cardHtml);
	                        
	                        remaining--;
	                        
	                        if (remaining === 0) {
	                        	var buttonHtml = '<div class="buttons"><button onclick=\"movetoAddSpec(' + jobId + ')\" style=\"width: 340px;\">목표 스펙 추가하기</button></div>';
								$('#certCards').append(buttonHtml);
	                        }
	                    }
	                });
	            });
				
			}
	    });
	}

	function deleteSpec(specId) {
		location.href = 'deleteSpec.do?specId=' + specId;
	}
	
	function movetoUpdateSpec(jobId, specId) {
		location.href = 'updateSpec.do?jobId=' + jobId + '&specId=' + specId;
	}
	
	function movetoAccomplishSpec(specId) {
		location.href = 'updateSpecStatus.do?specId=' + specId;
	}
	
	function movetoAddSpec(jobId) {
		location.href = 'movetoAddSpec.do?jobId=' + jobId;
	}
	
	function addJob() {
		location.href = 'addJob.do?page=1';
	}

	function searchJob() {
		location.href = 'searchJob.do';
	}

	function searchSpec() {
		location.href = 'searchSpec.do';
	}

	function movetoUpDash() {
		location.href = 'upDash.do';
	}

	function formatDate(sqlDate) {
		const date = new Date(sqlDate);
		const yyyy = date.getFullYear();
		const mm = String(date.getMonth() + 1).padStart(2, '0');
		const dd = String(date.getDate()).padStart(2, '0');
		return yyyy + '-' + mm + '-' + dd;
	}
</script>
</head>

<body>
	
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />

	<h1 style="text-align: center; margin-top: 20px;">내 스펙 대시보드</h1>

	<div class="dashboard-wrapper clearfix">
		<div class="education-info">
			<h2>학력 정보</h2>
			<label id="university">대학교: </label>
			<br>
			<label id="degree">학위: </label>
			<br>
			<label id="graduation">졸업 여부: </label>
			<br>
			<label id="gpa">학점: </label>
			<br>
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
				<div id="certSection">
					<div id="certCards" style="display: none;">
						<h1>직업을 선택하세요</h1>
					</div>
				</div>

			</div>
		</div>
		
		<div class="spec-info">
			<h2>현재 스펙</h2>
			<label id="currSpecs"></label><br>
		</div>
	</div>

	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>