package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateActChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class ActChatManager {

	@Autowired
	private GptApiService gptApiService;


	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}

	public ChatbotResponseDto handleChatMessage(ConvSession session, String userMsg) {
		StateActChat state = (StateActChat) session.getChatState();
		if (state == null) state = StateActChat.START;
	    String lastTopic = session.getLastTopic();
		
	    
	    switch (state) {
	        case START:
	            session.setChatState(StateActChat.RECOMMEND_RESOURCE);
	            return new ChatbotResponseDto(
	                "추천받고 싶은 자료(도서/영상 등)가 있으신가요?",
	                List.of("네", "아니요")
	            );

	        case RECOMMEND_RESOURCE:
	            if ("네".equals(userMsg)) {
	                session.setChatState(StateActChat.SELECT_SPEC_TOPIC);
	                return new ChatbotResponseDto(
	                    "어떤 스펙(분야/기술/자격증 등)에 대해 추천받고 싶으신가요? (예: 자바스크립트, 프론트엔드, 정보처리기사 등 자유롭게 입력)",
	                    null
	                );
	            } else if ("아니요".equals(userMsg)) {
	                session.setChatState(StateActChat.COMPLETE);
	                return new ChatbotResponseDto("알겠습니다. 궁금한 점이 있으면 언제든 말씀해 주세요!", null);
	            } else {
	                // 버튼이 아닌 입력(주제)도 허용
	                session.setLastTopic(userMsg);
	                session.setChatState(StateActChat.SELECT_SPEC_TOPIC);
	                return new ChatbotResponseDto(
	                    "알겠습니다! " + userMsg + "에 대해 더 궁금한 점이 있으신가요? (필요 역량, 준비 방법 등)",
	                    List.of("필요 역량 추천받기", "준비 방법 추천받기", "처음으로")
	                );
	            }

	        case SELECT_SPEC_TOPIC:
	            // 주제 입력 받았거나, 버튼 선택
	            if (userMsg != null && !userMsg.equals("처음으로")) {
	                session.setLastTopic(userMsg);
	                session.setChatState(StateActChat.ASK_REQUIRED_SKILL);

	                // 도서/자료 추천
	                String gptAnswer = gptApiService.callGPT(userMsg + " 관련 추천 도서 3개만, 한 줄에 1개씩 출력해줘.");
	                
	                List<String> bookList = Arrays.stream(gptAnswer.split("\n"))
	                        .map(s -> s.replaceAll("^\\d+\\.\\s*", "")) // 번호 제거
	                        .collect(Collectors.toList());
	                
	                return new ChatbotResponseDto(
	                	"관련 도서를 선택해보세요!", // 안내 멘트
	                    bookList,
	                    List.of("필요 역량 추천받기", "준비 방법 추천받기", "처음으로")
	                );
	            } else if ("처음으로".equals(userMsg)) {
	                session.setChatState(StateActChat.START);
	                return new ChatbotResponseDto("무엇이든 질문해 주세요!", null);
	            }
	            return new ChatbotResponseDto("추천받고 싶은 스펙을 입력해 주세요!", null);

	        case ASK_REQUIRED_SKILL:
	            lastTopic = (String) session.getLastTopic();
	            if ("필요 역량 추천받기".equals(userMsg)) {
	                // 필요 역량 추천
	                String gptAnswer = gptApiService.callGPT(lastTopic + " 준비에 필요한 능력/조건/지식 2~3개만 간단히 알려줘.");
	                return new ChatbotResponseDto(
	                    gptAnswer,
	                    List.of("준비 방법 추천받기", "처음으로")
	                );
	            } else if ("준비 방법 추천받기".equals(userMsg)) {
	                // 준비 방법 추천
	                String gptAnswer = gptApiService.callGPT(lastTopic + " 준비/학습 방법을 요약해줘.");
	                return new ChatbotResponseDto(
	                    gptAnswer,
	                    List.of("필요 역량 추천받기", "처음으로")
	                );
	            } else if ("처음으로".equals(userMsg)) {
	                session.setChatState(StateActChat.START);
	                return new ChatbotResponseDto("새로운 질문을 입력해 주세요!", null);
	            } else {
	                // 자유 질문 받기
	                String gptAnswer = gptApiService.callGPT(lastTopic + " 관련 질문: " + userMsg + " 에 대한 답변 알려줘.");
	                return new ChatbotResponseDto(
	                    gptAnswer,
	                    List.of("필요 역량 추천받기", "준비 방법 추천받기", "처음으로")
	                );
	            }

	        case COMPLETE:
	            // 대화 종료/초기화 안내
	            session.setChatState(StateActChat.START);
	            return new ChatbotResponseDto("대화가 종료되었습니다. 다시 시작하려면 질문을 입력해 주세요!", null);

	        default:
	            session.setChatState(StateActChat.START);
	            return new ChatbotResponseDto("오류가 발생했습니다. 처음부터 다시 시도해 주세요.", null);
	    } 

	}

}

