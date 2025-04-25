package com.project.irumi.chatbot.manager;

import java.util.ArrayList;
import java.util.List;

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

	public ChatbotResponseDto getGptResponse(ConvSession session, String userMsg) {
		StateActChat state = (StateActChat) session.getChatState();

		String context = session.getContext();
		String prompt = context + "\nuser: " + userMsg;
		String gptAnswer = gptApiService.callGPT(prompt);

		session.appendMessage("user", userMsg);
		session.appendMessage("assistant", gptAnswer);

		List<String> options = new ArrayList<>();
		options.add("더 추천받기");
		options.add("대시보드에 저장");
		
		 return new ChatbotResponseDto(gptAnswer, options);
	

		/////////////////////////////////////////////////////////////////////////

//		switch (state) {
//		case START:
//			session.setChatState(StateActChat.RECOMMEND_RESOURCE);
//			return new ChatbotResponseDto("먼저 관련된 추천 자료(도서, 영상 등)를 알려드릴게요.",
//					List.of("인공지능 입문 영상", "UX 기획 실무서", "오픈소스 참여 가이드"));
//
//		case RECOMMEND_RESOURCE:
//			session.setChatState(StateActChat.ASK_REQUIRED_SKILL);
//			return new ChatbotResponseDto("이 활동을 위해 필요한 능력이나 조건이 있을 수 있어요. 무엇이 필요할까요?", null);
//
//		case ASK_REQUIRED_SKILL:
//			session.setChatState(StateActChat.SELECT_SPEC_TOPIC);
//			return new ChatbotResponseDto("추천받고 싶은 항목을 선택해주세요.", List.of("UX 리서치", "알고리즘", "산학협력 활동"));
//
//		case SELECT_SPEC_TOPIC:
//			session.setChatState(StateActChat.COMPLETE);
//			return new ChatbotResponseDto("활동 추천을 마쳤습니다! 도움이 되었길 바랍니다.", null);
//
//		case COMPLETE:
//			return new ChatbotResponseDto("이 활동 추천 대화는 이미 완료되었어요.", null);
//
//		default:
//			return new ChatbotResponseDto("대화 상태 오류입니다. 다시 시도해주세요.", null);
//		}

	}

	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// 예: 사용자가 버튼을 클릭했을 때의 선택 처리 로직
		return new ChatbotResponseDto("활동 선택 처리가 완료되었습니다.", null);
	}
}