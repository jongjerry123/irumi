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
:root {
  --bg: #1a1a1a;
  --surface: #2b2b2b;
  --card-bg: #333;
  --primary: #00f7d7;
  --text: #eee;
  --text-secondary: #ccc;
  --radius: 12px;
  --gap: 16px;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
  background: var(--bg);
  color: var(--text);
  font-family: 'Noto Sans KR', sans-serif;
  line-height: 1.6;
}
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}
.dashboard-wrapper {
  display: grid;
  grid-template-columns: 1fr 2fr 1fr;
  gap: var(--gap);
  padding: var(--gap);
}
.education-info,
.spec-info,
.main {
  background: var(--surface);
  border-radius: var(--radius);
  box-shadow: 0 4px 10px rgba(0,0,0,0.5);
  padding: var(--gap);
}
.education-info, .spec-info {
  position: relative;
}
.main {
  width: 100%;
}
h1, h2, h3 {
  margin-bottom: calc(var(--gap) / 2);
}
h1 { font-size: 1.8rem; }
h2 { font-size: 1.4rem; }
h3 { font-size: 1.2rem; }
label, p {
  color: var(--text-secondary);
  margin-bottom: calc(var(--gap) / 4);
  display: block;
}
.buttons {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-top: var(--gap);
}
.buttons button {
  background: var(--primary);
  border: none;
  color: var(--bg);
  padding: 8px 16px;
  border-radius: var(--radius);
  cursor: pointer;
  transition: background 0.2s, transform 0.1s;
}
.buttons button:hover {
  transform: scale(1.05);
}
input[type="checkbox"] {
  width: 20px;
  height: 20px;
  cursor: pointer;
  accent-color: var(--primary);
  transition: transform 0.1s ease-in-out;
}
input[type="checkbox"]:hover,
input[type="checkbox"]:checked {
  transform: scale(1.2);
}
.progress-bar {
  background: darkgray;
  width: 100%;
  height: 20px;
  border-radius: var(--radius);
  overflow: hidden;
  margin-top: 10px;
}
.progress {
  background: var(--primary);
  height: 100%;
  line-height: 20px;
  text-align: center;
  color: var(--bg);
  transition: width 0.3s;
}
#certCards {
  display: flex;
  flex-wrap: wrap;
  gap: var(--gap);
  margin-top: 10px;
}
.certCard {
  background: var(--card-bg);
  border-radius: var(--radius);
  box-shadow: 0 2px 8px rgba(0,0,0,0.4);
  padding: var(--gap);
  width: 300px;
  transition: transform 0.2s, box-shadow 0.2s;
}
.certCard:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.6);
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
  color: var(--primary);
  text-decoration: underline;
}
@media (max-width: 1024px) {
  .dashboard-wrapper {
    grid-template-columns: 1fr;
  }
  .education-info, .spec-info {
    position: static;
    width: auto;
  }
}
</style>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.7.1.min.js"></script>
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
			url: 'userCurrSpecView.do',
			method: 'POST',
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(data) {
				$('#currSpecs').html('<ul>');
				data.forEach(function(item) {
					$('#currSpecs').append('<li><a href=\"#\" onclick=\"movetoUpdateSpec(' + item.specId + ')\">' + item.specName + '</a></li>');					
				});
				$('#currSpecs').append('</ul>');
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
							$('#certCards').slideToggle(300);
							$('#targetJob').empty();
							$('#targetJob').html('목표 직무: ' + item.jobName + ' &nbsp;<div class="buttons"><button onclick=\"movetoDeleteJob(' + item.jobId + ')\">목표 직무 삭제하기</button></div>');
							viewSpecs(item.jobId);
							$.ajax({
								url: 'updateProgressBar.do',
	                            method: 'POST',
	                            data: { jobId: item.jobId },
	                            dataType: 'json',
	                            success: function(data) {
	                                $('.progress').css('width',  data.progress + '%').text(data.progress + '%');
	                            }
							});
							$('#jobExplain').html(item.jobExplain);
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
	                        cardHtml += '</table><div style=\"font-size: 18px;\">';
	                        cardHtml += '<table><tr><td width="80px">활동 달성</td><td>활동 내용</td></tr>'
							$.each(json.acts, function(i, act) {
								if (act.actState === 'N') {
									cardHtml += '<tr><td><input type=\"checkbox\" id=\"' + act.actId + '\" onclick=\"updateActStatus(' + act.actId + ', \'' + act.actState + '\')\"></td>' +
												'<td><label for=\"' + act.actId + '\">' + act.actContent + '</label></td></tr>';
								}
								else {
									cardHtml += '<tr><td><input type=\"checkbox\" id=\"' + act.actId + '\" onclick=\"updateActStatus(' + act.actId + ', \'' + act.actState + '\')\"  checked></td>' +
												'<td><label for=\"' + act.actId + '\">' + act.actContent + '</label></td></tr>';
								}
							});
							
	                        cardHtml += '</table></div>' +
	                        			'<div class="buttons">' +
	                        			'<button onclick=\"movetoUpdateSpec(' + item.specId + ')\" style=\"width: 150px;\">변경</button>' +
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
	
	function updateActStatus(actId, actState) {
		location.href = 'updateActStatus.do?actId=' + actId + '&actState=' + actState;
	}

	function deleteSpec(specId) {
		location.href = 'deleteSpec.do?specId=' + specId;
	}
	
	function movetoDeleteJob(jobId) {
		location.href = 'deleteJob.do?jobId=' + jobId;
	}
	
	function movetoUpdateSpec(specId) {
		location.href = 'updateSpec.do?specId=' + specId;
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
      <label id="degree">학위: </label>
      <label id="graduation">졸업 여부: </label>
      <label id="gpa">학점: </label>
      <div class="buttons"><button onclick="movetoUpDash()">수정하기</button></div>
    </div>

    <div class="main">
      <h2 id="targetJob">목표 직무</h2>
      <div id="jobs" class="buttons"></div>
      <div id="jobExplain"></div>

      <h2>목표 스펙 달성도</h2>
      <div class="progress-bar"><div class="progress" style="width:0%">0%</div></div>

      <h2>목표 스펙</h2>
      <div id="certSection"><div id="certCards"><h1>직업을 선택하세요</h1></div></div>
    </div>

    <div class="spec-info">
      <h2>현재 스펙</h2>
      <label id="currSpecs"></label>
    </div>
  </div>

  <c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
