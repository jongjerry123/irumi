package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ChatState;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateActChat;
import com.project.irumi.chatbot.context.StateSsChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class SsChatManager {

	@Autowired
	private GptApiService gptApiService;
	
	
	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}
	
	
	
	public ChatbotResponseDto handleChatMessage(ConvSession session, String userMsg) {
		StateSsChat state = (StateSsChat) session.getChatState();
		if (state == null) state = StateSsChat.START;
	    String lastTopic = session.getLastTopic();
		
	    
	    switch (state) {
	    case START:
	        session.setChatState(StateSsChat.ASK_WHICH_SCHEDULE);
	        return new ChatbotResponseDto(
	            "알고 싶은 시험/자격증 일정을 말씀해 주세요! (예: 정보처리기사 필기, 토익 시험일 등)"
	        );

	    case ASK_WHICH_SCHEDULE:
	        // 유저가 일정명을 입력하면 GPT로 일정 안내 및 공식 링크 생성
	        if (userMsg != null && !userMsg.isBlank()) {
	            session.setLastTopic(userMsg);
	            // 예시: GPT가 "정보처리기사 필기시험: 2025-06-01 / [공식 안내 바로가기](https://q-net.or.kr)" 형태로 반환
	            String gptAnswer = gptApiService.callGPT(
	                userMsg + " 시험(자격증) 일정과 공식 사이트 안내 URL을 한글로 알려줘. 답변에 반드시 공식 사이트 주소(하이퍼링크)를 포함해줘."
	            );
	            session.setChatState(StateSsChat.ASK_WANT_MORE);
	            return new ChatbotResponseDto(
	                gptAnswer, 
	                List.of("다른 일정도 질문하기", "종료")
	            );
	        } else {
	            return new ChatbotResponseDto("알고 싶은 일정명을 입력해 주세요!", null);
	        }

	    case ASK_WANT_MORE:
	        if ("다른 일정도 질문하기".equals(userMsg)) {
	            session.setChatState(StateSsChat.ASK_WHICH_SCHEDULE);
	            return new ChatbotResponseDto(
	                "알고 싶은 시험/자격증 일정명을 입력해 주세요!", 
	                null
	            );
	        } else if ("종료".equals(userMsg) || "아니요".equals(userMsg)) {
	            session.setChatState(StateSsChat.COMPLETE);
	            return new ChatbotResponseDto(
	                "일정 안내를 종료합니다. 또 궁금한 점이 있으면 언제든 질문해 주세요!", 
	                null
	            );
	        } else {
	            // 사용자가 바로 일정명을 또 질문하는 경우
	            session.setLastTopic(userMsg);
	            String gptAnswer = gptApiService.callGPT(
	                userMsg + " 시험(자격증) 일정과 공식 사이트 안내 URL을 한글로 알려줘. 답변에 반드시 공식 사이트 주소(링크)를 포함해줘."
	            );
	            session.setChatState(StateSsChat.ASK_WANT_MORE);
	            return new ChatbotResponseDto(
	                gptAnswer, 
	                List.of("다른 일정도 질문하기", "종료")
	            );
	        }

	    case COMPLETE:
	        // 세션 초기화
	        session.setChatState(StateSsChat.START);
	        return new ChatbotResponseDto("일정 챗봇을 종료합니다. 다시 시작하려면 질문을 입력해 주세요!", null);

	    default:
	        session.setChatState(StateSsChat.START);
	        return new ChatbotResponseDto("오류가 발생했습니다. 다시 시도해 주세요.", null);
	}


	}

	
}