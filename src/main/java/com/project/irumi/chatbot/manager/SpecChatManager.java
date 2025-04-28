package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateActChat;
import com.project.irumi.chatbot.context.StateSpecChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class SpecChatManager {
    
    @Autowired
    private GptApiService gptApiService;
    
    private static final Logger logger = LoggerFactory.getLogger(SpecChatManager.class);

    public ChatbotResponseDto getGptResponse(ConvSession session, String userMsg) {

        StateSpecChat state = (StateSpecChat) session.getChatState();
        if (state == null) state = StateSpecChat.TEXT_CURRENT_SPEC;
        logger.info("spec chat state: " + state);

        switch (state) {

            case TEXT_CURRENT_SPEC:
            	session.addToContextHistory("유저가 현재 보유한 스펙: " + userMsg);
            	
            	session.setChatState(StateSpecChat.OPT_SPEC_TYPE);
                return new ChatbotResponseDto("어떤 종류의 스펙 추천을 받고 싶으신가요?", 
                        List.of("자격증", "어학", "인턴십", "대회/공모전", "자기계발", "기타"));

            case OPT_SPEC_TYPE:
            	session.addToContextHistory("유저가 관심 있는 스펙 타입: " + userMsg);
                
                String gptAnswer = gptApiService.callGPT("다음 정보를 참고하여 유저가 [소프트웨어 개발자]직무에 지원할 때 이력으로 적으면 좋을 만한 스펙들을 3개 추천해 줘."
                																				+ "유저가 강점으로 살리거나, 가지고 있지 않으나 있으면 좋은 스펙을 추천해."
                																				+ "한 줄에 1개씩 출력해줘"+
                																				String.join(" ", session.getContextHistory()));
            	
            	List<String> specList = Arrays.stream(gptAnswer.split("\n"))
                        .map(s -> s.replaceAll("^\\d+\\.\\s*", "")) // 번호 제거
                        .collect(Collectors.toList());
            	
            	session.setChatState(StateSpecChat.ASK_WANT_MORE_OPT);
            	return new ChatbotResponseDto("추가로 더 추천받고 싶으신가요?", 
                        specList, List.of("네", "아니요"));

            case ASK_WANT_MORE_OPT:
                if ("네".equals(userMsg)) {
                    session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC); // 루프 예시
                    return new ChatbotResponseDto("그럼 다시 현재 가지고 있는 스펙이나 경험을 알려주세요.", null);
                } else {
                    session.setChatState(StateSpecChat.COMPLETE);
                    return new ChatbotResponseDto("추천을 완료했습니다. 준비 잘하시길 응원합니다!", null);
                }

            case COMPLETE:
            	session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
                return new ChatbotResponseDto("대화가 완료되었습니다. 추가로 필요한 것이 있으면 새로 시작해주세요.", null);

            default:
            	session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
                return new ChatbotResponseDto("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
        }
    }

    public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
        // (옵션 클릭 처리 기능 - 추후 필요시 구현 가능)
        return new ChatbotResponseDto("선택하신 스펙 옵션에 대해 추가 안내를 준비 중입니다. (아직 미구현)", null);
    }
}
