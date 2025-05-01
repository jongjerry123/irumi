<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>chatbot 직무 찾기</title>

<!--  sidebar: 뷰 페이지 이동용 스크립트 -->
<script>

function moveJobPage() {
	   location.href = 'viewJobRecChat.do';
	}

	function moveSpecPage() {
	   location.href = 'viewSpecRecChat.do';
	}

	function moveSchedulePage() {
	   location.href = 'viewScheduleRecChat.do';
	}

	function moveActPage() {
	   location.href = 'viewActRecChat.do';
	}
</script>

<!--  메세지 전송 이벤트용 스크립트 -->
<script>
$(function() {
		// ➤ 사용자 입력 메시지 서버로 전송 함수
	  function sendMessage(message) {
	    addMessageToChat(message, "user-msg"); // 사용자 메시지 표시

	    $.ajax({
	      type: "POST",
	      url: "/irumi/sendMessageToChatbot.do",
	      contentType: "application/json",
	      data: JSON.stringify({ userMsg: message,  topic: "job"  }),
	      success: function(gptReply) {
	        addMessageToChat(gptReply.gptAnswer, "bot-msg"); // 챗봇 응답 표시

	        // 답장 안에 checkboxOptions가 있으면 → renderCheckboxList() 실행
	        if (gptReply.checkboxOptions && Array.isArray(gptReply.checkboxOptions) && gptReply.checkboxOptions.length > 0) {
	          renderCheckboxList(gptReply.checkboxOptions);
	        } else {
	          removeCheckboxList();
	        }

	        //답장 안에 options가 있으면 → renderOptionButtons() 실행
	        if (gptReply.options && Array.isArray(gptReply.options) && gptReply.options.length > 0) {
	          renderOptionButtons(gptReply.options);
	        } else {
	          removeOptionButtons();
	        }

	        scrollToBottom(); // 스크롤 맨 아래로
	      },
	      error: function() {
	        addMessageToChat("서버 오류 또는 JSON 파싱 실패!", "bot-msg");
	      }
	    });
	  }
	
	//SideBar
	// 복수선택 옵션에서 직무 선택완료 했을 때 실행======================
	  // ➤ 선택한 직무 리스트를 화면에 출력 가능한 카드로 만드는 함수
	  function addToJobList(checkedJobCIs) {
	    const $jobList = $(".saved-job-list");
	    $.each(checkedJobCIs, function(_, jobCI) {
	      const $card = $("<div>").addClass("citem-card");

	      // ✕ 삭제 버튼
	      const $removeBtn = $("<button>").addClass("remove-btn").text("✕").on("click", function() {
	        $card.remove(); // 클릭 시 카드 삭제
	      });

	      // 직무명 텍스트만 표시
	      const $span = $("<span>").text(jobCI.title);

	      $card.append($removeBtn).append($span);
	      $jobList.append($card);
	    });
	  }//선택한 직무 리스트를 화면에 출력 가능한 카드로 만드는 함수
	  
	  
	   // 복수 선택 옵션 버튼 제공 관련 =================================
	  function renderCheckboxList(options) {
	    removeCheckboxList(); // 기존 체크박스 목록 제거

	    const $chatArea = $("#chatArea");
	    const $listWrap = $("<div>").addClass("custom-checkbox-list").attr("id", "checkbox-list");

	    //options에는 jobCI 객체가 들어있음(컨트롤러 수정필요)
	    $.each(options, function(_, jobCI) {
	      const $label = $("<label>").addClass("custom-checkbox");
	      const $input = $("<input>").attr({ type: "checkbox", value: jobCI.title });
	      const $optTitleSpan = $("<span>").addClass("checkbox-title").text(jobCI.title);
	      const $optExplainSpan = $("<span>").addClass("checkbox-explain").text(jobCI.explain);
	      const $checkMark = $("<span>").addClass("checkmark").html("&#10003;");

	      $label.append($input, $optTitleSpan,  $optExplainSpan, $checkMark);
	      $listWrap.append($label);
	    });

	    // ➤ "선택 완료" 버튼 추가
	    const $submitBtn = $("<button>").text("선택 완료").css("margin-left", "10px").on("click", function() {
	    	const checked = $listWrap.find("input:checked").map(function() {
	    	  const chosenJobTitle = this.value;
	     	  return options.find(jobCI => jobCI.title === chosenJobTitle); // job 자체를 반환
	      }).get();
	      if (checked.length === 0) {
	        alert("하나 이상 선택해 주세요!");
	        return;
	      }
	      addToJobList(checked);
	      removeCheckboxList();
	      
	   // jobCI 선택시, insertJob으로 Career Item 형태로 보냄   
	   // ==> chatbot Controller로 보내서 먼저 Job 형태로 변환
	   // 그 후 dashboard로 보내야 함
	   // Job, Career Plan table에 모두 저장되도록 처리해야 함
	      checked.forEach(function(jobCI) {
	    	  $.ajax({
	    	    type: "POST",
	    	    url: "insertCareerItem.do",
	    	    contentType: "application/json",
	    	    data: JSON.stringify(jobCI),
	    	    success: function() {
	    	      console.log("직무 저장 성공:", jobCI.title);
	    	    },
	    	    error: function() {
	    	      console.error("직무 저장 실패:", jobCI.title);
	    	    }
	    	  });
	    	});
	   
	   
	    });

	    $listWrap.append($submitBtn);
	    $chatArea.append($listWrap);
	  }	//체크박스 리스트 렌더링 함수

	// 택1 옵션 버튼 제공 관련 ===============================
	  function renderOptionButtons(options) {
	    removeOptionButtons(); // 기존 옵션 버튼 제거

	    const $chatArea = $("#chatArea");
	    const $btnWrap = $("<div>").attr("id", "option-buttons").css({
	      marginTop: "15px",
	      display: "flex",
	      gap: "10px"
	    });

	    // 넘어온 옵션들에 대해, 클릭시 select-btn으로 설정해 메세지처럼 보냄.
	    $.each(options, function(_, option) {
	      const $btn = $("<button>").addClass("select-btn").text(option).on("click", function() {
	        sendMessage(option); // 버튼 클릭하면 전송
	      });
	      $btnWrap.append($btn);
	    });

	    $chatArea.append($btnWrap);
	  }


	  // ➤ 유저 직접 입력 후 엔터키 입력 시 sendMessage()
	  $("#userInput").on("keyup", function(event) {
	    if (event.key === "Enter") {
	      const val = $(this).val().trim();
	      if (val) {
	        sendMessage(val);
	        $(this).val("");
	      }
	    }
	  });

	  // ➤ 유저 직접 입력 후 전송 버튼 클릭 시 sendMessage()
	  $(".chat-send-btn").on("click", function() {
	    const $input = $("#userInput");
	    const val = $input.val().trim();
	    if (val) {
	      sendMessage(val);
	      $input.val("");
	    }
	  });

	  // ➤ 사이드바에서 수동 입력으로 직무 추가
	  $(".add-btn").on("click", function() {
	    const $input = $(".manual-input");
	    const val = $input.val().trim();
	    if (val) {
	      addToJobList([val]);
	      
	      // DB에 저장    ----------- 변경사항
	      $.ajax({
	        type: "POST",
	        url: "insertJob.do",
	        data: { jobName: val },
	        success: function() {
	          console.log("직무 추가 성공");
	        },
	        error: function() {
	          alert("직무 추가 실패!");
	        }
	      });
	      
	      
	      $input.val("");
	    } else {
	      alert("직무를 입력해 주세요!");
	    }
	  });
	  
	//기타 ------------------------------------------------
	
	 // 채팅창에 메시지 말풍선 추가 함수
	  function addMessageToChat(message, cls) {
	    const $chatArea = $("#chatArea");
	    const $div = $("<div>").addClass("message " + cls).text(message);
	    $chatArea.append($div);
	  }
	
	// 체크박스 리스트 제거 함수
	  function removeCheckboxList() {
	    $("#checkbox-list").remove();
	  }

	  // 옵션 버튼 리스트 제거 함수
	  function removeOptionButtons() {
	    $("#option-buttons").remove();
	  }
	  
	// 채팅창 스크롤 자동 내려주는 함수
	  function scrollToBottom() {
	    const $chatArea = $("#chatArea");
	    $chatArea.parent().scrollTop($chatArea.parent()[0].scrollHeight);
	  }

});

