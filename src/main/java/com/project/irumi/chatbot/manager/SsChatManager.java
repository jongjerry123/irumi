package com.project.irumi.chatbot.manager;

import java.util.List;

import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.context.ChatState;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateSsChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class SsChatManager {

	public ChatbotResponseDto getGptResponse(ConvSession session, String userInput) {
		ChatState rawState = session.getChatState();

		if (!(rawState instanceof StateSsChat)) {
			return new ChatbotResponseDto("일정 추천 상태 오류입니다. 세션을 새로 시작해주세요.", null);
		}

		StateSsChat state = (StateSsChat) rawState;

		switch (state) {
			case START:
				session.setChatState(StateSsChat.ASK_WHICH_SCHEDULE);
				return new ChatbotResponseDto(
					"스펙 관련 어떤 일정을 알고 싶으신가요? (예: 필기 시험 시작일, 실기 일정 등)", 
					null
				);

			case ASK_WHICH_SCHEDULE:
				// 예시 응답: GPT를 통해 실제 일정 추천하는 로직이 들어갈 자리
				session.setChatState(StateSsChat.ASK_WANT_MORE);
				return new ChatbotResponseDto(
					"찾으시는 일정은 5월 12일입니다. 다른 일정도 알고 싶으신가요?", 
					List.of("네", "아니요")
				);

			case ASK_WANT_MORE:
				if ("네".equals(userInput)) {
					session.setChatState(StateSsChat.ASK_WHICH_SCHEDULE);
					return new ChatbotResponseDto(
						"추가로 알고 싶은 일정을 말씀해주세요.", 
						null
					);
				} else {
					session.setChatState(StateSsChat.COMPLETE);
					return new ChatbotResponseDto(
						"일정 추천을 마쳤습니다. 도움이 되었기를 바랍니다!", 
						null
					);
				}

			case COMPLETE:
				return new ChatbotResponseDto("대화가 이미 종료된 상태입니다.", null);

			default:
				return new ChatbotResponseDto("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
		}
	}

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// 선택된 일정 옵션에 대한 처리 로직
		return new ChatbotResponseDto("선택한 일정 옵션 처리 기능은 아직 구현되지 않았습니다.", null);
	}
}