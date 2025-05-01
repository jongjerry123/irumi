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
	            boolean isMeaningful = isSpecRelatedInput(userMsg);
	            
	            if(isMeaningful) {
	            	// SerpAPI 호출
	                String serpResult = serpApiService.searchExamSchedule(userMsg);
	                session.setChatState(StateSsChat.ASK_WANT_MORE);
	                return new ChatbotResponseDto(
	                    serpResult,
	                    List.of("다른 시험 검색", "종료")
	                );
	            } else {
	            	session.setChatState(StateSsChat.SERP_SEARCH);
	            	return new ChatbotResponseDto("잘못된 응답을 하셨습니다. 다시 입력해주세요. (예 : 정보처리기사 청보처리기능사)");
	            }
	            	
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

	// 추가됨 -- 대화 맥락 파악 후 이상한 대화 거절
	private boolean isSpecRelatedInput(String input) {
        String prompt = """
        		입력 문장이 자격증, 직무, 공부, 기술 분야 등 '스펙'과 관련된 내용인지 판별하세요.
        		반드시 '예' 또는 '아니오' 중 하나만 출력하세요. 다른 설명은 하지 마세요.

        		입력: "%s"
            """.formatted(input);

        String reply = gptApiService.callGPT(prompt);
        return reply != null && reply.trim().startsWith("예");
    }
    

}

	