</script>
<style>
body {
	background-color: #111;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
	margin: 0;
	padding: 0;
	min-height: 70vh;
}

.container {
	display: flex;
	min-height: calc(100vh - 72px); /* 전체화면에서 header 빼기 */
	margin-top: 20px; /* header 높이만큼 아래로 */
}

.sidebar, .right-panel {
	height: auto; /* 높이 자동 (100vh 등 절대값 X) */
}

.sidebar {
	width: 200px;
	background-color: #141414;
	padding: 30px 20px;
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.sidebar button {
	background-color: #222;
	border: none;
	color: white;
	text-align: left;
	padding: 10px 20px;
	cursor: pointer;
	border-radius: 8px;
	transition: background 0.3s;
	text-align: center;
	font-weight: bold;
}

.sidebar button:hover {
	background-color: #BAAC80;
	color: black;
}

.main {
	flex: 1;
	padding-right: 40px;
	padding-left: 40px;
	display: flex;
	flex-direction: column;
}

.content-box {
	background-color: #1e1e1e;
	padding-right: 20px;
	padding-left: 20px;
	border-radius: 12px;
	line-height: 1.7;
	font-size: 14px;
	margin-bottom: 30px;
	height: 700px;
	overflow-y: auto; /* 내부 콘텐츠가 넘칠 경우 스크롤 활성화 */
	display: flex;
	flex-direction: column;
}

.content-box::-webkit-scrollbar {
	width: 9px;
	background: #222;
}

.content-box::-webkit-scrollbar-thumb {
	background: #BAAC80;
	border-radius: 6px;
}

.content-box {
	scrollbar-color: #BAAC80 #222;
	scrollbar-width: thin;
}

.right-panel {
	width: 230px;
	padding-right: 20px;
	padding-left: 20px;
	display: flex;
	flex-direction: column;
	gap: 30px;
}

.right-panel .spec-value {
	color: #fff;
	font-size: 9px;
	margin-left: 4px;
}

.right-panel .citem-value {
	color: #fff;
	font-size: 9px;
	margin-left: 4px;
}

.chat-input-box .chat-send-btn:hover {
	background: #BAAC80;
}

.chat-input-box {
	display: flex;
	align-items: center;
	background: #222;
	border-radius: 24px;
	padding: 8px 16px;
	margin-top: 40px;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.07);
}

