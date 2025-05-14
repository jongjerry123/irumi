package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.api.SerpApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.context.StateActChat;
import com.project.irumi.chatbot.model.dto.CareerItemDTO;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDTO;
import com.project.irumi.chatbot.model.service.ChatbotService;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Specific;
import com.project.irumi.dashboard.model.service.DashboardService;

@Component
public class ActChatManager {

	@Autowired
	private GptApiService gptApiService;
	
	@Autowired
	private SerpApiService serpApiService;

	@Autowired
	private ConvSessionManager convManager;
	
	@Autowired
	private ChatbotService chatbotService;
	
	@Autowired
	private DashboardService dashboardService;
	

//	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
//		// TODO Auto-generated method stub
//		return null;
//	}


	public ChatbotResponseDTO handleChatMessage(ConvSession session, String userMsg) {	    

		ChatMsg botChatMsg = new ChatMsg();

		// 보내온 유저의 메세지 tb에 저장
		ChatMsg userChatMsg = new ChatMsg();
		userChatMsg.setConvId(session.getConvId());
		botChatMsg.setConvId(session.getConvId());
		userChatMsg.setConvTopic(session.getTopic());
		botChatMsg.setConvTopic(session.getTopic());
		switch(session.getTopic()) {
		case "job":
				userChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
				botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
				break;
		case "spec":
			userChatMsg.setConvSubTopicJobId(session.getSubSpecTopicId());
			botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
			break;
		case "ss":
			userChatMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
			botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
			break;
		case "act":
			userChatMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
			botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
			break;
		default: // topic 없으면 
			return new ChatbotResponseDTO("현재 세션 토픽 정보가 없습니다.", null);
			
		}		
		
		
		userChatMsg.setMsgContent(userMsg);
		
		userChatMsg.setRole("USER");
		botChatMsg.setRole("BOT");
		
		userChatMsg.setUserId(session.getUserId());
		botChatMsg.setUserId(session.getUserId());
		

		
        StateActChat state = (StateActChat) session.getChatState();
        if (state == null) {
        	state = StateActChat.INPUT_HAVEBEEN;
        }
        String lastSpec = session.getLastTopic();
        String lastActivityType = (String) session.getLastActivityType();
        
        String specId = session.getSubSpecTopicId();
	    String specName = dashboardService.selectSpec(specId).getSpecName();
	    System.out.println("subSpecName: " + specName);
        

        switch (state) {
            case INPUT_HAVEBEEN:
                if (userMsg != null && !userMsg.isBlank()) {
                    boolean isMeaningful = isSpecRelatedInput(userMsg);
                    String initMsg = """
    	    	            이곳은 활동 찾기 세션입니다.
						위에서 선택하신 목표 스펙을 이루기 위해 관련 활동을 하신 적이 있으신가요?
						활동 경험이 있으시다면 적어주시고, 없으시다면 \"없음\"을 입력해주세요!
						(예시 : 기사 자격증을 따기 위해 ooo 문제집 풀어본 경험이 있다, xx 인턴십에 도움이 되도록 사전 프로젝트를 해본 경험이 있다 등등)
    	    	            """;

    	    	        ChatMsg botMsg = new ChatMsg();
    	    	        botMsg.setConvId(session.getConvId());
    	    	        botMsg.setConvTopic(session.getTopic());
    	    	        botMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
    	    	        botMsg.setUserId(session.getUserId());
    	    	        botMsg.setRole("BOT");
    	    	        botMsg.setMsgContent(initMsg);

    	    	        chatbotService.insertChatMsg(botMsg); 
                    
                    if(isMeaningful) {
                    	ChatMsg Umsg = new ChatMsg();
    	            	Umsg.setConvId(session.getConvId());
    	            	Umsg.setConvTopic(session.getTopic());
    	            	Umsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); 
    	            	Umsg.setUserId(session.getUserId());
    	            	Umsg.setRole("USER");
    	            	Umsg.setMsgContent(userMsg);

    	            	chatbotService.insertChatMsg(Umsg);
    	            	session.setHavebeenact(Umsg);
    	            	
                        session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                        
                        String answer = "'" + specName + "'에 대해 어떤 유형의 활동을 추천받으시겠어요?";
                      botChatMsg.setMsgContent(answer);
    					chatbotService.insertChatMsg(botChatMsg);
                        return new ChatbotResponseDTO(
                            answer,
                            List.of("도서 추천", "영상 추천", "기타 활동 추천")
                        );
                    } else {
                    	session.setChatState(StateActChat.INPUT_HAVEBEEN);
                        return new ChatbotResponseDTO(
                            "스펙 관련 입력이 아닌 것 같아요. 자격증, 분야, 기술 등과 관련된 주제로 다시 입력해 주세요."
                        );
                    }
                  } else {
                	  session.setChatState(StateActChat.INPUT_HAVEBEEN);
                      return new ChatbotResponseDTO("빈 응답이 기록되었습니다. 다시 입력해 주세요.");
                  }
                	
                    
            case CHOOSE_ACTIVITY_TYPE:
                // 버튼 또는 텍스트 입력 모두 허용
            	ChatMsg Umsg = new ChatMsg();
            	Umsg.setConvId(session.getConvId());
            	Umsg.setConvTopic(session.getTopic());
            	Umsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); 
            	Umsg.setUserId(session.getUserId());
            	Umsg.setRole("USER");
            	Umsg.setMsgContent(userMsg);

