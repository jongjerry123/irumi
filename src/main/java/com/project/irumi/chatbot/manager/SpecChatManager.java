package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.api.SerpApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateSpecChat;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.dashboard.model.service.DashboardService;

@Component
public class SpecChatManager {
    
    @Autowired
    private GptApiService gptApiService;
    
    @Autowired
	private SerpApiService serpApiService;
    
    @Autowired
    private DashboardService dashboardService;
    
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
            	
            	// 유저 응답에 따라 관련 스펙 리스트 검색
            	
            	// 현재 타겟 직업은 job service에서 selectOneJob 개발시 설정
            	//String targetJob = session.getSubtopicId();
            	String targetJob = "소프트웨어 개발자";
            	String serpQuery = targetJob+ "되기 위해 필요한 " +userMsg + "리스트";
                String serpResult = serpApiService.searchJobSpec(serpQuery);
            	
                String gptAnswer = gptApiService.callGPT("다음 정보를 참고하여 유저가 [소프트웨어 개발자]직무에 지원할 때 이력으로 적으면 좋을 만한 스펙들을 3개 추천해 줘."
                																				+ "유저가 이미 보유한 스펙과 이미 저장한 스펙은 제외해 줘."
                																				+ "한 줄에 1개씩 출력해줘, "
                																				+"스펙명: 어떠한 능력을 보는 어떤 특징을 가진 스펙인지 간단히 설명하는 형태로."+
                																				String.join(" ", session.getContextHistory())+
                																				"참고용 검색 결과: " + serpResult
                																				// specific db 구현 후 
                																				//+"\n 유저가 저장한 스펙 리스트: "+ String.join(" ", dashboardService. )
                																				);
            	
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
