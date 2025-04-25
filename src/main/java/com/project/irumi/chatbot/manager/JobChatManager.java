package com.project.irumi.chatbot.manager;

import java.util.List;

import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.context.ChatState;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateJobChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class JobChatManager {

	public ChatbotResponseDto getGptResponse(ConvSession session, String userChoice) {
		ChatState rawState = session.getChatState();

		if (!(rawState instanceof StateJobChat)) {
			return new ChatbotResponseDto("직무 추천 챗봇 상태 오류입니다. 세션을 다시 시작해주세요.", null);
		}

		StateJobChat state = (StateJobChat) rawState;

		switch (state) {
			case START:
				session.setChatState(StateJobChat.ASK_PERSONALITY);
				return new ChatbotResponseDto("직무 추천을 시작합니다. 성격, 강점, 가치관 등을 알려주세요.", null);

			case ASK_PERSONALITY:
				session.setChatState(StateJobChat.ASK_JOB_CHARACTERISTIC);
				return new ChatbotResponseDto("희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요.", null);

			case ASK_JOB_CHARACTERISTIC:
				session.setChatState(StateJobChat.ASK_WANT_MORE_OPT);
				return new ChatbotResponseDto("더 많은 추천을 받아보고 싶으신가요?", List.of("네", "아니요"));

			case ASK_WANT_MORE_OPT:
				if ("네".equals(userChoice)) {
					session.setChatState(StateJobChat.ASK_PERSONALITY); // 루프 예시
					return new ChatbotResponseDto("그럼 다시 특성을 알려주세요!", null);
				} else {
					session.setChatState(StateJobChat.COMPLETE);
					return new ChatbotResponseDto("추천을 마쳤습니다. 도움이 되었기를 바랍니다!", null);
				}

			case COMPLETE:
				return new ChatbotResponseDto("대화가 이미 완료되었습니다.", null);

			default:
				return new ChatbotResponseDto("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
		}
	}

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// 아직 옵션 클릭 처리 미구현
		return new ChatbotResponseDto("선택하신 직무 옵션에 대한 처리를 진행합니다. (아직 미구현)", null);
	}
}