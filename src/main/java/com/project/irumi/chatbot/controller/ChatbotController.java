package com.project.irumi.chatbot.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.manager.ActChatManager;
import com.project.irumi.chatbot.manager.JobChatManager;
import com.project.irumi.chatbot.manager.SpecChatManager;
import com.project.irumi.chatbot.manager.SsChatManager;
import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatbotController {

	@Autowired
	private ConvSessionManager convManager;
	private static final Logger logger = LoggerFactory.getLogger(ChatbotController.class);

	
	// 추가
		@Autowired
	    private ConvSessionManager convSessionManager;
		
		// 추가
		@Autowired
		private GptApiService gptApiService;

		
	@Autowired
	private JobChatManager jobManager;
	@Autowired
	private SpecChatManager specManager;
	@Autowired
	private SsChatManager ssManager;
	@Autowired
	private ActChatManager actManager;

	// 탭별로 뷰페이지 내보내기 용도 ===========================
	@RequestMapping("viewActRecChat.do")
	public String ViewActChatBot() {
		return "chatbot/act";
	}

	@RequestMapping("viewJobRecChat.do")
	public String ViewJobChatBot() {
		return "chatbot/job";
	}

	@RequestMapping("viewSpecRecChat.do")
	public String ViewSpecChatBot() {
		return "chatbot/spec";
	}

	@RequestMapping("viewScheduleRecChat.do")
	public String ViewScheduleChatBot() {
		return "chatbot/schedule";
	}

	// 유저가 탭 내에서 대화 시작하기 버튼 누른 경우 ===========================
	// 세션매니저 관리 시작 (tab 유형에 따라 현재 로그인한 유저가 진행중인 session 정보)
	@RequestMapping(value = "startChatSession.do", method = RequestMethod.POST)
	@ResponseBody
	public void startChatSession(
			@RequestParam("topic") String topic, 
			HttpSession loginSession) {
		
		String userId = (String) loginSession.getAttribute("userId");
		ConvSession session = convManager.createNewSession(userId, topic);
		
		
	}

	// 대화 시작하고 서브 토픽 설정 클릭 ===========================
	// 클릭된 버튼에서 Career Item 객체정보를 받아 convManager에게 보내 subtopic으로 지정
	@RequestMapping(value = "setConvSubTopic.do", 
										method = RequestMethod.POST)
	@ResponseBody
	public void setConvSubTopic(
			 @RequestBody CareerItemDto selectedItem,
			HttpSession loginSession) 
	{
		String userId = (String) loginSession.getAttribute("userId");
		ConvSession session = convManager.getSession(userId);
		
		//세션 sub 주제 설정
		convManager.setConvSubTopic(session, selectedItem);
	}

	// 유저가 대화를 시작한 후 메세지 전송버튼 클릭한 경우 ===========================
	// 세션 정보에 따라 매니저 서비스 호출
	/*
	 * @RequestMapping(value = "sendMessageToChatbot.do", method =
	 * RequestMethod.POST)
	 * 
	 * @ResponseBody public ChatbotResponseDto sendMessageToChatbot( HttpSession
	 * loginSession,
	 * 
	 * @RequestParam("userMsg") String userMsg) { String userId = (String)
	 * loginSession.getAttribute("userId");
	 * 
	 * if(userId == null) { userId = "user"; }
	 * ///////////////////////////////////////////////////// 임시 추가 ConvSession
	 * session = convManager.getSession(userId);
	 * 
	 * if (session == null) { return new
	 * ChatbotResponseDto("대화 세션이 없습니다. 먼저 '대화 시작' 버튼을 눌러주세요.", null); }
	 * /////////////////////////////////////////////// 임시 추가 String topic =
	 * session.getTopic();
	 * 
	 * ChatbotResponseDto responseDto;
	 * 
	 * switch (topic) { case "job": responseDto = jobManager.getGptResponse(session,
	 * userMsg); break; case "spec": responseDto =
	 * specManager.getGptResponse(session, userMsg); break; case "ss": responseDto =
	 * ssManager.getGptResponse(session, userMsg); break; case "act": responseDto =
	 * actManager.getGptResponse(session, userMsg); break; default: responseDto =
	 * new ChatbotResponseDto("유효하지 않은 주제입니다.", null); }
	 * 
	 * return responseDto; }
	 */
	// 유저가 대화 중 챗봇이 준 옵션 중 선택 후 제출한 경우
	// 세션 정보에 따라 매니저 서비스 호출 -> 서비스에서 응답을 화면에 append
	// 유저가 챗봇이 준 옵션 중 선택 후 제출한 경우 ===========================
	@RequestMapping(value = "submitChatbotOption.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto submitChatbotOption(
			@RequestParam("userChoice") String userChoice,
			HttpSession loginSession
	) {
		String userId = (String) loginSession.getAttribute("userId");
		ConvSession session = convManager.getSession(userId);
		String topic = session.getTopic();

		ChatbotResponseDto responseDto;

		// handleChatbotOption:
		// 옵션 유형(대시보드 저장, 추가 추천 여부, 내용 추가 희망 여부)에 따라
		// 다르게 동작하여 유저 선택에 대해 응답하도록 함.
		switch (topic) {
		case "job":
			responseDto = jobManager.handleChatbotOption(session, userChoice);
			break;
		case "spec":
			responseDto = specManager.handleChatbotOption(session, userChoice);
			break;
		case "ss":
			responseDto = ssManager.handleChatbotOption(session, userChoice);
			break;
		case "act":
			responseDto = actManager.handleChatMessage(session, userChoice);
			break;
		default:
			responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
		}

		return responseDto;
	}

	// 메소드 추가 =====================================================
	// 사용자가 직접 직무/ 스펙/ 일정/ 활동 입력하고 추가 버튼 누르는 경우
	//1.  Dashboard Service(?) 사용해 사용자 career plan에 저장
	// 2. Job, Spec, Ss, Activity Service로 각각의 테이블에 저장
	//-- > 입력된 정보 다시 우측 사이드바에 받아오는 메소드 필요 
	@RequestMapping(value = "insertCareerItem.do", 
			method = RequestMethod.POST)
	@ResponseBody
	public CareerItemDto insertCareerItem(@RequestParam("itemId") String itemId,
	                                           HttpSession session) {
	    String userId = (String) session.getAttribute("userId");
	    ConvSession convSession = convManager.getSession(userId);
	    String topic = convSession.getTopic();
	    
	    //아래 토픽에 따라 manage, 
	    CareerItemDto insertedItem = new CareerItemDto();

	    switch (topic) {
	        case "job":
	          //  jobService.insertJob(insertedItem???); <-- job service 연계 필요
	            break;

	        case "spec":
//	            String jobIdForSpec = convSession.getSubtopicId(); // 직무 ID
//	            specService.insertSpec(insertedItem );

	            break;

	        case "act":
//	          //actService.insertAct(Inserted);
	            break;

	        case "ss":
	            break;

	        default:
	            return null;
	    }
	    return insertedItem;
	 
	}


	
	
	
	// 메소드 추가 =====================================================
	// 사용자가 우측 사이드바에서 스펙/ 일정/ 활동.. 삭제하는 경우 Dashboard Service 사용
		

	
	// 메소드 추가
	@RequestMapping(value = "/sendMessageToChatbot.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto sendMessageToChatbot(
			 @RequestBody Map<String, Object> body,
	        HttpSession session
	) {
		// 보낸 유저 정보
		User loginUser = (User) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : null;

		logger.info("login User: "+userId);
		
		//프론트에서 받은 유저 메세지와 토픽 가져오기
		String userMsg = (String) body.get("userMsg");
		String topic = (String) body.get("topic");
	    
	    ConvSession convSession=convManager.getSession(userId);
	    //진행중인 세션이 없는 경우
	    if (convSession==null) {
	    	convSession = convManager.createNewSession(userId, topic);
	    	logger.info("[DEBUG] New ConvSession created for " + userId + " / topic: " + topic);    

	    }
	    //진행중인 세션이 있는 경우
	    else {
	    	convSession=convManager.getSession(userId);
	    }
	 
	    ChatbotResponseDto responseDto;


	    switch (topic) {
	        case "job":
	            responseDto = jobManager.getGptResponse(convSession, userMsg);
	            break;
	        case "spec":
	            responseDto = specManager.getGptResponse(convSession, userMsg);
	            break;
	        case "ss":
	            responseDto = ssManager.getGptResponse(convSession, userMsg);
	            break;
	        case "act":
	            responseDto = actManager.handleChatMessage(convSession, userMsg);
	            break;
	        default:
	            responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
	    }

	    return responseDto;
	}
	
}
