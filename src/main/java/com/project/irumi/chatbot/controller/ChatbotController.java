package com.project.irumi.chatbot.controller;

import java.util.HashMap;
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
	@RequestMapping(
			value = "startChatSession.do", 
			method = RequestMethod.POST)
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

	// 유저가 대화를 시작한 후 메세지 전송버튼 클릭한 경우 ===========================
	// 세션 정보에 따라 매니저 서비스 호출
	@RequestMapping(value = "sendMessageToChatbot.do",
										method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto sendMessageToChatbot (
													@RequestParam("convId") String convId,
	                                               @RequestParam("userMsg") String userMsg) {
	    ConvSession session = convManager.getSession(convId);
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


	// 유저가 챗봇이 준 옵션 중 선택 후 제출한 경우
	// 세션 정보에 따라 매니저 서비스 호출 -> 서비스에서 응답을 화면에 append
	// 유저가 챗봇이 준 옵션 중 선택 후 제출한 경우 ===========================
    @RequestMapping(value = "submitChatbotOption.do", method = RequestMethod.POST)
    @ResponseBody
    public ChatbotResponseDto submitChatbotOption(
    											@RequestParam("userChoice") String userChoice,
                                                  @RequestParam("convId") String convId
                                                  /*HttpSession loginSession*/	
    		) {
        ConvSession session = convManager.getSession(convId);
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

}