            	chatbotService.insertChatMsg(Umsg);
            	
                String type = null;
                if ("도서 추천".equals(userMsg)) type = "도서";
                else if ("영상 추천".equals(userMsg)) type = "영상";
                else if ("기타 활동 추천".equals(userMsg)) type = "기타 활동";
                else type = userMsg; // 자유 텍스트도 허용

                session.setLastActivityType(type);
                session.setChatState(StateActChat.RECOMMEND);
                return recommendActivity(specName, type, session, session.getOptions(type));

            case RECOMMEND:
                // SHOW_MORE_OPTIONS로 자동 이동해서 버튼 선택받기
                session.setChatState(StateActChat.SHOW_MORE_OPTIONS);
                return new ChatbotResponseDTO(
                    "더 추천받거나 다른 유형을 원하시면 아래 옵션을 선택하세요.",
                    List.of("같은 유형으로 더 추천 받기", "다른 유형", "종료")
                );

            case SHOW_MORE_OPTIONS:
                if ("다른 유형".equals(userMsg)) {
	            	botChatMsg.setMsgContent("다른 유형 검색");
					chatbotService.insertChatMsg(botChatMsg);
                    session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                    if(session.getLastActivityType() == "도서") {
                    	return new ChatbotResponseDTO(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("영상 추천", "기타 활동 추천")
                            );
                    } else if (session.getLastActivityType() == "영상") {
                    	return new ChatbotResponseDTO(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("도서 추천", "기타 활동 추천")
                            );
                    } else {
                    	return new ChatbotResponseDTO(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("영상 추천", "기타 활동 추천")
                            );
                    }
                    
                } else if("같은 유형으로 더 추천 받기".equals(userMsg)){
                	botChatMsg.setMsgContent("같은 유형으로 더 추천 받기");
					chatbotService.insertChatMsg(botChatMsg);
                    session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                    return recommendActivity(specName, session.getLastActivityType(), session, session.getOptions(session.getLastActivityType()));
                    
                } else if ("종료".equals(userMsg)) {
	            	botChatMsg.setMsgContent("종료");
					chatbotService.insertChatMsg(botChatMsg);
	            	botChatMsg.setMsgContent("이용해주셔서 감사합니다!");
					chatbotService.insertChatMsg(botChatMsg);
                    convManager.endSession(session.getUserId());   // 종료 누르면 바로 세션 삭제
                    session.resetRecommendedOption();
                    return new ChatbotResponseDTO("이용해주셔서 감사합니다!");
                } else {
                    session.setChatState(StateActChat.SHOW_MORE_OPTIONS);
                    return new ChatbotResponseDTO(

                        "원하시는 옵션을 선택해 주세요.",
                        List.of("같은 유형으로 더 추천 받기","다른 유형", "종료")
                    );
                }
                
