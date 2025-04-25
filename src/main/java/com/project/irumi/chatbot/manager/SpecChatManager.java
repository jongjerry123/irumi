package com.project.irumi.chatbot.manager;

import java.util.List;

import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.context.ChatState;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateSpecChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;


@Component
public class SpecChatManager {

	public ChatbotResponseDto getGptResponse(ConvSession session, String userChoice) {
		ChatState rawState = session.getChatState();

		// 타입 안전성 확보
		if (!(rawState instanceof StateSpecChat)) {
			return new ChatbotResponseDto("스펙 추천 챗봇 상태 오류입니다. 세션을 다시 시작해주세요.", null);
		}

		StateSpecChat state = (StateSpecChat) rawState;

		switch (state) {
			case START:
				session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
				return new ChatbotResponseDto("현재 가지고 있는 스펙(예: 자격증, 프로젝트 등)을 간단히 입력해주세요.", null);

			case TEXT_CURRENT_SPEC:
				session.setSubtopicId(userChoice); // 예: 입력한 스펙을 하위 주제로 설정
				session.setChatState(StateSpecChat.OPT_SPEC_TYPE);
				return new ChatbotResponseDto("어떤 유형의 스펙에 관심 있으신가요?", List.of("기술 스펙", "프로젝트", "수료 인증"));

			case OPT_SPEC_TYPE:
				session.setChatState(StateSpecChat.ASK_WANT_MORE_OPT);
				return new ChatbotResponseDto("더 추천을 받아보고 싶으신가요?", List.of("네", "아니요"));

			case ASK_WANT_MORE_OPT:
				if ("네".equals(userChoice)) {
					session.setChatState(StateSpecChat.OPT_SPEC_TYPE); // 다시 추천 루프
					return new ChatbotResponseDto("다른 추천 스펙을 알려드릴게요.", List.of("오픈소스 기여", "산학 협력 과제"));
				} else {
					session.setChatState(StateSpecChat.COMPLETE);
					return new ChatbotResponseDto("추천을 마쳤습니다. 도움이 되었길 바랍니다!", null);
				}

			case COMPLETE:
				return new ChatbotResponseDto("대화가 이미 종료된 상태입니다.", null);

			default:
				return new ChatbotResponseDto("대화 상태 오류입니다. 다시 시도해주세요.", null);
		}
	}

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// 선택지 클릭 응답 처리 예시 (옵션 연동 시 개선 필요)
		return new ChatbotResponseDto("선택하신 스펙 옵션에 대한 처리를 진행합니다. (아직 미구현)", null);
	}
}
