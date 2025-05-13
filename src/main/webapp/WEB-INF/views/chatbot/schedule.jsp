<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
	
	// 추가 - 위쪽 직무 버튼 불러오기
	fetch("startChatSession.do", {
	    method: "POST",
	    headers: { "Content-Type": "application/x-www-form-urlencoded" },
	    body: "topic=" + CHAT_TOPIC
	  })
	    .then(() => {
	      return fetch("userJobView.do", { method: "POST" });
	    })
	    .then(res => res.json())
	    .then(jobs => {
	      const jobList = document.getElementById("job-btn-list");
	      jobList.innerHTML = "";
	      jobs.forEach(job => {
	        const btn = document.createElement("button");
	        btn.className = "select-btn";
	        btn.textContent = job.jobName;
	        btn.dataset.jobId = job.jobId;
	        btn.onclick = () => {
	          
	          
	          fetch("setConvSubJobTopic.do", {
	            method: "POST",
	            headers: { "Content-Type": "application/json" },
	            body: JSON.stringify({
	              itemId: job.jobId,
	              title: job.jobName,
	              explain: job.jobExplain
	            })
	          });

	          loadSpecOptions(job.jobId);
	        };
	        jobList.appendChild(btn);
	      });
	    });

	  function loadSpecOptions(jobId) {
	    console.log("[DEBUG] loadSpecOptions 호출됨. jobId:", jobId);

	    fetch("selectSpecByJobId.do", {
	      method: "POST",
	      headers: { "Content-Type": "application/json" },
	      body: JSON.stringify({ jobId: jobId })
	    })
	      .then(res => res.json())
	      .then(specs => {
	        const specList = document.getElementById("spec-btn-list");
	        specList.innerHTML = "";
	        specs.forEach(spec => {
	          const btn = document.createElement("button");
	          btn.className = "select-btn";
	          btn.textContent = spec.title;
	          btn.dataset.specId = spec.itemId;
	          btn.onclick = () => {
	            window.selectedJobId = jobId;
	            window.selectedSpecId = spec.itemId;
	            window.selectedSpecName = spec.title;
	            window.selectedSpecType = spec.type;
	            window.selectedSpecExplain = spec.explain;

	            fetch("setConvSubSpecTopic.do", {
	              method: "POST",
	              headers: { "Content-Type": "application/json" },
	              body: JSON.stringify({
	                itemId: spec.itemId,
	                title: spec.title,
	                explain: spec.explain,
	                type: spec.type
	              })
	            });
	          };
	          specList.appendChild(btn);
	        });
	      });
	  }
	
	
	// 오른쪽 저장한 일정 부분 함수들
	function addToScheduleList(items) {
	    const actList = document.getElementById("savedScheduleList");
	    items.forEach(item => {
	      const card = document.createElement("div");
	      card.className = "schedule-card";
	      // 삭제 버튼
	      const removeBtn = document.createElement("button");
	      removeBtn.className = "remove-btn";
	      removeBtn.textContent = "✕";
	      removeBtn.onclick = function() {
	        card.remove();
	        
	        
	        fetch("CdeleteSpecSchedule.do", {
		    	  method: "POST",
		    	  headers: {
		    	    "Content-Type": "application/x-www-form-urlencoded"
		    	  },
		    	  body: new URLSearchParams({ ssId: item.ssId }).toString()
		    	})
		    	.then(response => {
		    	  if (response.ok) {
		    	    console.log("일정 삭제 성공");
		    	  } else {
		    	    alert("일정 삭제 실패!");
		    	  }
		    	});

	      };
	      // 텍스트
	      const span = document.createElement("span");
	      span.textContent = item.text;
	      card.appendChild(removeBtn);
	      card.appendChild(span);
	      actList.appendChild(card);
	    });
	  }
	
	document.querySelector(".add-btn").addEventListener("click", function() {
		if(!isSelectionComplete()){
	    	  alert("먼저 목표 직무와 스펙을 선택하세요.");
	    	  return;
	     }
		  const dateInput = document.getElementById("manualDate").value.trim();
		  const commentInput = document.getElementById("manualComment").value.trim();
		 
		    if (dateInput && commentInput) {

		    	fetch("insertSpecSchedule.do", {
		    	  method: "POST",
		    	  headers: {
		    	    "Content-Type": "application/x-www-form-urlencoded"
		    	  },
		    	  body: new URLSearchParams({
		    		  specId : window.selectedSpecId,
		    		  ssType : commentInput,
		    		  ssDate : dateInput
		    	  }).toString()
		    	})
		        .then(res => res.json())
		        .then(data => {
		        	const combined = dateInput + " / " + commentInput;
		            addToScheduleList([{ text: combined, ssId: data.ssId }]);

		            // 입력창 초기화
		            document.getElementById("manualDate").value = "";
		            document.getElementById("manualComment").value = "";
		        })
		        .catch(err => alert(err.message));
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
	 
	 
	  // 일정 데이터 사용자가 직접 입력
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
	 
	 // 수정 -직무버튼 이벤트리스너
	  document.addEventListener("click", function (e) {
  if (e.target.classList.contains("select-btn")) {
    // 같은 부모 아래 다른 버튼들의 active 제거
    const parent = e.target.closest(".select-btn-list");
    if (parent) {
      parent.querySelectorAll(".select-btn").forEach(btn => btn.classList.remove("active"));
    }
    e.target.classList.add("active");
  }
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
	      const selectedSpecId = selectedSpecBtn ? selectedSpecBtn.dataset.specId : null;
	      // 우측에 반영
	      if (selectedJob) {
	          document.querySelector(".info-row .value").textContent = selectedJob;
	      }
	      if (selectedSpec) {
	          document.querySelector(".spec-value").textContent = selectedSpec;
	      }
	      
	      if (selectedSpecId) {
	    	  const actList = document.getElementById("savedScheduleList");
	    	  actList.innerHTML = "";
	    	  
	    	    fetch("getSs.do", {
	    	      method: "POST",
	    	      headers: {
	    	        "Content-Type": "application/json"
	    	      },
	    	      body: JSON.stringify({ specId: selectedSpecId })
	    	    })
	    	    .then(res => res.json())
	    	    .then(list => {
	    	      // 🔄 CareerItemDto 형식 기반으로 변환
	    	      const formatted = list.map(item => ({
	    	        ssId: item.itemId,
	    	        text: item.strschedule + " / " + item.explain
	    	      }));
	    	      addToScheduleList(formatted);
	    	    })
	    	    .catch(err => {
	    	      console.error("일정 조회 실패:", err);
	    	    });
	    	  }
	      
	        $("#first-bot-prompt").show();
	  });
	 
	});
	
</script>
<style>
body {
	background-color: #111;
	color: #eeeeee;
	margin: 0;
	padding: 0 0 0 0 ;
	min-height: 100vh;
	display: flex;
	flex-direction:column;
	overflow-y:hidden;
}

/* chatbot-page-layout의 최대 크기 설정 */
.container {
    display: flex;
    max-width: 1200px;   /* 최대 너비 설정 */
    width: 100%;         /* 너비를 부모에 맞게 확장 */
     height: 95%;
    margin: 0 auto;      /* 중앙 정렬 */
    overflow: hidden;    /* 내용이 넘치지 않도록 숨김 */
     flex-grow:1; 
}



.main {
    flex: 1;            
    display: flex;      
    flex-direction: column; 
    background-color: #1e1e1e;
    padding-top: 20px;
    padding-left: 20px;
    padding-right: 20px;
    height: 100%;  
}

.left-containter {
    width: 200px;        /* 고정된 너비 */
    padding: 20px;
    flex-shrink: 0;      /* 사이드바가 축소되지 않게 */
    height: 100%;        /* 부모 높이 차지 */
}

.right-container {
    width: 250px;        /* 고정된 너비 */
    color: #333;

    padding-top:0px;
    padding-left: 20px;
    padding-right: 20px;
    padding-bottom: 0px;
    
    flex-shrink: 0;      /* 오른쪽 패널이 축소되지 않게 */
    height: 100%;        /* 부모 높이 차지 */
}

/* 채팅 부분 ************************************************************************************* */
.content-box {
	background-color: #1e1e1e;
	padding-top: 20px;
    padding-left: 20px;
    padding-right: 20px;
    height: 80%;
    border-radius: 10px;
    max-width: 700px; 
	/* padding-right : 20px;
	padding-left: 20px; */
	border-radius: 12px;
	line-height: 1.7;
	font-size: 14px;
	
/* 	height: 700px; */
	overflow-y: auto; /*내부 콘텐츠가 넘칠 경우 스크롤 활성화*/
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

.select-bar {
    flex-shrink: 0;      /* 크기가 축소되지 않게 */
    margin-bottom: 20px; /* 아래쪽 여백 추가 */
    height: 120px;       /* 고정된 높이 설정 */
    flex-direction: column;
    display: flex;
    height:auto;
}

/* .select-bar내의 hr을 flex 아이템처럼 다루기 */
.select-bar hr {
    width: 100%;   /* 부모 컨테이너에 맞춰 확장 */
    height: 0.3px;   /* 선의 두께 */
    background-color: #BAAC80;
    border: none;
    margin: 20px 0;
    flex-grow: 1;   /* 남은 공간을 차지 */
    opacity:0.3;
}

.content-box {
    flex-grow: 1;        /* 나머지 공간을 모두 차지 */
    overflow-y: auto;    /* 내용이 넘치면 스크롤 */
    height:auto;
    /* background-color: #222; */
}


/* 오른쪽 페널 ******************************************************** */


.right-panel {
    width: 250px;        /* 고정된 너비 */
    color: #333;
    padding: 20px;
    flex-shrink: 0;      /* 오른쪽 패널이 축소되지 않게 */
    height: 100%;        /* 부모 높이 차지 */
    overflow-y: auto; 
}

.right-panel .spec-value {
	color: #BAAC80;
	font-size: 14px;
	margin-left: 4px;
	font-weight: bold;
}

.right-panel .info-row {
	align-items: center;
	margin-bottom: 10px;
	flex-direction: column; /*세로 정렬*/
}

.right-panel .label {
	color: #eeeeee;
	font-weight: bold;
	font-size: 15px;
	margin: 25px 0 25px 0;
}

.right-panel .value {
	color: #BAAC80;
	font-size: 14px;
	margin-left: 4px;
	font-weight: bold;
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
.warning-box {
  margin-top: 12px;
  padding: 8px 12px;
  max-width: 100%;
  display: flex;
  justify-content: center;
}
.warning-text {
  font-size: 13px;
}



/* 오른쪽 입력 박스 부분  */
.manual-input-box {
  display: flex;
  background: #232323;
  border-radius: 8px;
  padding-left: 0; /* 수정: 왼쪽 패딩 제거로 배경색이 끝까지 채워지도록 */
  padding-right: 0; /* 유지: 오른쪽 패딩 제거로 .add-btn이 끝에 붙도록 */
  margin-top: 12px;
  flex-direction: column;
  gap: 6px;
  align-items: stretch; /* 유지: 자식 요소가 너비를 채우도록 */
  width: 100%; /* 유지: 부모 너비를 완전히 사용 */
  box-sizing: border-box; /* 유지: 패딩 포함 크기 계산 */
}
.manual-input-box .manual-input {
  width: 100%; /* 유지: .manual-date와 동일한 너비 */
  box-sizing: border-box; /* 유지: 패딩 포함 크기 계산 */
  background: transparent;
  border: none;
  color: #BAAC80;
  font-size: 14px;
  padding: 8px 14px; /* 수정: .manual-date와 패딩 통일 */
  outline: none;
}
.manual-input-box .manual-date {
  border-top-left-radius: 8px;
  border-top-right-radius: 8px;
  width: 100%; /* 유지: 부모 너비를 채움 */
  box-sizing: border-box; /* 유지: 패딩 포함 크기 계산 */
  flex: 1;
  background: #BAAC80;
  border: none;
  color: #232323;
  font-size: 14px;
  padding: 8px 14px; /* 수정: 오른쪽 끝까지 배경색 채우기 위해 패딩 조정 */
  outline: none;
  font-weight: bold;
  align-items: center;
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
  margin-left: auto; /* 유지: 오른쪽 끝 정렬 */
  margin-right: 2px; /* 유지: 최소 여백 */
  align-self: flex-end; /* 유지: 수직 하단 정렬 */
}

.manual-input-box .add-btn:hover {
  background: #BAAC80;
  color: #232323;
}
.saved-schedule-section {
   margin-bottom: 20px;
}
.section-title {
   color: #eeeeee;
   font-weight: bold;
   font-size: 15px;
   margin: 25px 0 10px 0;
}
.saved-schedule-list {
   display: flex;
   flex-direction: column;
   gap: 10px;
   margin-bottom: 14px;
}
.schedule-card {
	background: #232323;
	border: 1.5px solid #BAAC80;
	border-radius: 7px;
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 8px 14px;
	margin-bottom: 2px;
	font-size: 12px;
	color: #eeeeee;
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
 margin-bottom: 2px;  
 margin-top : 3px;
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
 gap: 5px; /* 버튼 사이 간격 */
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
.confirm-select-box .confirm-select-btn {
	border: 1.5px solid #eeeeee;
	border-radius: 10px;
	font-size: 15px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top: 3px;
	font-weight: bold;
	text-align: center;
	color: #eeeeee;
	background: none;
	margin-right: 20px;
}

.confirm-select-box .confirm-select-btn:hover {
	border-radius: 10px;
	font-size: 15px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top: 3px;
	font-weight: bold;
	text-align: center;
	color: #383838;
	background: #eeeeee;
	opacity: 0.3;
}





</style>
</head>
<body>
	<c:import url="/WEB-INF/views/common/header.jsp" />


<c:set var="menu" value="chat" scope="request" />
<div class="container">
<!-- Sidebar -->
     <div class="left-containter">
		     <c:set var="chatTopic" value="ss" scope="request" />
			<c:import url="/WEB-INF/views/common/sidebar_left.jsp" />
     </div>
     <!-- Main content -->
		<div class="main">
			<!-- 콘텐츠 영역 -->
			<div class="content-box">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label">스펙 대상 직무 선택</span>
						<div class="select-btn-list" id="job-btn-list"></div>
					</div>
					<div class="select-group">
						<span class="select-label">일정 대상 스펙 선택</span>
						<div class="select-btn-list" id="spec-btn-list"></div>
					</div>
					<div class="confirm-select-box">
						<!--  클릭시 setSubTopic 해야함 -->
						<button class="confirm-select-btn">선택 완료</button>
					</div>
					<hr>
				</div>

				<div class="content-box">
					<div class="chat-container" id="chat-container">
						<div class="chat-area" id="chatArea">
							<div class="message bot-msg" id="first-bot-prompt"
								style="display: none;">
								이곳은 일정 찾기 세션입니다.<br> 어떤 일정이 궁금하신가요? 알고 싶으신 일정의 명칭을 입력해주세요!
								<br> (예: oooo기사 시험 일정, xxx 공모전 일정, &&& 인턴십 일정)
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="chat-input-box">
				<input type="text" placeholder="무엇이든 물어보세요" class="chat-input"
					id="userInput" />
				<button class="chat-send-btn" onclick="sendMessage()">
					<i class="fa fa-paper-plane"></i>
				</button>
			</div>
			<div class="warning-box">
				<span class="warning-text">Irumi 챗봇은 실수를 할 수 있습니다. 중요한 정보는
					재차 확인하세요.</span>
			</div>
		</div>

		<div class="right-container">
			<div class="right-panel">
				<div class="info-row">
					<span class="label">🎯 목표 직무:</span> <span class="value"></span>
				</div>
				<div class="info-row">
					<span class="label">🎯 목표 스펙:</span> <span class="spec-value"></span>
				</div>
				<div class="saved-schedule-list" id="savedScheduleList"></div>

				<div class="saved-schedule-section">
					<div class="section-title">➕ 직접 일정 추가하기</div>

					<div class="manual-input-box">
						<input type="date" class="manual-date" id="manualDate" /> <input
							type="text" placeholder="일정 입력" class="manual-input"
							id="manualComment" />
						<button class="add-btn">+</button>
					</div>
				</div>
			</div>
		</div>

		<!-- Footer -->
  <c:import url="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

