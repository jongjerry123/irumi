package com.project.irumi.chatbot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.manager.ActChatManager;
import com.project.irumi.chatbot.manager.JobChatManager;
import com.project.irumi.chatbot.manager.SpecChatManager;
import com.project.irumi.chatbot.manager.SsChatManager;
import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatbotController {

	@Autowired
	private ConvSessionManager convManager;

	@Autowired
	private JobChatManager jobManager;
	@Autowired
	private SpecChatManager specManager;
	@Autowired
	private SsChatManager ssManager;
	@Autowired
	private ActChatManager actManager;

	// 탭별로 뷰페이지 내보내기 용도 ===========================
	@RequestMapping("startActRecChat.do")
	public String ViewActChatBot() {
		return "chatbot/act";
	}

	@RequestMapping("startJobRecChat.do")
	public String ViewJobChatBot() {
		return "chatbot/job";
	}

	@RequestMapping("startSpecRecChat.do")
	public String ViewSpecChatBot() {
		return "chatbot/spec";
	}

	@RequestMapping("startScheduleRecChat.do")
	public String ViewScheduleChatBot() {
		return "chatbot/schedule";
	}

	// 유저가 탭 내에서 대화 시작하기 버튼 누른 경우 ===========================
	// 세션매니저 관리 시작 (tab 유형에 따라 session 정보 저장)
	@RequestMapping(value = "startChatSession.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> startChatSession(
			@RequestParam("topic") String topic, 
			HttpSession loginSession) {

		String userId = (String) loginSession.getAttribute("userId");
		ConvSession session = convManager.createNewSession(userId, topic);

		Map<String, String> result = new HashMap<>();
		result.put("convId", session.getConvId());
		result.put("message", "대화가 시작되었습니다. 질문을 입력해주세요.");
		return result;
		// 이거 map 리턴해야 되나? 안해도 되지 않나?
	}

	// 대화 시작하고 서브 토픽 설정 클릭 ===========================
	@RequestMapping(value = "setConvSubTopic.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto setConvSubTopic(
			@RequestParam("userChoice") String userChoice,
			@RequestParam("convId") String convId,
			HttpSession loginSession
	/* HttpSession loginSession */
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
			responseDto = jobManager.setConvSubTopic(session, userChoice);
			break;
		case "spec":
			responseDto = specManager.setConvSubTopic(session, userChoice);
			break;
		case "ss":
			responseDto = ssManager.setConvSubTopic(session, userChoice);
			break;
		case "act":
			responseDto = actManager.setConvSubTopic(session, userChoice);
			break;
		default:
			responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
		}

		return responseDto;
	}

	// 유저가 대화를 시작한 후 메세지 전송버튼 클릭한 경우 ===========================
	// 세션 정보에 따라 매니저 서비스 호출
	@RequestMapping(value = "sendMessageToChatbot.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto sendMessageToChatbot(
			HttpSession loginSession,
			@RequestParam("userMsg") String userMsg) {
		String userId = (String) loginSession.getAttribute("userId");
		
		if(userId == null) {
			userId = "user";
		}   ///////////////////////////////////////////////////// 임시 추가
		ConvSession session = convManager.getSession(userId);
		
		if (session == null) {
	        return new ChatbotResponseDto("대화 세션이 없습니다. 먼저 '대화 시작' 버튼을 눌러주세요.", null);
	    } /////////////////////////////////////////////// 임시 추가
		String topic = session.getTopic();

		ChatbotResponseDto responseDto;

		switch (topic) {
		case "job":
			responseDto = jobManager.getGptResponse(session, userMsg);
			break;
		case "spec":
			responseDto = specManager.getGptResponse(session, userMsg);
			break;
		case "ss":
			responseDto = ssManager.getGptResponse(session, userMsg);
			break;
		case "act":
			responseDto = actManager.getGptResponse(session, userMsg);
			break;
		default:
			responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
		}

		return responseDto;
	}

	// 유저가 대화 중 챗봇이 준 옵션 중 선택 후 제출한 경우
	// 세션 정보에 따라 매니저 서비스 호출 -> 서비스에서 응답을 화면에 append
	// 유저가 챗봇이 준 옵션 중 선택 후 제출한 경우 ===========================
	@RequestMapping(value = "submitChatbotOption.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto submitChatbotOption(
			@RequestParam("userChoice") String userChoice,
			HttpSession loginSession
	/* HttpSession loginSession */
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
			responseDto = actManager.handleChatbotOption(session, userChoice);
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
		

}