.chat-input-box .chat-input {
	flex: 1;
	background: transparent;
	border: none;
	color: white;
	font-size: 15px;
	padding: 8px;
	outline: none;
}

.chat-input-box .chat-send-btn {
	width: 36px;
	height: 36px;
	border: none;
	border-radius: 50%;
	background: #D9D9D9;
	color: #232323;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-left: 10px;
	font-size: 18px;
	cursor: pointer;
	transition: background 0.2s;
}

.chat-input-box .chat-send-btn:hover {
	background: #BAAC80;
}

.manual-input-box {
	display: flex;
	align-items: center;
	background: #232323;
	border-radius: 8px;
	padding: 6px 10px;
	margin-top: 12px;
	gap: 6px;
}

.manual-input-box .manual-input {
	flex: 1;
	background: transparent;
	border: none;
	color: #facc15;
	font-size: 14px;
	padding: 8px 4px;
	outline: none;
}

.manual-input-box .add-btn {
	background: #232323;
	border: 1px solid #BAAC80;
	color: #BAAC80;
	border-radius: 6px;
	width: 28px;
	height: 28px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	font-size: 18px;
	margin-left: 4px;
}

.manual-input-box .add-btn:hover {
	background: #BAAC80;
	color: #232323;
}

.content-box .custom-checkbox-list {
	margin: 24px 0 0 0;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.content-box .custom-checkbox {
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #181818;
	border: 1.5px solid #fff;
	border-radius: 10px;
	padding: 10px 18px;
	font-size: 16px;
	color: #facc15;
	position: relative;
	cursor: pointer;
	transition: border 0.2s, background 0.2s;
	min-width: 210px;
	max-width: 340px;
}

.content-box .custom-checkbox input[type="checkbox"] {
	display: none;
}

.content-box .custom-checkbox .checkbox-title {
	color: #fff;
	font-size: 15px;
	letter-spacing: 0.5px;
}

.content-box .custom-checkbox .checkmark {
	display: none;
	font-size: 18px;
	color: #BAAC80;
	margin-left: 12px;
}
/* checked 상태일 때만 checkmark 보이기 */
.content-box .custom-checkbox input[type="checkbox"]:checked ~
	.checkmark {
	display: block;
}

.content-box .custom-checkbox input[type="checkbox"]:checked ~
	.checkbox-title {
	color: #BAAC80;
	font-weight: 600;
}

.content-box .custom-checkbox input[type="checkbox"]:checked ~
	.checkmark {
	color: #BAAC80;
}

.content-box .custom-checkbox:hover {
	background: #222;
}

.saved-citem-section {
	margin-bottom: 20px;
}

.section-title {
	color: #BAAC80;
	font-weight: bold;
	font-size: 15px;
	margin: 24px 0 10px 0;
}

.saved-citem-list {
	display: flex;
	flex-direction: column;
	gap: 10px;
	margin-bottom: 14px;
}

.citem-card {
	background: #232323;
	border: 1.5px solid #444;
	border-radius: 7px;
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 8px 14px;
	font-size: 10px;
	color: #fff;
	position: relative;
}

.remove-btn {
	background: none;
	border: none;
	color: #888;
	font-size: 16px;
	margin-right: 2px;
	cursor: pointer;
	transition: color 0.2s;
}

.remove-btn:hover {
	color: #f87171;
}

.add-citem-btn {
	margin-top: 10px;
	width: 100%;
	padding: 9px 0;
	border-radius: 8px;
	border: 1.5px solid #BAAC80;
	background: none;
	color: #BAAC80;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	transition: background 0.2s, color 0.2s;
}

.add-citem-btn span {
	font-size: 18px;
	font-weight: bold;
}

.add-citem-btn:hover {
	background: #BAAC80;
	color: #232323;
}

.select-group {
	display: flex;
	flex-direction: column; /* 세로 정렬 */
	align-items: flex-start; /* 좌측 정렬 */
	gap: 8px;
}

.select-label {
	color: #d9d9d9;
	font-size: 15px;
	font-weight: 600;
	margin-bottom: 2px; /* 라벨 아래 약간 여백 */
}

.select-btn {
	background: none;
	border: 1.5px solid #BAAC80;
	color: #BAAC80;
	border-radius: 22px;
	font-size: 15px;
	font-weight: 500;
	padding: 7px 20px;
	margin-right: 8px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-bottom: 4px; /* 버튼들끼리 간격 */
}

.select-btn-list {
	display: flex;
	flex-direction: row;
	gap: 8px; /* 버튼 사이 간격 */
	flex-wrap: nowrap;
}

.select-btn.active {
	background: #BAAC80;
	color: #232323;
	font-weight: 700;
}

/*************************************************************************** */
.chat-area {
	flex: 1;
	overflow-y: auto;
	background-color: #1e1e1e;
	border-radius: 12px;
	padding: 20px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

#userInput {
	flex: 1;
	background-color: #333;
	color: white;
	border: none;
	padding: 10px;
	border-radius: 5px;
	margin-right: 6px;
	font-size: 15px;
	outline: none;
}

.message {
	max-width: 70%;
	padding: 10px 15px;
	border-radius: 12px;
	line-height: 1.5;
	font-size: 0.95em;
	word-wrap: break-word;
}

.user-msg {
	background-color: #BAAC80;
	color: black;
	align-self: flex-end;
	text-align: right;
	font-weight: bold;
}

.bot-msg {
	align-self: flex-start;
	text-align: left;
}

/* 추가 - 입력창과 버튼 정렬 */
.chat-input-box {
	display: flex;
	align-items: center;
	background: #222;
	border-radius: 12px;
	padding: 8px 16px;
	margin-top: 10px;
}
</style>

<script type="text/javascript">
window.onload = function() {
document.querySelectorAll('.custom-checkbox input[type="checkbox"]').forEach(cb => {
  function updateBorder() {
    if (cb.checked) {
      cb.parentElement.style.border = '1.5px solid #BAAC80'; // 체크 시
    } else {
      cb.parentElement.style.border = '1.5px solid #fff'; // 해제 시
    }
  }
  // 페이지 로드시 초기화
  updateBorder();
  // 체크/해제마다 이벤트
  cb.addEventListener('change', updateBorder);
});
};
</script>
</head>
<body>

	<c:import url="/WEB-INF/views/common/header.jsp" />
	<!-- footer에 페이지를 제대로 표시하기 위해 menu를 request scope에서 chatbot로 설정함 -->
	<c:set var="menu" value="chat" scope="request" />

	<div class="container">

		<!-- Sidebar -->
		<div class="sidebar">
			<button onclick="moveJobPage();">직무 찾기</button>
			<button onclick="moveSpecPage();">스펙 찾기</button>
			<button onclick="moveSchedulePage();">일정 찾기</button>
			<button onclick="moveActPage();">활동 찾기</button>
		</div>

		<!-- Main content -->
		<div class="main">

			<!-- 콘텐츠 영역 -->
			<div class="content-box">
				
   
				<div class="chat-area" id="chatArea">
					<div class="message bot-msg">
						내게 맞는 직무 찾기 세션입니다.<br> 먼저, 희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점,
						가치관 등)을 말해주세요.
					</div>
				</div>

			</div>

			<div class="chat-input-box">
				<input type="text" placeholder="무엇이든 물어보세요" class="chat-input"
					id="userInput" />
				<button class="chat-send-btn" onclick="sendMessage()">
					<i class="fa fa-paper-plane"> > </i>
				</button>
			</div>


		</div>

		<!-- Right panel -->
		<div class="right-panel">
			<div class="saved-job-section">
				<div class="section-title">➤ 저장한 직무</div>
				<div class="saved-job-list">
					<!-- 
					<div class="schedule-card">
						<button class="remove-btn">✕</button>
						<span>프론트엔드 개발자</span>
					</div>
					
					<div class="schedule-card">
						<button class="remove-btn">✕</button>
						<span>백엔드 개발자</span>
					</div>
					 -->
				</div>
				<div class="manual-input-box">
					<input type="text" placeholder="직접 직무 입력" class="manual-input" />
					<button class="add-btn">
						<i class="fa fa-plus"> + </i>
					</button>
				</div>
			</div>
		</div>

		<!-- Footer -->
		<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
