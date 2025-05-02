<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<meta charset="UTF-8">
<title>chatbot 일정 찾기</title>
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
<script>
document.addEventListener("DOMContentLoaded", function() {
	
	const CHAT_TOPIC = "ss";
	
	// 오른쪽 저장한 일정 부분 함수들
	function addToActivityList(items) {
	    const actList = document.getElementById("savedActivityList");
	    items.forEach(activity => {
	      const card = document.createElement("div");
	      card.className = "schedule-card";
	      // 삭제 버튼
	      const removeBtn = document.createElement("button");
	      removeBtn.className = "remove-btn";
	      removeBtn.textContent = "✕";
	      removeBtn.onclick = function() {
	        card.remove();
	      };
	      // 텍스트
	      const span = document.createElement("span");
	      span.textContent = activity;
	      card.appendChild(removeBtn);
	      card.appendChild(span);
	      actList.appendChild(card);
	    });
	  }
	
	document.querySelector(".add-btn").addEventListener("click", function() {
		  const dateInput = document.getElementById("manualDate").value.trim();
		  const commentInput = document.getElementById("manualComment").value.trim();
		 
		    // db에 저장용 추가 --------------------------
		    if (dateInput && commentInput) {
		    	  /* const scheduleData = {
		    	    ssDate: dateInput,      
		    	    ssType: commentInput   
		    	  };
		    	  $.ajax({
		    	    type: "POST",
		    	    url: "insertSchedule.do",  //// 완성시 이름 바꾸기
		    	    data: scheduleData, 
		    	    success: function() {
		    	      console.log("일정 저장 성공");
		    	    },
		    	    error: function() {
		    	      alert("일정 저장 실패!");
		    	    }
		    	  }); */
		    	 
		    const combinedText = dateInput + " / " + commentInput;	 
		    addToActivityList([combinedText]);
		   
		    // 입력창 초기화
		    document.getElementById("manualDate").value = "";
		    document.getElementById("manualComment").value = "";
		  } else {
		    alert("날짜와 코멘트를 모두 입력해 주세요!");
		  }
		});
	
	// 저장한 일정쪽 함수 끝
	
	
	// 채팅 부분 관련 함수
	
	// 채팅 메시지 추가 함수
	  function addMessageToChat(message, cls) {
	    const chatArea = document.getElementById("chatArea");
	    const div = document.createElement("div");
	    div.className = "message " + cls;
	    div.innerHTML = message;
	    chatArea.appendChild(div);
	  }
	 
	  // 실제 메시지 전송 로직
	  function sendMessage(message) {
	    addMessageToChat(message, "user-msg");
	    fetch("/irumi/sendMessageToChatbot.do", {
	      method: "POST",
	      headers: { "Content-Type": "application/json" },
	      body: JSON.stringify({ userMsg: message, topic: CHAT_TOPIC })
	    })
	    .then(response => response.json())
	    .then(gptReply => {
	    	console.log("서버 응답:", gptReply);
	      addMessageToChat(gptReply.gptAnswer, "bot-msg");
	      // 버튼 옵션이 있으면 버튼 렌더
	      if (gptReply.options && Array.isArray(gptReply.options) && gptReply.options.length > 0) {
	        renderOptionButtons(gptReply.options);
	      } else {
	        removeOptionButtons();
	      }
	      scrollToBottom();
	    })
	    .catch(e => {
	      addMessageToChat("서버 오류 또는 JSON 파싱 실패!", "bot-msg");
	    });
	  }
	  
	// 추가 ------ 관심 직무, 관심 스펙 빈칸 체크 메소드
	  function isSelectionComplete() {
		  const jobText = document.querySelector(".info-row .value").textContent.trim();
		  const specText = document.querySelector(".spec-value").textContent.trim();
		  return jobText !== "" && specText !== "";
		}
	 
	 
	  // 사용자가 직접 입력할 때
	  document.getElementById("userInput").addEventListener("keyup", function(event) {
	    if (event.key === "Enter") {
	      const val = this.value.trim();
	      if(!isSelectionComplete()){
	    	  alert("먼저 목표 직무와 스펙을 선택하세요.");
	    	  return;
	     }
	      if (val) {
	        sendMessage(val);
	        this.value = "";
	      }
	    }
	  });
	 
	  document.querySelector(".chat-send-btn").addEventListener("click", function() {
	    const input = document.getElementById("userInput");
	    const val = input.value.trim();
	    if(!isSelectionComplete()){
	    	  alert("먼저 목표 직무와 스펙을 선택하세요.");
	    	  return;
	     }
	    if (val) {
	      sendMessage(val);
	      input.value = "";
	    }
	  });
	 
	 
	  function scrollToBottom() {
	    const chatArea = document.getElementById("chatArea");
	    chatArea.parentElement.scrollTop = chatArea.parentElement.scrollHeight;
	  }
	
	  // 채팅 관련 함수 끝
	
	 
	  // 옵션 관련 함수
	 
	   // 옵션 버튼 렌더링 함수
	  function renderOptionButtons(options) {
	    removeOptionButtons();
	    const chatArea = document.getElementById("chatArea");
	    const btnWrap = document.createElement("div");
	    btnWrap.id = "option-buttons";
	    btnWrap.style.marginTop = "15px";
	    btnWrap.style.display = "flex";
	    btnWrap.style.gap = "10px";
	    options.forEach(option => {
	      const btn = document.createElement("button");
	      btn.className = "select-btn";
	      btn.textContent = option;
	      btn.onclick = function() {
	        sendMessage(option);
	      };
	      btnWrap.appendChild(btn);
	    });
	    chatArea.appendChild(btnWrap);
	  }
	 
	  function removeOptionButtons() {
		    const prev = document.getElementById("option-buttons");
		    if (prev) prev.remove();
		 
	  }
	 
	  // 옵션 관련 함수 끝
	 
	 
	  document.querySelectorAll(".select-btn-list").forEach(group => {
		  const buttons = group.querySelectorAll(".select-btn");
		  buttons.forEach(btn => {
		    btn.addEventListener("click", function () {
		      buttons.forEach(b => b.classList.remove("active"));
		      this.classList.add("active");
		    });
		  });
		});
	 
	// 추가--------- 선택 완료 클릭 시 목표 직무 및 스펙 반영
	  document.querySelector(".confirm-select-btn").addEventListener("click", function () {
	      // 첫 번째 select-group은 직무 선택
	      const jobGroup = document.querySelectorAll(".select-group")[0];
	      const selectedJobBtn = jobGroup.querySelector(".select-btn.active");
	      const selectedJob = selectedJobBtn ? selectedJobBtn.textContent.trim() : null;
	      // 두 번째 select-group은 스펙 선택
	      const specGroup = document.querySelectorAll(".select-group")[1];
	      const selectedSpecBtn = specGroup.querySelector(".select-btn.active");
	      const selectedSpec = selectedSpecBtn ? selectedSpecBtn.textContent.trim() : null;
	      // 우측에 반영
	      if (selectedJob) {
	          document.querySelector(".info-row .value").textContent = selectedJob;
	      }
	      if (selectedSpec) {
	          document.querySelector(".spec-value").textContent = selectedSpec;
	      }
	  });
	 
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
.main {
  flex: 1;
  padding-right: 40px;
  padding-left: 40px;
  display: flex;
  flex-direction: column;
}
a {
 color: #BAAC80; /* 초록색 */
 text-decoration: underline; /* 밑줄 */
}
/* 사이드바 ************************************************************************************* */
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
  font-weight : bold;
 
}
.sidebar button:hover {
  background-color: #BAAC80;
  color: black;
}
.sidebar button.active {
 background-color: #BAAC80;
 color: black;
}
/* 사이드바 ************************************************************************************* */
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
/* 오른쪽 페널 */
.right-panel {
  width: 230px;
  padding-right: 20px;
  padding-left: 20px;
  display: flex;
  flex-direction: column;
  gap: 30px;
}
.right-panel .info-row{
  display: flex;
   align-items: center;
   margin-bottom: 10px;
}
.right-panel .label {
  font-size : 14px;
  color: #BAAC80;
   font-weight: bold;
}
.right-panel .value {
  color: #fff;
  font-size : 11px;
  margin-left : 4px;
}
.right-panel .spec-value {
  color: #fff;
  font-size : 11px;
  margin-left : 4px;
}
.right-panel .schedule-value {
  color: #fff;
  font-size : 9px;  
  margin-left : 4px;
}
/* 채팅 쪽 부분 */
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
/* 오른쪽 입력 박스 부분  */
.manual-input-box {
  display: flex;
  background: #232323;
  border-radius: 8px;
  padding: 6px 10px;
  margin-top: 12px;
  flex-direction: column;
  gap: 6px;
  align-items : center;
}
.manual-input-box .manual-input {
  flex: 1;
  background: transparent;
  border: none;
  color: #BAAC80;
  font-size: 14px;
  padding: 8px 4px;
  outline: none;
}
.manual-input-box .manual-date {
  flex: 1;
  background: transparent;
  border: none;
  color: #BAAC80;
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
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  margin-left: 4px;
  align-self: flex-end;
}
.manual-input-box .add-btn:hover {
  background: #BAAC80;
  color: #232323;
}
.saved-schedule-section {
   margin-bottom: 20px;
}
.section-title {
   color: #BAAC80;
   font-weight: bold;
   font-size: 15px;
   margin: 15px 0 10px 0;
}
.saved-schedule-list {
   display: flex;
   flex-direction: column;
   gap: 10px;
   margin-bottom: 14px;
}
.schedule-card {
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
.add-schedule-btn {
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
.add-schedule-btn span {
   font-size: 18px;
   font-weight: bold;
}
.add-schedule-btn:hover {
   background: #BAAC80;
   color: #232323;
}
.select-group {
 display: flex;
 flex-direction: column;  /* 세로 정렬 */
 align-items: flex-start; /* 좌측 정렬 */
 gap: 8px;
}
.select-label {
 color: #d9d9d9;
 font-size: 15px;
 font-weight: 600;
 margin-bottom: 2px;  /* 라벨 아래 약간 여백 */
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
 margin-bottom: 4px;  /* 버튼들끼리 간격 */
}
.select-btn:hover{
	background: #BAAC80;
	border: 1.5px solid #BAAC80;
	color: #1e1e1e;
	border-radius: 22px;
	font-size: 15px;
	font-weight: 500;
	padding: 7px 20px;
	margin-right: 8px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-bottom: 4px;
	opacity: 0.5;
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
 color : black;
 align-self: flex-end;
 text-align: right;
 font-weight : bold;
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
/* 추가 - 선택 버튼 css */
.confirm-select-box .confirm-select-btn{
	border: 1.5px solid #BAAC80;
	border-radius: 22px;
	font-size: 15px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top : 3px;
	font-weight : bold;
	text-align: center;
	color: #BAAC80;
	background: none;
}
.confirm-select-box .confirm-select-btn:hover{
	background: #BAAC80;
	border: 1.5px solid #BAAC80;
	color: #1e1e1e;
	border-radius: 22px;
	font-size: 15px;
	font-weight: 500;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	opacity: 0.5;
	color: black;
	
}
</style>
</head>
<body>
  <c:import url="/WEB-INF/views/common/header.jsp"/>
<c:set var="menu" value="chat" scope="request" />
<div class="container">
<!-- Sidebar -->
     <div class="sidebar">
        <button onclick="moveJobPage();">직무 찾기</button>
        <button onclick="moveSpecPage();">스펙 찾기</button>
        <button onclick="moveSchedulePage();" class="active">일정 찾기</button>
        <button onclick="moveActPage();">활동 찾기</button>
     </div>
     <!-- Main content -->
<div class="main">
			<!-- 콘텐츠 영역 -->
			<div class="content-box">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label">스펙 대상 직무 선택</span>
						<div class="select-btn-list">
							<button class="select-btn active">프론트엔드 개발자</button>
							<button class="select-btn">백엔드 개발자</button>
						</div>
					</div>
					<div class="select-group">
						<span class="select-label">일정 대상 스펙 선택</span>
						<div class="select-btn-list">
							<button class="select-btn active">정보처리기사</button>
							<button class="select-btn">OPIC IM 이상</button>
						</div>
					</div>
					<div class="confirm-select-box">
						<!--  클릭시 setSubTopic 해야함 -->
						<button class="confirm-select-btn">선택 완료</button>
					</div>
				</div>
				<div class="chat-area" id="chatArea">
					<div class="message bot-msg">이곳은 일정 찾기 세션입니다.<br>
						어떤 시험 일정이 궁금하신가요? 알고 싶으신 시험의 명칭을 입력해주세요! <br>
						(예: 정보처리기사 정보처리기능사)</div>
				</div>
			</div>
			<div class="chat-input-box">
   <input type="text" placeholder="무엇이든 물어보세요" class="chat-input" id="userInput"/>
   <button class="chat-send-btn" onclick="sendMessage()"><i class="fa fa-paper-plane"></i></button>
</div>
     </div>
<!-- Right panel -->
<div class="right-panel">
  <div class="info-row">
       <span class="label">➤ 목표 직무:</span> <span class="value"></span>
  </div>
  <div class="info-row">
       <span class="label">➤ 목표 스펙:</span> <span class="spec-value"></span>
  </div>
  <div class="saved-schedule-section">
       <div class="section-title">➤ 저장한 일정</div>
       <div class="saved-schedule-list" id="savedActivityList"></div>
      
      
  <div class="manual-input-box">
  <input type="date" class="manual-date" id="manualDate" placeholder="날짜 선택"/>
   <input type="text" placeholder="일정 입력" class="manual-input" id="manualComment"/>
   <button class="add-btn">+</button>
</div>
</div>
</div>
<!-- Footer -->
  <c:import url="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

