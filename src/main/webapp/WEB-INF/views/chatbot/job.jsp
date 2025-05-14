<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href="${ pageContext.servletContext.contextPath}/resources/css/chatbot.css" />
<link rel="stylesheet" type="text/css"
	href="${ pageContext.servletContext.contextPath}/resources/css/sidebar_left.css" />
<link rel="stylesheet" type="text/css"
	href="${ pageContext.servletContext.contextPath}/resources/css/sidebar_right.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
let savedJobs=null;
$(function() {
	$(".chat-send-btn").prop("disabled", false);
	
	// 유저가 이미 저장해둔 직무 가져오기
	$.ajax({ 
        type: "POST",
        url: "startChatSession.do",
        data: { topic: "job" }, // 필요 시 동적으로 변경
        success: function (sessionTopicOpts) {
        	// 유저가 저장한 직무들 전체 프론트에 가지고 있기 위함
        	console.log(sessionTopicOpts);
        	savedJobs = sessionTopicOpts.jobList; 
        	addToJobList(savedJobs);
        }
    });
	
	
		// ➤ 사용자 입력 메시지 서버로 전송 함수
	  function sendMessage(message) {
		 //답변 올 때까지 버튼 일시적 비활성화
	    $(".chat-send-btn").prop("disabled", true);
	    addMessageToChat(message, "user-msg"); // 사용자 메시지 표시
	    $.ajax({
	      type: "POST",
	      url: "/irumi/sendMessageToChatbot.do",
	      contentType: "application/json",
	      data: JSON.stringify({ userMsg: message,  topic: "job"  }),
	      success: function(gptReply) {
		        addBotMessageToChat(gptReply.gptAnswer, "bot-msg"); // 챗봇 응답 표시
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
	      },
	      complete: function(){
          	// 대답이 온 후 전송 버튼 활성화
          	$(".chat-send-btn").prop("disabled", false);
          }
	    });
	  }
	
	//SideBar
	// 복수선택 옵션에서 직무 선택완료 했을 때 실행======================
	  // ➤ 선택한 직무 리스트를 화면에 출력 가능한 카드로 만드는 함수
	  // 선택 옵션 각각에 대해 ajax 요청으로 delete가능.
	  function addToJobList(checkedJobCIs) {
	    const $jobList = $(".saved-job-list");
	    
	    $.each(checkedJobCIs, function(_, jobCI) {
	      const $card = $("<div>").addClass("citem-card");
	      // ✕ 삭제 버튼
	      const $removeBtn = $("<button>").addClass("remove-btn").text("✕").on("click", function() {
	        $card.remove(); // 클릭 시 카드 삭제
	        // 삭제 클릭시 DB에서도 삭제되게 함
	        // Dashboard Service 구현 후
	        $.ajax({
	            type: "POST",
	            url: "deleteSavedOption.do",
	            contentType: "application/json",
	            data: JSON.stringify(jobCI),  // jobCI는 현재 카드에 해당하는 CareerItemDto 객체
	            success: function () {
	              console.log("DB에서 항목 삭제 성공:", jobCI.title);
	            },
	            error: function () {
	              console.error("DB에서 항목 삭제 실패:", jobCI.title);
	            }
	          });
	      });

	      // 직무명 텍스트만 표시
	      console.log(jobCI.title);
	      const $span = $("<span>").text(jobCI.title);

	      $card.append($removeBtn).append($span);
	      $jobList.append($card);
	    });
	  }//선택한 직무 리스트를 화면에 출력 가능한 카드로 만드는 함수
	 
	 
	   // 복수 선택 옵션 버튼 제공 관련 =================================
	  // gpt가 추천된 직무들을 선택 가능한 체크박스로 제공하는 함수
	  function renderCheckboxList(options) {
	    removeCheckboxList(); // 기존 체크박스 목록 제거
	    const $chatArea = $("#chatArea");
	    const $listWrap = $("<div>").addClass("custom-checkbox-list").attr("id", "checkbox-list");

	    //options에는 jobCI 객체가 들어있음(컨트롤러 수정필요)
	    // 선택지 화면에 표시
	    $.each(options, function(_, jobCI) {
		     const $label = $("<label>").addClass("custom-checkbox");
		     const $input = $("<input>").attr({ type: "checkbox", value: jobCI.title });
		     const $optTitleSpan = $("<span>").addClass("checkbox-text").text(jobCI.title);
		     const $optExplainSpan = $("<span>").addClass("checkbox-explain").text(jobCI.explain);
		     const $checkMark = $("<span>").addClass("checkmark").html("&#10003;");
		      $label.append($input, $optTitleSpan,  $optExplainSpan/* , $checkMark */);
		      $input.on("change", function() {
	                if ($(this).prop("checked")) {
	                    // 체크된 상태일 때 배경색 변경
	                    $(this).closest('.custom-checkbox').css("background", "rgba(186, 172, 128, 0.3)");
	                } else {
	                    // 체크 해제된 상태로 돌아갈 때 배경색 초기화
	                    $(this).closest('.custom-checkbox').css("background", "transparent");
	                }
	            });
		      
		      $listWrap.append($label);
	    });
	    // ➤ "선택 완료" 버튼 추가
	    const $submitBtn = $("<button>").text("직무 추가하기").addClass("check-confirm-btn").on("click", function() {
	    	const checked = $listWrap.find("input:checked").map(function() {
	    	const chosenJobTitle = this.value;
	     	return options.find(jobCI => jobCI.title === chosenJobTitle); // job 자체를 반환
	    }).get();
	    if (checked.length === 0) {
	        alert("하나 이상 선택해 주세요!");
	        return;
	      }
	      
	      checked.forEach(function(jobCI) {
	    	  $.ajax({
	    	    type: "POST",
	    	    url: "insertCareerItem.do",
	    	    contentType: "application/json",
	    	    data: JSON.stringify(jobCI),
	    	    success: function(returnedJobCI) {
	    	      console.log("직무 저장 성공:", returnedJobCI.title);
	    	      addToJobList([returnedJobCI]); // 체크된 모든 것을 저장함.
	    	      removeCheckboxList();
	    	    },
	    	    error: function(xhr) {
		            if (xhr.status === 400) {
		              alert(xhr.responseText);  // 서버에서 보낸 실패 메시지
		            } else {
		              alert("직무 추가 중 오류가 발생했습니다.");
		            }
		          }
	    	  });
	    	});
	  
	  
	    });
	    $listWrap.append($submitBtn);
	    $chatArea.append($listWrap);
	  }	
	  
	  
	  //체크박스 리스트 렌더링 함수
	// 택1 옵션 버튼 제공 관련 ===============================
	  function renderOptionButtons(options) {
	    removeOptionButtons(); // 기존 옵션 버튼 제거
	    const $chatArea = $("#chatArea");
	    const $btnWrap = $("<div>").attr("id", "option-buttons").css({
	      marginTop: "15px",
	      display: "flex",
/* 	      gap: "10px" */
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
	        const isBtnDisabled = $(".chat-send-btn").prop("disabled");

	        if (val && !isBtnDisabled) {
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
		  	// 입력된 직무명
			const $input = $(".manual-input");
			const val = $input.val().trim();
			
			//입력된 직무 설명
	        const $explainInput = $(".manual-input-explain"); // 설명 입력 필드
	        const explainVal = $explainInput.val().trim(); // 설명 값
	        
	        // 직무명만 있어도 추가 가능
		    if (val) {
		    		const jobCI={title:val, explain:explainVal};
	     
			      // DB에 저장    ----------- 변경사항
			      $.ajax({
			        type: "POST",
			        url: "insertCareerItem.do",
			        data: JSON.stringify(jobCI),
			        contentType: "application/json; charset=UTF-8",
			        success: function(returnedJobCI) {
			          console.log("직무 추가 성공");
			          addToJobList([returnedJobCI]); // 이 시점에만 호출하면 OK
			        },
			        error: function(xhr) {
			            if (xhr.status === 400) {
			              alert(xhr.responseText);  // 서버에서 보낸 실패 메시지
			            } else {
			              alert("직무 추가 중 오류가 발생했습니다.");
			            }
			          }
			      });
			      $input.val("");
			      $explainInput.val(""); // 설명 입력 초기화
	      
	    } 
		    else {
	      alert("직무명은 필수 입력입니다.");
	    }
	  });
	 
	//기타 ------------------------------------------------
	
	 // 채팅창에 메시지 말풍선 추가 함수
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
	<div class="chatbot-page-layout">

		<div class="left-container">
			<div class="chatpage-title">
				대화형 도우미
			</div>
			<div class="left-sidebar">
				<!-- Sidebar -->
				<div class="sidebar">
					<button onclick="moveJobPage();" class="active">직무 찾기</button>
					<button onclick="moveSpecPage();">스펙 찾기</button>
					<button onclick="moveSchedulePage();">일정 찾기</button>
					<button onclick="moveActPage();">활동 찾기</button>
				</div>
			</div>
			<!--  left-sidebar -->
			<c:set var="menu" value="chat" scope="request" />
			<!-- footer에 페이지를 제대로 표시하기 위해 menu를 request scope에서 chatbot로 설정함 -->
		</div>
		<!-- left-container -->


		<!-- Main content -->
		<div class="main-container">

			<div class="chatbox">
				<div class="select-bar">
					<div class="select-group">
						<span class="select-label"> 🚀 내게 맞는 직무를 찾아보시겠어요?</span> 
						<span class="jobchat-explain"> 챗봇을 통해 원하시는 직무를 선택해 저장해 보세요.
							<br> 직무를 저장한 후 해당 직무에 필요한 스펙과 관련 일정, 활동을
							<br> 별도의 탭에서 찾아볼 수 있습니다.
							</span>
					</div>
					<hr>
				</div>
				<!-- <div class="content-box">


					<div class="chat-area" id="chatArea">
						<div class="message bot-msg">
							내게 맞는 직무 찾기 세션입니다.<br> 먼저, 희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점,
							가치관 등)을 말해주세요.
						</div>
					</div>
				</div> -->
				<div class="content-box">
					<div class="chat-container" id="chat-container">
						<div class="chat-area" id="chatArea">
							<div class="answer bot-msg" id="first-bot-prompt">
								내게 맞는 직무 찾기 세션입니다. <br> 먼저, 먼저, 희망 직무 추천에 도움이 될 사용자님의
								특성(성격, 가치관, 잘하거나 못하는 활동 등)을 말해주세요.
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- chatbox -->

			<div class="chat-input-box">
				<input type="text" placeholder="무엇이든 물어보세요" class="chat-input"
					id="userInput" />
				<button class="chat-send-btn" onclick="sendMessage()">
					➤
				</button>
			</div>
			<!-- Footer -->
			<c:import url="/WEB-INF/views/common/footer.jsp" />
		</div>
		<!-- Right panel -->

		<div class="right-container">
			<div class="right-panel">
				<div class="saved-job-section">
					<div class="section-title">🎯 저장한 목표 직무</div>
					<div class="saved-job-list"></div>

					<div class="section-title">➕ 직접 추가하기</div>
					<div class="manual-input-box">
						<div class="jobNameExplain">추가할 직무</div>
						<div class="manual-input-div">
							<input type="text" placeholder="직접 직무 입력" class="manual-input" />
						</div>
						<div class="manual-input-div">
							<input type="text" placeholder="직무 설명 (선택)"
								class="manual-input-explain" />
						</div>
						<button class="add-btn">목표 직무로 추가</button>
					</div>
				</div>
			</div>
		</div>
		<!--  rigt-container -->


	</div>
	<!--  chatbot-page-layout -->
</body>
</html>