            default:
                session.setChatState(StateActChat.INPUT_HAVEBEEN);
                return new ChatbotResponseDTO("오류가 발생했습니다. 처음부터 다시 시도해 주세요.");
        }
    }

	/** 활동 유형 및 스펙 기준으로 GPT에게 추천 받는 부분 (도서/영상/기타) */

	private ChatbotResponseDTO recommendActivity(String spec, String activityType, ConvSession session, Set<String> list) {
	    String userId = session.getUserId();
	    String jobId = session.getSubJobTopicId();
	    String specId = session.getSubSpecTopicId();

	    // DB에서 이미 저장된 활동들 가져오기
	    Specific ss = new Specific();
	    ss.setUserId(userId);
	    ss.setJobId(jobId);
	    ss.setSpecId(specId);

	    List<Activity> savedActs = dashboardService.selectUserActs(ss);
	    List<String> savedTitles = savedActs.stream()
	        .map(Activity::getActContent)
	        .collect(Collectors.toList());

	    // 제외할 제목들 모으기
	    Set<String> excludedTitles = new HashSet<>(savedTitles);
	    excludedTitles.addAll(session.getOptions(activityType));  // 직전 추천 목록도 제외

	    // SerpAPI로 추천 검색
	    List<CareerItemDTO> serpResults = serpApiService.searchSerpActivity(spec, activityType, excludedTitles);

	    if (serpResults.isEmpty()) {
	        return cantChooseOptions(activityType, session);
	    }

	    // 세션에 추천 저장
	    for (CareerItemDTO dto : serpResults) {
	        String storedTitle = dto.getTitle().split(" \\(")[0].trim(); // '영상 제목 (링크)'에서 제목만
	        session.addRecommendedOption(activityType, storedTitle);
	    }

	    // 대화 로그 저장
	    StringBuilder msgBuilder = new StringBuilder();
	    msgBuilder.append("아래 추천된 ").append(activityType).append(" 항목들을 확인해 보세요:\n");
	    for (CareerItemDTO dto : serpResults) {
	        msgBuilder.append("- ").append(dto.getTitle()).append("\n");
	    }

	    ChatMsg botMsg = new ChatMsg();
	    botMsg.setConvId(session.getConvId());
	    botMsg.setConvTopic(session.getTopic());
	    botMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
	    botMsg.setUserId(session.getUserId());
	    botMsg.setRole("BOT");
	    botMsg.setMsgContent(msgBuilder.toString());
	    chatbotService.insertChatMsg(botMsg);

	    session.setChatState(StateActChat.SHOW_MORE_OPTIONS);

	    return new ChatbotResponseDTO(
	        "아래 추천된 항목 중 원하는 요소를 선택해 주세요!",
	        serpResults,
	        List.of("같은 유형으로 더 추천 받기", "다른 유형", "종료")
	    );
	}

	
	private ChatbotResponseDTO cantChooseOptions(String activityType, ConvSession session){
		ChatMsg botMsg = new ChatMsg();
	    botMsg.setConvId(session.getConvId());
	    botMsg.setConvTopic(session.getTopic());
	    botMsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); 
	    botMsg.setUserId(session.getUserId());
	    botMsg.setRole("BOT");
	    botMsg.setMsgContent(activityType + " 유형의 추천할 만한 요소가 없습니다. 다른 유형을 선택해주세요.");
	    chatbotService.insertChatMsg(botMsg);
	    
	    return new ChatbotResponseDTO(
	    	activityType + " 유형의 추천할 만한 요소가 없습니다. 다른 유형을 선택해주세요.",
	        List.of("다른 유형", "종료")
	    );
	}




	/*
	 * private List<CareerItemDto> extractCheckboxItems(String gptAnswer) { return
	 * Arrays.stream(gptAnswer.split("\n")) .map(String::trim) .filter(line ->
	 * !line.isBlank()) .map(line -> { String cleaned =
	 * line.replaceAll("^\\d+[.)\\-\\s]*", "").trim(); CareerItemDto dto = new
	 * CareerItemDto(); dto.setTitle(cleaned); dto.setType("act"); return dto; })
	 * .collect(Collectors.toList()); }
	 */

    
    // 추가됨 -- 대화 맥락 파악 후 이상한 대화 거절
    private boolean isSpecRelatedInput(String input) {
        String prompt = """
            다음 문장이 사용자가 원하는 스펙을 이루기 위한 활동에 관한 내용 혹은 "없음" 이라는 내용의 답변이면 '예', 관련 없으면 '아니오'로만 대답해 주세요.
            입력: "%s"
            """.formatted(input);

        String reply = gptApiService.callGPT(prompt);
        return reply != null && reply.trim().startsWith("예");
    }


}


