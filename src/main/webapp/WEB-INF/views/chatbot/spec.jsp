<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" type="text/css"
	href="${ pageContext.servletContext.contextPath}/resources/css/chatbot.css" />

<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>



<title>chatbot 스펙 찾기</title>

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
let selectedType = null; // 사이드바에서 타입 버튼을 추적하는 변수



$(function() {
	//기본으로는 채팅 버튼 비활성화 돼있음
	$(".chat-send-btn").addClass("inactive");
	
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
	                selectedJobTitle=subTopicJobCI.title;
	                // 해당 subtopic에 해당하는 spec들 불러오기
	                $.ajax({
	                    type: "POST",
	                    url: "getSpecsByJob.do",
	                    data: JSON.stringify(subTopicJobCI),
	                    contentType: "application/json",  // 꼭 필요함!
	                    success: function (specList) {
	                        $(".saved-spec-list").empty(); // 기존 사이드바에 있던 것들 제거
	                    	addToSpecList(specList);      // 사이드바에 해당 직업에 저장된 스펙들 렌더링
	                    },
	                    error: function () {
	       		              alert("직무 추가 중 오류가 발생했습니다.");
	                    }
	                });
	                
	            },
	            error: function () {
	                alert("서브 토픽 설정에 실패했습니다.");
	            }
	        });
	        //서브토픽 지정 후 봇의 첫 메세지 + 스펙 추가 버튼이 나타나게 함
	        $("#first-bot-prompt").show();
	        $(".manual-input-box").show();
	        $(".selected-job-text").text(subTopicJobCI.title); // 봇 메세지에 나타날 직무 이름
	        $(".value").show();
	        $(".chat-send-btn").removeClass("inactive");
	    } 

	    else {
	        alert("선택된 항목이 없습니다.");
	    }
	});
	
    function sendMessage(message) {
    	//답변 올 때까지 버튼 일시적 비활성화
    	$(".chat-send-btn").addClass("inactive");
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
            },
            complete: function(){
            	// 대답이 온 후 전송 버튼 활성화
            	$(".chat-send-btn").removeClass("inactive");
            }
        });// sendMessageToChatbot.do   
    }

    //sidebar
    function addToSpecList(specs) {
    	console.log;
        const $specList = $(".saved-spec-list");
        $.each(specs, function(_, specCI) {
            const $card = $("<div>").addClass("citem-card");
            const $removeBtn = $("<button>").addClass("remove-btn").text("✕").on("click", function() {
                // 카드 모양 삭제
            	$card.remove(); 
                // db에서 삭제
                $.ajax({
    	            type: "POST",
    	            url: "deleteSavedOption.do",
    	            contentType: "application/json",
    	            data: JSON.stringify(specCI),  // jobCI는 현재 카드에 해당하는 CareerItemDto 객체
    	            success: function () {
    	              console.log("DB에서 항목 삭제 성공:", specCI.title);
    	            },
    	            error: function () {
    	              console.error("DB에서 항목 삭제 실패:", specCI.title);
    	            }
    	          });
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
           
            removeCheckboxList();
            
            // specCI 선택시, insertSpec으로 CI 형태로 보냄
            // ==> chatbot Controller가 받음
            const savedSpecCIs = [];
			//let completed = 0;
			
            checked.forEach(function(specCI) {
            	$.ajax({
            	    type: "POST",
            	    url: "insertCareerItem.do",
            	    contentType: "application/json",
            	    data: JSON.stringify(specCI),
            	    success: function(returnedSpecCI) {
            	      savedSpecCIs.push(returnedSpecCI);
            	      addToSpecList([returnedSpecCI]); // <-- 수정됨
            	    },
            	    error: function(xhr) {
    		            if (xhr.status === 400) {
    		              alert(xhr.responseText);  // 서버에서 보낸 실패 메시지
    		            } else {
    		              alert("스펙 추가 중 오류가 발생했습니다.");
    		            }
    		          }
/*             	    complete: function() {
            	      completed++;
            	      if (completed === checked.length) {
            	        addToSpecList(savedSpecCIs);  // 모든 요청 성공 후 한 번만 호출
            	      }
            	    } */
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
	 // 대체 내용
	 // 버튼 클릭 시 active 상태 토글
    $(".specType").on("click", function() {
        // 모든 버튼에서 active 클래스 제거
        $(".specType").removeClass("active");
        
        // 클릭된 버튼에만 active 클래스 추가
        $(this).addClass("active");
        
        // 선택된 버튼의 value 저장
        selectedType = $(this).text();//data("value");
    });

    // + 버튼 클릭 시 처리
    $(".add-btn").on("click", function() {
        const $input = $(".manual-input");
        const $explainInput = $(".manual-input-explain"); // 설명 입력 필드
        const val = $input.val().trim();
        const explainVal = $explainInput.val().trim(); // 설명 값

        // 선택된 타입과 입력 값이 모두 있을 때만 실행
        if (selectedType && val) {
            const specCI = {
                title: val,       // 입력한 스펙 제목
                explain: explainVal,  // 입력한 설명 (비워두어도 상관없음)
                type: selectedType // 선택된 타입
            };

            // 데이터를 서버로 보내는 AJAX 요청
            $.ajax({
                type: "POST",
                url: "insertCareerItem.do",
                contentType: "application/json",
                data: JSON.stringify(specCI),
                success: function() {
                    console.log("직무에 스펙 추가 성공");
                    addToSpecList([specCI]); 
                },
                error: function(xhr) {
		            if (xhr.status === 400) {
		              alert(xhr.responseText);  // 서버에서 보낸 실패 메시지
		            } else {
		              alert("직무 추가 중 오류가 발생했습니다.");
		            }
		          }
            });

            // 입력 필드 초기화
            $input.val("");
            $explainInput.val(""); // 설명 입력 초기화
            // 선택된 버튼 초기화
            $(".specType").removeClass("active");
            selectedType = null;  // reset
        } else {
            alert("스펙과 스펙 유형을 모두 입력해주세요.");
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
  // 추가 ---------- 선택 완료 클릭시 사이드바에 선택한 직무 정보 뜸
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
	<c:import url="/WEB-INF/views/common/header.jsp" />

		<div class="chatbot-page-layout">
		<div class="left-container">
			<c:import url="/WEB-INF/views/common/sidebar_left.jsp" />
			<c:set var="menu" value="chat" scope="request" />
			
			
		</div>
		
		
		<div class="main-container">
			<div class="select-bar">
				<div class="select-group">
					<span class="select-label">📜 어떤 직무에 필요한 스펙이 궁금하세요?</span>
					<div class="select-job-btn-list">
						<!-- <button class="select-btn active">프론트엔드 개발자</button>
								<button class="select-btn">백엔드 개발자</button> -->
					</div>
					<!--  스펙 페이지에는 필요없지만 넣어봄 -->
					<div class="select-spec-btn-list"></div>
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
						<div class="answer bot-msg" id="first-bot-prompt"
							style="display: none;">
							내게 맞는 스펙 추천 세션입니다. <br> 먼저, <span class="selected-job-text"></span>가
							되기 위해 <br> 이미 달성한 스펙이나 경험이 있으시면 말씀해 주세요.
						</div>
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
			<c:import url="/WEB-INF/views/common/footer.jsp" />
			
		</div>
		
		<div class="right-container">
			<c:import url="/WEB-INF/views/common/sidebar_right.jsp" />
		</div>
		
	</div><!--  chatbot-page-layout-->
	
	
</body>
</html>

