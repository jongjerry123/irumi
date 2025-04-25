<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
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

     // 버튼 선택 토글 이벤트
     const btns = document.querySelectorAll(".select-btn");
     btns.forEach(btn => {
       btn.addEventListener("click", function() {
         this.classList.toggle("active");
       });
     });

     // 채팅 보내기 함수
     function sendMessage() {
       const userInput = document.getElementById("userInput");
       const chatArea = document.getElementById("chatArea");
       const message = userInput.value.trim();
       if (!message) return;

       const userDiv = document.createElement("div");
       userDiv.className = "message user-msg";
       userDiv.textContent = message;
       chatArea.appendChild(userDiv);

       fetch("/chatbot/sendUserMsg.do", {
         method: "POST",
         headers: { "Content-Type": "application/x-www-form-urlencoded" },
         body: new URLSearchParams({
           convId: "demo-conv-id",
           topic: "job",
           userMsg: message
         })
       })
       .then(response => response.text())
       .then(gptReply => {
         const botDiv = document.createElement("div");
         botDiv.className = "message bot-msg";
         botDiv.textContent = gptReply;
         chatArea.appendChild(botDiv);
         userInput.value = "";
         chatArea.parentElement.scrollTop = chatArea.parentElement.scrollHeight;
       });
     }

     // 엔터키 이벤트 추가
     document.getElementById("userInput").addEventListener("keyup", function(event) {
       if (event.key === "Enter") {
         sendMessage();
       }
     });

     // 버튼 클릭 시 메시지 전송 이벤트 추가
     document.querySelector(".chat-send-btn").addEventListener("click", sendMessage);

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


/* 사이드바 ************************************************************************************* */

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
   font-size : 9px;
   margin-left : 4px;
}

.right-panel .spec-value {
   color: #fff;
   font-size : 9px;
   margin-left : 4px;
}

.right-panel .schedule-value {
   color: #fff;
   font-size : 9px;   
   margin-left : 4px;
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


.saved-schedule-section {
    margin-bottom: 20px;
}

.section-title {
    color: #BAAC80;
    font-weight: bold;
    font-size: 15px;
    margin: 24px 0 10px 0;
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
         <button onclick="moveSchedulePage();">일정 찾기</button>
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
  </div>
   
   
      <div class="chat-area" id="chatArea">
            <div class="message bot-msg">무엇을 도와드릴까요?</div>
         </div>
   </div>
   
   <div class="chat-input-box">
    <input type="text" placeholder="무엇이든 물어보세요" class="chat-input" id="userInput"/>
    <button class="chat-send-btn" onclick="sendMessage()"><i class="fa fa-paper-plane"> > </i></button>
</div>


      </div>

<!-- Right panel -->
<div class="right-panel">
   <div class="info-row">
        <span class="label">➤ 목표 직무</span> <span class="value">프론트엔드 개발자</span>
   </div>
   <div class="info-row">
        <span class="label">➤ 목표 스펙</span> <span class="spec-value">정보처리기사</span>
   </div>
   <div class="saved-schedule-section">
        <div class="section-title">➤ 저장한 일정</div>
        <div class="saved-schedule-list">
            <div class="schedule-card">
                <button class="remove-btn">✕</button>
                <span>20xx.xx.xx (정보처리기사 필기)</span>
            </div>
            <div class="schedule-card">
                <button class="remove-btn">✕</button>
                <span>20xx.xx.xx (OPEC 시험)</span>
            </div>
        </div>
   <div class="manual-input-box">
    <input type="text" placeholder="직접 일정 입력" class="manual-input"/>
    <button class="add-btn"><i class="fa fa-plus"> + </i></button>
</div>
</div>
</div>

<!-- Footer -->
   <c:import url="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>
