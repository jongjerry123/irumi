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
	    
	    $(".select-group:nth-of-type(2) .select-label").show();


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
	      label.appendChild(input);
	      label.appendChild(textSpan);
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
	  
	  $(".chat-send-btn").on("click", function () {
		  const val = $("#userInput").val().trim();
		  if (!isSelectionComplete()) {
		    alert("먼저 목표 직무와 스펙을 선택하세요.");
		    return;
		  }
		  if (val) {
		    sendMessage(val);
		    $("#userInput").val("");
		  }
		});
	  
	  function scrollToBottom() {
	    const chatArea = document.getElementById("chatArea");
	    chatArea.parentElement.scrollTop = chatArea.parentElement.scrollHeight;
	  }
	
	  document.querySelector(".add-btn").addEventListener("click", function() {
		  if(!isSelectionComplete()){
	    	  alert("먼저 목표 직무와 스펙을 선택하세요.");
	    	  return;
	     }
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
	 
	  $(document).on("click", ".select-btn", function () {
		  const $parent = $(this).closest(".select-btn-list");
		  if ($parent.length) {
		    $parent.find(".select-btn").removeClass("active");
		  }
		  $(this).addClass("active");
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
.container {
	display: flex;
	max-width: 1200px; /* 최대 너비 설정 */
	width: 100%; /* 너비를 부모에 맞게 확장 */
	height: 95%;
	margin: 0 auto; /* 중앙 정렬 */
	overflow: hidden; /* 내용이 넘치지 않도록 숨김 */
	flex-grow: 1;
}
.main {
	flex: 1; /* 남은 공간을 모두 차지 */
	display: flex; /* 자식 요소들을 세로로 배치 */
	flex-direction: column; /* 세로 배치 */
	flex-grow: 1;
	height: 100%; 
}

.left-container {
	width: 230px; /* 고정된 너비 */
	padding-top: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 0px;
	flex-shrink: 0; /* 사이드바가 축소되지 않게 */
	height: 100%; /* 부모 높이 차지 */
}

.right-container {
	width: 250px; /* 고정된 너비 */
	color: #333;
	padding-top: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 0px;
	flex-shrink: 0; /* 오른쪽 패널이 축소되지 않게 */
	height: 100%; /* 부모 높이 차지 */
}


/* 컨텐츠 박스 ***********************************************/
.chat-box {
	background-color: #1e1e1e;
	padding-top: 20px;
	padding-left: 20px;
	padding-right: 20px;
	height: 80%;
	border-radius: 10px;
	overflow-y: auto;
}
.content-box {
	flex-grow: 1; /* 나머지 공간을 모두 차지 */
	overflow-y: auto; /* 내용이 넘치면 스크롤 */
	height: auto;
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
	scrollbar-color: #BAAC80 #222;
	scrollbar-width: thin;
}
.content-box::-webkit-scrollbar {
 width: 9px;
 background: #222;
}
.content-box::-webkit-scrollbar-thumb {
 background: #BAAC80;
 border-radius: 6px;
}

.select-bar {
	flex-shrink: 0; /* 크기가 축소되지 않게 */
	margin-bottom: 20px; /* 아래쪽 여백 추가 */
	height: 120px; /* 고정된 높이 설정 */
	flex-direction: column;
	display: flex;
	height: auto;
}

/* .select-bar내의 hr을 flex 아이템처럼 다루기 */
.select-bar hr {
	width: 100%; /* 부모 컨테이너에 맞춰 확장 */
	height: 0.3px; /* 선의 두께 */
	background-color: #BAAC80;
	border: none;
	margin: 20px 0;
	flex-grow: 1; /* 남은 공간을 차지 */
	opacity: 0.3;
}

/* 오른쪽 페널********************************************************* */
.right-panel {
	width: 250px; /* 고정된 너비 */
	color: #333;
	padding: 20px;
	flex-shrink: 0; /* 오른쪽 패널이 축소되지 않게 */
	height: 100%; /* 부모 높이 차지 */
	overflow-y: auto;
}

.right-panel .spec-value {
	color: #BAAC80;
	font-size: 14px;
	margin-left: 4px;
	font-weight: bold;
}

.right-panel .info-row {
	display: flex;
	margin-bottom: 25px;
	flex-direction: column; /*세로 정렬*/
}

.right-panel .label {
	color: #eeeeee;
	font-weight: bold;
	font-size: 15px;
	margin-bottom: 10px;
}

.right-panel .value {
	color: #BAAC80;
	font-size: 14px;
	margin-left: 4px;
	font-weight: bold;
}

.right-panel .schedule-value {
	color: #fff;
	font-size: 9px;
	margin-left: 4px;
}

/* 채팅 쪽 부분 */
.chat-input-box .chat-send-btn:hover {
	background: #BAAC80;
}
.chat-input-box {
	display: flex;
	align-items: center;
	background: #222;
	border-radius: 10px;
	padding: 8px 16px;
	margin-top: 10px;
	flex-shrink: 0;
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
	width: 100%; /* 유지: .manual-date와 동일한 너비 */
	box-sizing: border-box; /* 유지: 패딩 포함 크기 계산 */
	background: transparent;
	border: none;
	color: #BAAC80;
	font-size: 14px;
	padding: 8px 14px; /* 수정: .manual-date와 패딩 통일 */
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
	line-height: 28px;
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
	color: #eeeeee;
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 8px; /* 라벨 아래 약간 여백 */
	padding-left: 10px;
}
.select-btn {
	background: none;
	border: 1.5px solid #BAAC80;
	color: #BAAC80;
	border-radius: 22px;
	font-size: 12px;
	font-weight: 500;
	padding: 7px 20px;
	margin-right: 8px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-bottom: 6px; /* 버튼들 위아래 간격 */
}
.select-btn:hover {
	background: #BAAC80;
	border: 1.5px solid #BAAC80;
	color: #1e1e1e;
	border-radius: 22px;
	font-size: 12px;
	font-weight: 500;
	padding: 7px 20px;
	margin-right: 8px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-bottom: 4px; /* 버튼들끼리 간격 */
	opacity: 0.5;
}
.select-btn-list {
	padding: 5px;
}
.select-btn.active {
	background: #BAAC80;
	color: #232323;
	font-weight: 700;
}
/*************************************************************************** */
.chat-container {
	display: flex;
	flex-direction: column;
	height: 100%;
	min-height: 0;
}

.chat-area {
	flex: 1;
	min-height: 0;
	overflow-y: auto;
	background-color: #1e1e1e;
	border-radius: 12px;
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
	background-color: #383838;
	color: white;
	align-self: flex-end;
	text-align: right;
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
	border-radius: 10px;
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
	display: flex;
	flex-direction: column;
	gap: 5px;
}
.content-box .custom-checkbox {
	flex-direction: column; /* 세로로 배치 */
	align-items: flex-start; /* 왼쪽 정렬 */
	display: flex;
	align-items: left;
	justify-content: space-between;
	background: #181818;
	border: 1.5px solid #383838;
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
.content-box .custom-checkbox .checkbox-text {
	color: #BAAC80;
	font-size: 15px;
	font-weight: bold;
}
.content-box .custom-checkbox .checkmark {
	display: none;
	font-size: 18px;
	color: #BAAC80;
	margin-left: 12px;
}
/* checked 상태일 때만 checkmark 보이기 */
/* .content-box .custom-checkbox input[type="checkbox"]:checked ~
	.checkmark {
	display: block;
	color: #B2E86F;
} */
.content-box .custom-checkbox input[type="checkbox"]:checked ~
	.checkbox-text {
	color: #B2E86F;
	font-weight: 600;
}
.content-box .custom-checkbox input[type="checkbox"]:checked {
	background: rgba(186, 172, 128, 0.3); /* 배경색을 체크된 상태에서 적용 */
}
.content-box .custom-checkbox:hover {
	background: rgba(186, 172, 128, 0.3);
}
.content-box .custom-checkbox:hover .checkbox-text {
	color: #B2E86F;
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
.chat-input-box {
	display: flex;
	align-items: center;
	background: #222;
	border-radius: 10px;
	padding: 8px 16px;
	margin-top: 10px;
}

.confirm-select-box {
	display: flex;
	justify-content: center; /* 수평 가운데 정렬 */
	align-items: center; /* 수직 가운데 정렬 (선택사항) */
}

.confirm-select-box .confirm-select-btn {
	border: 1.5px solid #eeeeee;
	border-radius: 10px;
	font-size: 12px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top: 3px;
	font-weight: bold;
	text-align: center;
	color: #eeeeee;
	background: none;
}

.confirm-select-box .confirm-select-btn:hover {
	border-radius: 10px;
	font-size: 12px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top: 3px;
	font-weight: bold;
	text-align: center;
	color: #383838;
	background: #eeeeee;
	opacity: 1;
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
			<div class="chat-box">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label">🏃 어떤 분야의 활동을 원하시나요? 먼저 직무를 선택해주세요</span>
						<div class="select-btn-list" id="job-btn-list">
						</div>
					</div>
					<div class="select-group">
						<span class="select-label" style="display: none;">🗓️ 준비한 스펙 중 활동을 확인할 대상을 선택해주세요</span>
						<div class="select-btn-list" id="spec-btn-list">
						</div>
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
								이곳은 활동 찾기 세션입니다. <br> 위에서 선택하신 목표 스펙을 이루기 위해 관련 활동을 하신 적이
								있으신가요? <br> 활동 경험이 있으시다면 적어주시고, 없으시다면 "없음"을 입력해주세요! <br>
								(예시 : 기사 자격증을 따기 위해 ooo 문제집 풀어본 경험이 있다, xx 인턴십에 도움이 되도록 사전 프로젝트를
								해본 경험이 있다 등등)
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
		</div>

		<div class="right-container">
			<div class="right-panel">
				<div class="info-row">
					<span class="label">🎯 목표 직무</span>
					<span class="value"></span>
				</div>
				<div class="info-row">
					<span class="label">🏅 목표 스펙</span> <span class="spec-value"></span>
				</div>

				<div class="saved-schedule-list" id="savedActivityList"></div>

				<div class="saved-schedule-section">
					<div class="section-title">🧾 직접 활동 추가하기</div>
					
					<div class="manual-input-box">
						<input type="text" placeholder="저장할 활동 입력" class="manual-input" />
						<button class="add-btn">+</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Footer -->
		<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>