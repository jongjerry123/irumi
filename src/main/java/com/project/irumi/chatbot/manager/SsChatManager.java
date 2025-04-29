package com.project.irumi.chatbot.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.api.SerpApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.context.StateSsChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class SsChatManager {

	@Autowired
	private SerpApiService serpApiService;
	
	@Autowired
	private GptApiService gptApiService;
	
	@Autowired
	private ConvSessionManager convManager;
	
	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}
	
	
	
	

	public ChatbotResponseDto handleChatMessage(ConvSession session, String userMsg) {
	    StateSsChat state = (StateSsChat) session.getChatState();
	    if (state == null) state = StateSsChat.START;

	    switch (state) {
	        case START:
	            session.setChatState(StateSsChat.SERP_SEARCH);
	            return new ChatbotResponseDto("어떤 시험 일정이 궁금하신가요? (예: 정보처리기사 정보처리기능사)");

	        case SERP_SEARCH:
	            if (userMsg != null && !userMsg.isBlank()) {
	                // SerpAPI 호출
	                String serpResult = serpApiService.searchExamSchedule(userMsg);
	                session.setChatState(StateSsChat.ASK_WANT_MORE);
	                return new ChatbotResponseDto(
	                    serpResult,
	                    List.of("다른 시험 검색", "종료")
	                );
	            } else {
	                return new ChatbotResponseDto("시험명을 다시 입력해주세요.");
	            }

	        case ASK_WANT_MORE:
	            if ("다른 시험 검색".equals(userMsg)) {
	                session.setChatState(StateSsChat.SERP_SEARCH);
	                return new ChatbotResponseDto("어떤 시험 일정이 궁금하신가요? (예: 정보처리기사 정보처리기능사)");
	            } else {
	            	convManager.endSession(session.getUserId());
	                return new ChatbotResponseDto("이용해주셔서 감사합니다!");
	            }

	        default:
	            session.setChatState(StateSsChat.START);
	            return new ChatbotResponseDto("처음부터 다시 진행할게요!");
	    }
	}



}

	
