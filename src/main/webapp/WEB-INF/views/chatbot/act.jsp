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
<title>chatbot 활동 찾기</title>
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
	
	const CHAT_TOPIC = "act";
	
	// 추가 
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
	
	
	
	  // 활동 리스트에 추가하는 함수
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
	        console.log(activity.actId);
	        
	        fetch("deleteSavedOption.do", {
		    	  method: "POST",
		    	  headers: {
		    		  "Content-Type": "application/json"
		    	  },
		    	  body: JSON.stringify({ itemId: activity.actId }) 
		    	})
		    	.then(response => {
		    	  if (response.ok) {
		    	    console.log("활동 삭제 성공");
		    	  } else {
		    	    alert("활동 삭제 실패!");
		    	  }
		    	});
	      };
	      // 텍스트
	      const span = document.createElement("span");
	      span.textContent = activity.text;
	      card.appendChild(removeBtn);
	      card.appendChild(span);
	      actList.appendChild(card);
	    });
	  }
	 
	 
	  // 체크박스 리스트 렌더링 함수 (선택 완료 시 오른쪽에 추가)
	  function renderCheckboxList(options) {
	    removeCheckboxList();
	    const chatArea = document.getElementById("chatArea");
	    const listWrap = document.createElement("div");
	    listWrap.className = "custom-checkbox-list";
	    listWrap.id = "checkbox-list";
	    options.forEach(opt => {
	      const label = document.createElement("label");
	      label.className = "custom-checkbox";
	      const input = document.createElement("input");
	      input.type = "checkbox";
	      input.value = opt.title;
	      const textSpan = document.createElement("span");
	      textSpan.className = "checkbox-text";
	      textSpan.textContent = opt.title;
	      const checkMark = document.createElement("span");
	      checkMark.className = "checkmark";
	      checkMark.innerHTML = "&#10003;";
	      label.appendChild(input);
	      label.appendChild(textSpan);
	      label.appendChild(checkMark);
	      listWrap.appendChild(label);
	    });
	   
	   
	    // 선택 완료 버튼
	    const submitBtn = document.createElement("button");
	    submitBtn.textContent = "선택 완료";
	    submitBtn.style.marginLeft = "10px";
	    submitBtn.onclick = function() {
	      const checked = Array.from(listWrap.querySelectorAll("input:checked")).map(cb => cb.value);
	      if (checked.length === 0) {
	        alert("하나 이상 선택해 주세요!");
	        return;
	      }
	     
	      // 오른쪽 리스트에 추가
	      Promise.all(checked.map(content =>
	      fetch("insertAct.do", {
	        method: "POST",
	        headers: { "Content-Type": "application/x-www-form-urlencoded" },
	        body: new URLSearchParams({
	          jobId: window.selectedJobId,
	          specId: window.selectedSpecId,
	          actContent: content
	        }).toString()
	      })
	      .then(res => res.json())
	      .then(data => {
	        if (data.success) {
	          addToActivityList([{ text: content, actId: data.actId }]);
	        } else {
	          alert("'" + content + "' 저장 실패");
	        }
	      })
	    ))
	    .then(() => {
	      removeCheckboxList();
	    })
	    .catch(() => alert("서버 통신 오류"));
	  };
	    listWrap.appendChild(submitBtn);
	    chatArea.appendChild(listWrap);
	  }
	  
	  // 추가 ------ 관심 직무, 관심 스펙 빈칸 체크 메소드
	  function isSelectionComplete() {
		  const jobText = document.querySelector(".info-row .value").textContent.trim();
		  const specText = document.querySelector(".spec-value").textContent.trim();
		  return jobText !== "" && specText !== "";
		}
	  
	 
	 
	  // 기존 체크박스 목록 지우기
	  function removeCheckboxList() {
	    const prev = document.getElementById("checkbox-list");
	    if (prev) prev.remove();
	  }
	 
	 
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
	 
	  // 채팅 메시지 추가 함수
	  function addMessageToChat(message, cls) {
	    const chatArea = document.getElementById("chatArea");
	    const div = document.createElement("div");
	    div.className = "message " + cls;
	    div.textContent = message;
	    chatArea.appendChild(div);
	  }
	 
	  // 실제 메시지 전송 로직
	  function sendMessage(message) {
	    addMessageToChat(message, "user-msg");
	    fetch("/irumi/sendMessageToChatbot.do", {
	      method: "POST",
	      headers: { "Content-Type": "application/json" },
	      body: JSON.stringify({ userMsg: message, topic: CHAT_TOPIC})
	    })
	    .then(response => response.json())
	    .then(gptReply => {
	      addMessageToChat(gptReply.gptAnswer, "bot-msg");
	      // 체크박스 옵션이 있으면 체크박스 리스트 렌더
	      if (gptReply.checkboxOptions && Array.isArray(gptReply.checkboxOptions) && gptReply.checkboxOptions.length > 0) {
	        renderCheckboxList(gptReply.checkboxOptions);
	      } else {
	        removeCheckboxList();
	      }
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
	
	  document.querySelector(".add-btn").addEventListener("click", function() {
		  const input = document.querySelector(".manual-input");
		  const val = input.value.trim();
		  if (val) {
			// 예: 직접 입력 후 빈값이 아니라면 db에 추가
			  fetch("insertAct.do", {
			    method: "POST",
			    headers: { "Content-Type": "application/x-www-form-urlencoded" },
			    body: new URLSearchParams({
			      jobId: window.selectedJobId,
			      specId: window.selectedSpecId,
			      actContent: val
			    }).toString()
			  })
			  .then(res => res.json())
			  .then(data => {
			    if (data.success) {
			      addToActivityList([{ text: val, actId: data.actId }]);
			      input.value = "";
			    } else {
			      alert("활동 저장 실패!");
			    }
			  });
		  } else {
		    alert("활동을 입력해 주세요!");
		  }
		});
	 
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
	      const selectedJobId = selectedJobBtn ? selectedJobBtn.dataset.jobId : null;

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
	    	  const actList = document.getElementById("savedActivityList");
	    	  actList.innerHTML = "";
	    	  
	    	  const reqBody = {
	    			  pId : selectedJobId,
	    			  itemId : selectedSpecId
	    	  };
	    	  
	    	    fetch("getActByCI.do", {
	    	      method: "POST",
	    	      headers: {
	    	        "Content-Type": "application/json"
	    	      },
	    	      body: JSON.stringify(reqBody)
	    	    })
	    	    .then(res => res.json())
	    	    .then(list => {
	    	      // 🔄 CareerItemDto 형식 기반으로 변환
	    	      const formatted = list.map(item => ({
	    	        actId: item.itemId,
	    	        text: item.title
	    	      }));
	    	      addToActivityList(formatted);
	    	    })
	    	    .catch(err => {
	    	      console.error("일정 조회 실패:", err);
	    	    });
	    	  }
	  });
	
});
	
	
	
	
</script>
<style>
body {
  background-color: #111;
  color: white;
  margin: 0;
  padding: 0;
  min-height: 100vh;
}
.container {
    display: flex;
    max-width: 1200px;   /* 최대 너비 설정 */
    max-height: 100vh;   /* 최대 높이 설정 (화면 높이) */
    width: 100%;         /* 너비를 부모에 맞게 확장 */
    height: 100%;        /* 높이를 부모에 맞게 확장 */
    margin: 0 auto;      /* 중앙 정렬 */
    overflow: hidden; 
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

.left-container {
    width: 200px;        /* 고정된 너비 */
    padding: 20px;
    flex-shrink: 0;      /* 사이드바가 축소되지 않게 */
    height: 100%;        /* 부모 높이 차지 */
}


/* 컨텐츠 박스 ***********************************************/
.content-box {
    flex-grow: 1;        /* 나머지 공간을 모두 차지 */
    overflow-y: auto;    /* 내용이 넘치면 스크롤 */
    height:auto;
    max-width: 700px; 
	border-radius: 12px;
	line-height: 1.7;
	font-size: 14px;
	
	height: 700px;
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
/* 오른쪽 페널********************************************************* */
.right-panel {
    width: 250px;        /* 고정된 너비 */
    color: #333;
    padding: 20px;
    flex-shrink: 0;      /* 오른쪽 패널이 축소되지 않게 */
    height: 100%;        /* 부모 높이 차지 */
    overflow-y: auto; 
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
.right-panel .spec-value {
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


/* manual 부분 */
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
/* 왼쪽 저장한 활동 부분 */
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
	flex-direction: column; /* 세로 정렬 */
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
	margin-bottom: 4px; /* 버튼들끼리 간격 */
}
.select-btn:hover {
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
	margin-bottom: 4px; /* 버튼들끼리 간격 */
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
/* 옵션 버튼 css 추가  */
#option-buttons button.select-btn {
	padding: 8px 18px;
	border-radius: 8px;
	border: 1.5px solid #BAAC80;
	background: #181818;
	margin-right: 6px;
	font-size: 1em;
	cursor: pointer;
}
#option-buttons button.select-btn:hover {
	background: #222;
}
/* 추가 **********************************************/
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
	border: 1.5px solid #BAAC80;
	border-radius: 10px;
	padding: 10px 18px;
	font-size: 16px;
	color: #BAAC80;
	position: relative;
	cursor: pointer;
	transition: border 0.2s, background 0.2s;
	min-width: 210px;
	max-width: 340px;
}
.content-box .custom-checkbox input[type="checkbox"] {
	display: none;
}
.content-box .custom-checkbox .checkbox-text {
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
	.checkbox-text {
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
.custom-checkbox-list button {
	width: 50%;
	align: left;
	margin-top: 18px;
	padding: 12px 0;
	background: #181818;
	color: #BAAC80;
	font-size: 18px;
	font-weight: 700;
	border: 1.5px solid #BAAC80;
	border-radius: 10px;
	cursor: pointer;
	letter-spacing: 1.3px;
	transition: background 0.2s, color 0.2s, border 0.2s;
}
.custom-checkbox-list button:hover {
	background: #222;
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
		<div class="left-container">
		     <c:set var="chatTopic" value="act" scope="request" />
			<c:import url="/WEB-INF/views/common/sidebar_left.jsp" />
     </div>
		<!-- Main content -->
		<div class="main">
			<!-- 콘텐츠 영역 -->
			<div class="content-box">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label">스펙 대상 직무 선택</span>
						<div class="select-btn-list" id="job-btn-list">
						</div>
					</div>
					<div class="select-group">
						<span class="select-label">활동 대상 스펙 선택</span>
						<div class="select-btn-list" id="spec-btn-list">
						</div>
					</div>
					<div class="confirm-select-box">
						<!--  클릭시 setSubTopic 해야함 -->
						<button class="confirm-select-btn">선택 완료</button>
					</div>
				</div>
				<div class="chat-area" id="chatArea">
					<div class="message bot-msg">
						이곳은 활동 찾기 세션입니다. <br>
						위에서 선택하신 목표 스펙을 이루기 위해 관련 활동을 하신 적이 있으신가요? <br>
						활동 경험이 있으시다면 적어주시고, 없으시다면 "없음"을 입력해주세요! <br>
						(예시 : 기사 자격증을 따기 위해 ooo 문제집 풀어본 경험이 있다, xx 인턴십에 도움이 되도록 사전 프로젝트를 해본 경험이 있다 등등)
					</div>
				</div>
			</div>
			<div class="chat-input-box">
				<input type="text" placeholder="무엇이든 물어보세요" class="chat-input"
					id="userInput" />
				<button class="chat-send-btn">
					<i class="fa fa-paper-plane"></i>
				</button>
			</div>
			<div class="warning-box">
				<span class="warning-text">Irumi 챗봇은 실수를 할 수 있습니다. 중요한 정보는
					재차 확인하세요.</span>
			</div>
		</div>
		<!-- Right panel -->
		<div class="right-panel">
			<div class="info-row">
				<span class="label">🎯 목표 직무:</span> <span class="value"></span>
			</div>
			<div class="info-row">
				<span class="label">🎯 목표 스펙:</span> <span class="spec-value"></span>
			</div>

			<div class="saved-schedule-list" id="savedActivityList"></div>

			<div class="saved-schedule-section">
				<div class="section-title">➤ 직접 활동 추가하기</div>
				<div class="manual-input-box">
					<input type="text" placeholder="저장할 활동 입력" class="manual-input" />
					<button class="add-btn">+</button>
				</div>
			</div>
		</div>
		<!-- Footer -->
		<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>