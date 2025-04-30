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
import com.project.irumi.chatbot.context.StateJobChat;
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
				boolean isMeaningful = isSpecRelatedInput(userMsg);
            	if(isMeaningful) {
            		session.addToContextHistory("유저가 현재 보유한 스펙: " + userMsg);
                	session.setGettedSpec(userMsg);   /// 수정 - 이미 갖고 있는 스펙 저장 (gpt 가 자꾸 보유 스펙 저걸 무시해서 걍 필드생성)
                	session.setChatState(StateSpecChat.OPT_SPEC_TYPE);
                    return new ChatbotResponseDto("어떤 종류의 스펙 추천을 받고 싶으신가요?", 
                            List.of("자격증", "어학", "인턴십", "대회/공모전", "자기계발", "기타"));
            	} else {
            		session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
	            	return new ChatbotResponseDto("잘못된 응답을 하셨습니다. 다시 입력해주세요. 내게 맞는 스펙 추천 세션입니다.\r\n"
	            			+ "현재 보유하고 있는 스펙이나 경험을 말씀해 주세요.");
            	}
            	

            case OPT_SPEC_TYPE:
            	session.addToContextHistory("유저가 관심 있는 스펙 타입: " + userMsg);
            	String specType = userMsg.trim(); // 수정 -- 스펙 타입 저장 (gpt 가 스펙 타입 무시해서 제대로 알아듣게 필드생성)
            	
            	
            	String gotSpec = session.getGettedSpec(); /// 수정 -- 이미 갖고 있는 스펙 가져오기
            	String specText;

            	if (gotSpec == null || gotSpec.isBlank()) {
            	    specText = "보유한 스펙 정보 없음";
            	} else {
            	    specText = gotSpec;
            	}
            	
            	// prompt 수정
            	String prompt = """
						다음 정보를 참고해서 유저가 [소프트웨어 개발자] 직무에 지원할 때 이력서에 적으면 좋을 %s 유형의 스펙들을 3개 추천해 주세요.
						한 줄에 1개씩 출력해주세요.
						단, 아래에 이미 유저가 보유한 스펙은 언급하지 마세요.

						유저가 보유한 스펙: %s

						유저의 상황:
						%s

						각 스펙은 한 줄에 "스펙명 - 간단한 설명" 형식으로 작성해 주세요.
						예:
						정보처리기사 - 컴퓨터 시스템과 정보처리 역량을 평가하는 대표적인 국가 자격증입니다.
						개인 포트폴리오 - 실제로 개발한 프로젝트로 실무 능력을 보여줄 수 있습니다.
						공모전 수상 - 문제 해결력과 창의성을 평가받을 수 있는 활동입니다.
						""".formatted(specType, specText, String.join(" ", session.getContextHistory()));

            			String gptAnswer = gptApiService.callGPT(prompt);

            	
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
    
    private boolean isSpecRelatedInput(String input) {
        String prompt = """
        		입력 문장이 사용자가 실제로 보유하고 있을 수 있는 스펙이나 경험(예: 자격증, 어학, 활동, 대외 경험 등)과 관련된 내용이면 '예', 그렇지 않으면 '아니오'라고만 답하세요.
        		다른 설명은 하지 마세요.

        		입력: "%s"
        		""".formatted(input);

        String reply = gptApiService.callGPT(prompt);
        return reply != null && reply.trim().startsWith("예");
    }
}
