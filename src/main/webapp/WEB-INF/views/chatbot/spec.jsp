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
<title>chatbot 스펙 찾기</title>
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
.sidebar button.active {
 background-color: #BAAC80;
 color: black;
}
.main {
	flex: 1;
	padding-right: 40px;
	padding-left: 40px;
	display: flex;
	flex-direction: column;
	height:100%;
}
.content-box {
	background-color: #1e1e1e;
	max-width: 700px;
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
	
	/*위아래 패딩 추가*/
	padding-top: 30px;
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
.right-panel .info-row{
  align-items: center;
  margin-bottom: 10px;
  flex-direction: column; /*세로 정렬*/
}
.right-panel .label {
 font-size : 14px;
 color: #BAAC80;
  font-weight: bold;
}
.right-panel .value {
 color: #fff;
 font-size : 14px;
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
	/* 추가*/
	flex-direction: column;  /* 세로로 배치 */
    align-items: flex-start;  /* 왼쪽 정렬 */
    
	display: flex;
	align-items: left;
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
.content-box .custom-checkbox .checkbox-explain {
	color: #fff;
	font-size: 12px;
   margin-top: 5px;  /* 제목과 설명 사이에 여백 */
	letter-spacing: 0.5px;
}

.content-box .custom-checkbox .checkbox-text {
    color: #BAAC80;  /* 설명 색상 */
    font-size: 15px;
    font-weight:bold;
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
.saved-citem-section {
	margin-bottom: 20px;
}
.section-title {
	color: #BAAC80;
	font-weight: bold;
	font-size: 15px;
	margin: 35px 0 10px 0;
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
	font-size: 18px;
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
	margin-bottom: 7px; /* 버튼들끼리 간격 */
}

/*select-job-btn-list 와 같이 option-buttons내의 버튼들이 정렬되도록 고쳐줘. 한 버튼은 텍스트 크기 만해야 해*/
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
	margin-bottom: 4px; /* 버튼들끼리 간격 */
	opacity: 0.5;
}
.select-btn-list {
	display: flex;
	flex-direction: row;
	gap: 8px; /* 버튼 사이 간격 */
	flex-wrap: nowrap;
	
}
.select-job-btn-list {
	padding: 10px 10px 0px 10px;
}
.select-btn.active {
	background: #BAAC80;
	color: #232323;
	font-weight: 700;
}

.option-buttons {
	    display: flex; /* 버튼을 가로로 배치 */
	    flex-direction: row; /* 수평 정렬 */
	    gap: 8px; /* 버튼 사이의 간격 */
	    flex-wrap: wrap; /* 버튼들이 화면에 맞게 자동으로 줄바꿈되게 */
	    justify-content: flex-start; /* 왼쪽 정렬 */
	    
	     margin: 0; /* 부모 요소에서 오는 불필요한 여백 제거 */
  		  padding: 0; /* 불필요한 내부 여백 제거 */
}

/*************************************************************************** */
/*추가*/
/* .chat-container {
  display: flex;
  flex-direction: column;
  height: 100%; /* 전체 높이에서 상단/하단 제외하고 채움 */
}
/*
.chat-area {
	flex: 1;
	overflow-y: auto;
	background-color: #1e1e1e;
	border-radius: 12px;
	padding: 20px;
	display: flex;
	flex-direction: column;
	gap: 8px; 
} */
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

/* 추가된 클래스 - 챗봇 응답이 꽉 차게 함 - html 에 적용해야 함*/
.answer {
	max-width: 100%;
	/*padding: 10px 15px;*/
	border-radius: 12px;
	line-height: 1.5;
	font-size: 0.95em;
	word-wrap: break-word;
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
/*배경색, 글씨색 변경*/
	background-color: #383838; 
	color: white;
	align-self: flex-end;
	text-align: right;
	/*font-weight: bold;*/
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
.confirm-select-box{
	  display: flex;
	  justify-content: center; /* 수평 가운데 정렬 */
	  align-items: center;     /* 수직 가운데 정렬 (선택사항) */
}
/* 추가 - 선택 버튼 css */
.confirm-select-box .confirm-select-btn{
	border: 1.5px solid #eeeeee;
	border-radius: 10px;
	font-size: 15px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top : 3px;
	font-weight : bold;
	text-align: center;
	color: #eeeeee;
	background: none;
	margin-right: 20px;
}
.confirm-select-box .confirm-select-btn:hover{
	border-radius: 10px;
	font-size: 15px;
	padding: 7px 20px;
	cursor: pointer;
	transition: background 0.18s, color 0.18s, border 0.18s;
	margin-top : 3px;
	font-weight : bold;
	text-align: center;
	color: #383838;
	background: #eeeeee;
	opacity: 0.3;
}
</style>
<script>
function moveJobPage() { location.href = 'viewJobRecChat.do'; }
function moveSpecPage() { location.href = 'viewSpecRecChat.do'; }
function moveSchedulePage() { location.href = 'viewScheduleRecChat.do'; }
function moveActPage() { location.href = 'viewActRecChat.do'; }
</script>
<script>
let cacheSessionJobOpts=null; // 서버에서 받아온 유저가 저장한 모든 직무CI 리스트
let cacheSessionSpecOpts=null; // (스펙챗엔 필요 X)선택한 jobOpt에 따라 서버에서 가져올 내용 

let subTopicJobCI= null; // subtopic 지정 위해 서버로 보낼 CI 객체;

$(function() {
	// 대쉬보드 requestScope에서 가져오는 값.
	var dashJobName = "${job.jobName}";  
	
	// document ready시 바로 startChatSession, 직무 선택 버튼 보이기
	 // 서버는 jobList와  specList를 보냄.(리스트 내부 객체는 모두 CI .)
	$.ajax({ 
        type: "POST",
        url: "startChatSession.do",
        data: { topic: "spec" }, // 필요 시 동적으로 변경
        success: function (sessionTopicOpts) {
        	// 유저가 저장한 직무들 전체 프론트에 가지고 있기 위함
        	cacheSessionJobOpts = sessionTopicOpts.jobList; 
            const $jobBtnList = $(".select-job-btn-list");
            $jobBtnList.empty();
            if (sessionTopicOpts.jobList && sessionTopicOpts.jobList.length > 0) {
            	sessionTopicOpts.jobList.forEach((jobCI, index) => {
                    const btn = $("<button>")
                        .addClass("select-btn")
                        .text(jobCI.title);
                    $jobBtnList.append(btn);
                });
            	//대쉬보드에서 넘어온 jobTitle이 있을 경우
	           	 // 직무 버튼 생성 후 기본 선택
	           	if (dashJobName && dashJobName.trim() !== "") {
	                $(".select-job-btn-list .select-btn").each(function () {
	                    if ($(this).text().trim() === dashJobName.trim()) {
	                        $(this).siblings().removeClass("active");
	                        $(this).addClass("active");
	                        const clickedJobName = $(this).text();
	                        subTopicJobCI = cacheSessionJobOpts.find(jobCI => jobCI.title === clickedJobName);
	                    }
	                });
            	}
            }
			//타겟 직무 클릭시 토글되도록 하기
            const $specBtnList = $(".select-spec-btn-list");
            $specBtnList.empty();
            if (sessionTopicOpts.specList && sessionTopicOpts.specList.length > 0) {
            	sessionTopicOpts.specList.forEach((specCI, index) => {
                    const btn = $("<button>")
                        .addClass("select-btn")
                        .toggleClass("active", index === 0)
                        .text(specCI.title); // 예시
                    $specBtnList.append(btn);
                });
            }
        },
        error: function () {
            alert("사용자 정보를 불러오지 못했습니다.");
        }
    });
	
	// 선택 버튼 클릭 시 .active 클래스 부여 (하나만 선택되게)
	// active된 객체를 저장함.
	$(document).on("click", ".select-btn", function () {
	    $(this).siblings().removeClass("active");
	    $(this).addClass("active");
	    const clickedJobName = $(this).text();
	    
	    //서버에서 받아왔던 cacheSessionJobOpts 중에서
	    // 선택된 Job에 해당하는 Career Item 객체를 서버로 보내기 위해 저장.
	    subTopicJobCI = cacheSessionJobOpts.find(jobCI => jobCI.title === clickedJobName);
	    

	});
	
	// 토픽 선택 후 '선택 완료' 버튼 클릭시 setSubTopic
	// spec 은 선택한 job을 sub topic으로 하면 됨.
	// ss, act 는 최종으로 선택된 spec을 sub topic으로 설정해야 함.
	//subTopicJobCI을 보내면 됨.
	const $confirmSelectBtn = $(".confirm-select-btn");
	$confirmSelectBtn.on("click", function(){
		

	    // 선택된 항목이 있으면 서버에 전송
	    if (subTopicJobCI && subTopicJobCI.title) {
	        $.ajax({
	            type: "POST",
	            url: "setConvSubJobTopic.do",
	            data: JSON.stringify(subTopicJobCI),
	            contentType: "application/json",
	            success: function () {
	                console.log("sub topic 설정 완료:", subTopicJobCI.title);
	            },
	            error: function () {
	                alert("서브 토픽 설정에 실패했습니다.");
	            }
	        });
	    } else {
	        alert("선택된 항목이 없습니다.");
	    }
	});
	
    function sendMessage(message) {
        addMessageToChat(message, "user-msg");

        $.ajax({
            type: "POST",
            url: "/irumi/sendMessageToChatbot.do",
            contentType: "application/json",
            data: JSON.stringify({ userMsg: message, topic: "spec" }),
            success: function(gptReply) {
            	addBotMessageToChat(gptReply.gptAnswer, "bot-msg");

            	// 복수 선택 옵션이 올 경우
                if (gptReply.checkboxOptions && Array.isArray(gptReply.checkboxOptions) && gptReply.checkboxOptions.length > 0) {
                    renderCheckboxList(gptReply.checkboxOptions);
                  
                } else {
                    removeCheckboxList();
                }

            	// 택1 선택 옵션이 올 경우
                if (gptReply.options && Array.isArray(gptReply.options) && gptReply.options.length > 0) {
                	
                    renderOptionButtons(gptReply.options);
                } else {
                    removeOptionButtons();
                }

                scrollToBottom();
            },
            error: function() {
                addMessageToChat("서버 오류 또는 JSON 파싱 실패!", "bot-msg");
            }
        });// sendMessageToChatbot.do   
    }

    //sidebar
    function addToSpecList(specs) {
        const $specList = $(".saved-spec-list");
        $.each(specs, function(_, specCI) {
            const $card = $("<div>").addClass("citem-card");
            const $removeBtn = $("<button>").addClass("remove-btn").text("✕").on("click", function() {
                $card.remove();
            });
            const $span = $("<span>").text(specCI.title);
            $card.append($removeBtn).append($span);
            $specList.append($card);
        });
    }

    //대화중 스펙 버튼을 출력하는 함수
    function renderCheckboxList(options) {
    	console.log(options);
        removeCheckboxList();
        const $chatArea = $("#chatArea");
        const $listWrap = $("<div>").addClass("custom-checkbox-list").attr("id", "checkbox-list");

        $.each(options, function(_, specCI) {
            const $label = $("<label>").addClass("custom-checkbox");
            const $input = $("<input>").attr({ type: "checkbox", value: specCI.title });
            const $titleSpan = $("<span>").addClass("checkbox-text").text(specCI.title);
            const $explainSpan = $("<span>").addClass("checkbox-explain").text(specCI.explain);
            const $checkMark = $("<span>").addClass("checkmark").html("&#10003;");
            $label.append($input, $titleSpan, $explainSpan, $checkMark);
            $listWrap.append($label);
        });

        //t선택 완료 버튼
        const $submitBtn = $("<button>").text("선택 완료").css("margin-left", "10px").on("click", function() {
            const checked = $listWrap.find("input:checked").map(function() {
            	const selectedTitle = this.value;
            return options.find(specCI => specCI.title === selectedTitle);
            }).get();
            if (checked.length === 0) {
                alert("하나 이상 선택해 주세요!");
                return;
            }
            addToSpecList(checked);
            removeCheckboxList();
            
            // specCI 선택시, insertSpec으로 CI 형태로 보냄
            // ==> chatbot Controller가 받음
            checked.forEach(function(specCI) {

  	    	  $.ajax({
  	    	    type: "POST",
  	    	    url: "insertCareerItem.do",
  	    	    contentType: "application/json",
  	    	    data: JSON.stringify(specCI),
  	    	    success: function() {
  	    	      console.log("직무에 스펙 저장 성공:", specCI.title);
  	    	    },
  	    	    error: function() {
  	    	      console.error("직무에 스펙 저장 실패:", specCI.title);
  	    	    }
  	    	  });
  	    	});
            
            
        });

        $listWrap.append($submitBtn);
        $chatArea.append($listWrap);
    }

    //대화 중 대화 옵션 선택하는 함수
    function renderOptionButtons(options) {
        removeOptionButtons();
        const $chatArea = $("#chatArea");
        const $btnWrap = $("<div>").addClass("option-buttons").css({ marginTop: "15px", display: "flex", gap: "10px" });

        $.each(options, function(_, option) {
            const $btn = $("<button>").addClass("select-btn").text(option).on("click", function() {
                sendMessage(option);
            });
            $btnWrap.append($btn);
        });

        $chatArea.append($btnWrap);
    }

    //키보드 엔터시 메세지 보내게 설정
    $("#userInput").on("keyup", function(event) {
        if (event.key === "Enter") {
            const val = $(this).val().trim();
            if (val) {
                sendMessage(val);
                $(this).val("");
            }
        }
    });
	//send 버튼 클릭시 메세지 보내게 설정
    $(".chat-send-btn").on("click", function() {
        const $input = $("#userInput");
        const val = $input.val().trim();
        if (val) {
            sendMessage(val);
            $input.val("");
        }
    });
	// + 버튼 클릭시 직접 입력한 스펙 보내게 설정
    $(".add-btn").on("click", function() {
        const $input = $(".manual-input");
        const val = $input.val().trim();
        if (val) {
            addToSpecList([val]);
            $input.val("");
        } else {
            alert("스펙을 입력해 주세요!");
        }
    });
	// 입력한 메세지를 채팅창 말풍선으로 추가
    function addMessageToChat(message, cls) {
        const $chatArea = $("#chatArea");
        const $div = $("<div>").addClass("message " + cls).text(message);
        $chatArea.append($div);
    }
	
	//bot Message 를 화면에 추가
    function addBotMessageToChat(message, cls) {
        const $chatArea = $("#chatArea");
        const $div = $("<div>").addClass("answer " + cls).text(message);
        $chatArea.append($div);
    }
	
	//이전 선택 체크박스 사라지게 함
    function removeCheckboxList() {
        $("#checkbox-list").remove();
    }

	// 이전 선택 옵션들 사라지게 함
    function removeOptionButtons() {
        $(".option-buttons").remove();
    }

    function scrollToBottom() {
        const $chatArea = $("#chatArea");
        $chatArea.parent().scrollTop($chatArea.parent()[0].scrollHeight);
    }
  // 추가 ---------- 선택 완료 클릭 시 목표 직무 업데이트
   $(".confirm-select-btn").on("click", function () {
       const selectedBtn = $(".select-group .select-btn.active");
       if (selectedBtn.length > 0) {
           const selectedJob = selectedBtn.text().trim();
           $(".info-row .value").text(selectedJob);
       } else {
           alert("직무를 선택해주세요.");
       }
   });

});
</script>
<link rel="stylesheet" href="/css/chatbot-style.css">
</head>
<body>
<c:import url="/WEB-INF/views/common/header.jsp"/>
<c:set var="menu" value="chat" scope="request"/>
<div class="container">
   <div class="sidebar">
       <button onclick="moveJobPage();">직무 찾기</button>
       <button onclick="moveSpecPage();" class="active">스펙 찾기</button>
       <button onclick="moveSchedulePage();">일정 찾기</button>
       <button onclick="moveActPage();">활동 찾기</button>
   </div>
   <div class="main">
       <div class="content-box">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label">스펙 대상 직무 선택</span>
						<div class="select-job-btn-list">
							<!-- <button class="select-btn active">프론트엔드 개발자</button>
							<button class="select-btn">백엔드 개발자</button> -->
						</div>
						<!--  스펙 페이지에는 필요없지만 넣어봄 -->
						<div class="select-spec-btn-list">
						</div>
					</div>
					<div class="confirm-select-box">
						<!--  클릭시 setSubTopic 해야함 -->
						<button class="confirm-select-btn"> 선택 완료 </button>
					</div>
				</div>
				<div class="chat-container" id="chat-container">
				<div class="chat-area" id="chatArea">
					<div class="answer bot-msg">
						내게 맞는 스펙 추천 세션입니다.<br> 먼저, 현재 보유하고 있는 스펙이나 경험을 말씀해 주세요.
					</div>
					</div>
				</div>
			</div>
       <div class="chat-input-box">
           <input type="text" placeholder="무엇이든 물어보세요" class="chat-input" id="userInput" />
           <button class="chat-send-btn"><i class="fa fa-paper-plane"></i></button>
       </div>
   </div>
   <div class="right-panel">
       <div class="saved-schedule-section">
       	<div class="info-row">
      		<span class="label">➤ 목표 직무:</span> <span class="value"></span>
      		</div>
           <div class="section-title">➤ 저장한 스펙</div>
           <div class="saved-spec-list"></div>
           <div class="manual-input-box">
               <input type="text" placeholder="직접 스펙 입력" class="manual-input" />
               <button class="add-btn">+</button>
           </div>
       </div>
   </div>
</div>
<c:import url="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>

