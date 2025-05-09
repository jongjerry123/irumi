package com.project.irumi.chatbot.manager;

import java.util.Arrays;
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
import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
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
	
	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}

	public ChatbotResponseDto handleChatMessage(ConvSession session, String userMsg) {	    

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
			return new ChatbotResponseDto("현재 세션 토픽 정보가 없습니다.", null);
			
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
    	            	
                    	session.setLastTopic(userMsg.trim());
                        session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                        
                        String answer = "'" + specName + "'에 대해 어떤 유형의 활동을 추천받으시겠어요?";
                      botChatMsg.setMsgContent(answer);
    					chatbotService.insertChatMsg(botChatMsg);
                        return new ChatbotResponseDto(
                            answer,
                            List.of("도서 추천", "영상 추천", "기타 활동 추천")
                        );
                    } else {
                    	session.setChatState(StateActChat.INPUT_HAVEBEEN);
                        return new ChatbotResponseDto(
                            "스펙 관련 입력이 아닌 것 같아요. 자격증, 분야, 기술 등과 관련된 주제로 다시 입력해 주세요."
                        );
                    }
                  } else {
                	  session.setChatState(StateActChat.INPUT_HAVEBEEN);
                      return new ChatbotResponseDto("빈 응답이 기록되었습니다. 다시 입력해 주세요.");
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
                return recommendActivity(lastSpec, type, session, session.getOptions(type));

            case RECOMMEND:
                // SHOW_MORE_OPTIONS로 자동 이동해서 버튼 선택받기
                session.setChatState(StateActChat.SHOW_MORE_OPTIONS);
                return new ChatbotResponseDto(
                    "더 추천받거나 다른 유형을 원하시면 아래 옵션을 선택하세요.",
                    List.of("같은 유형으로 더 추천 받기", "다른 유형", "종료")
                );

            case SHOW_MORE_OPTIONS:
                if ("다른 유형".equals(userMsg)) {
	            	botChatMsg.setMsgContent("다른 유형 검색");
					chatbotService.insertChatMsg(botChatMsg);
                    session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                    if(session.getLastActivityType() == "도서") {
                    	return new ChatbotResponseDto(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("영상 추천", "기타 활동 추천")
                            );
                    } else if (session.getLastActivityType() == "영상") {
                    	return new ChatbotResponseDto(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("도서 추천", "기타 활동 추천")
                            );
                    } else {
                    	return new ChatbotResponseDto(
                                "어떤 유형의 활동을 추천받으시겠어요?",
                                List.of("영상 추천", "기타 활동 추천")
                            );
                    }
                    
                } else if("같은 유형으로 더 추천 받기".equals(userMsg)){
                	botChatMsg.setMsgContent("같은 유형으로 더 추천 받기");
					chatbotService.insertChatMsg(botChatMsg);
                    session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                    return recommendActivity(lastSpec, session.getLastActivityType(), session, session.getOptions(session.getLastActivityType()));
                    
                } else if ("종료".equals(userMsg)) {
	            	botChatMsg.setMsgContent("종료");
					chatbotService.insertChatMsg(botChatMsg);
	            	botChatMsg.setMsgContent("이용해주셔서 감사합니다!");
					chatbotService.insertChatMsg(botChatMsg);
                    convManager.endSession(session.getUserId());   // 종료 누르면 바로 세션 삭제
                    session.resetRecommendedOption();
                    return new ChatbotResponseDto("이용해주셔서 감사합니다!");
                } else {
                    return new ChatbotResponseDto(
                        "원하시는 옵션을 선택해 주세요.",
                        List.of("같은 유형으로 더 추천 받기","다른 유형", "종료")
                    );
                }
                
            default:
                session.setChatState(StateActChat.INPUT_HAVEBEEN);
                return new ChatbotResponseDto("오류가 발생했습니다. 처음부터 다시 시도해 주세요.");
        }
    }

	/** 활동 유형 및 스펙 기준으로 GPT에게 추천 받는 부분 (도서/영상/기타) */
	private ChatbotResponseDto recommendActivity(String spec, String activityType, ConvSession session, Set<String> list) {
		
		String userId = session.getUserId(); // 또는 세션에서 직접 꺼내기
		String jobId = session.getSubJobTopicId();  
		String specId = session.getSubSpecTopicId();   
		
		Specific ss = new Specific();
		ss.setUserId(userId);
		ss.setJobId(jobId);
		ss.setSpecId(specId);

		List<Activity> savedActs = dashboardService.selectUserActs(ss);
		List<String> savedTitles = savedActs.stream()
			    .map(Activity::getActContent)  
			    .collect(Collectors.toList());
		String excludedActs = savedActs.isEmpty() ? "없음" : String.join(", ", savedTitles);
		
	    // 🔹 검색 키워드 생성
		String havebeen = session.getHavebeenact() != null ? session.getHavebeenact().getMsgContent() : "";
		if ("없음".equals(havebeen.trim())) {
		    havebeen = "";
		}
		
		String prompt;
		
		if(list == null) {
			prompt = switch (activityType) {
		    case "도서" -> """
		        %s를 공부하는 데 도움이 되는 도서를 3권만 추천해줘.
		        단, 사용자가 이전에 언급한 활동: "%s" 그리고 이미 저장된 활동들 : [%s] 과 중복되지 않도록 해줘.
		        도서명, 저자, 출판사만 포함해서 알려줘.
		        """.formatted(spec, havebeen, excludedActs);
		        
		    case "영상" -> """
		        %s에 대해 공부할 수 있는 유튜브 채널 또는 무료 강의 영상 3개 추천해줘.
		        단, 사용자가 이전에 언급한 활동: "%s" 그리고 이미 저장된 활동들 : [%s] 과 유사한 내용은 제외하고 새로운 추천만 해줘.
		        제목과 링크 포함해서 알려줘.
		        """.formatted(spec, havebeen, excludedActs);
		        
		    case "기타 활동" -> """
		        %s와 관련된 실전 경험을 쌓을 수 있는 공모전, 대외활동, 봉사활동 중에서
		        단, 사용자가 이전에 언급한 활동: "%s" 그리고 이미 저장된 활동들 : [%s] 과 겹치지 않는 새로운 활동 3가지를 추천해줘.
		        활동명 제공해주고 관련 URL이 있다면 URL 함께 제공해줘.
		        만약 관련 기타 활동이 없으면 반드시 빈칸을 보내줘.
		        """.formatted(spec, havebeen, excludedActs);
		        
		    default -> """
		        %s에 도움이 될 활동을 추천해줘. 단 "%s"와 비슷한 것은 제외해줘.
		        """.formatted(spec, havebeen);
		};
		} else {
			prompt = switch (activityType) {
		    case "도서" -> """
		        %s를 공부하는 데 도움이 되는 도서를 3권만 추천해줘.
		        단, 사용자가 이전에 언급한 요소: "%s" 그리고 이미 저장된 요소들 : [%s] 그리고 직전에 추천해줬던 요소들 : [%s] 과 중복되지 않도록 해줘.
		        도서명, 저자, 출판사만 포함해서 알려줘.
		        """.formatted(spec, havebeen, excludedActs, list);
		        
		    case "영상" -> """
		        %s에 대해 공부할 수 있는 유튜브 채널 또는 무료 강의 영상 3개 추천해줘.
		        단, 사용자가 이전에 언급한 활동: "%s" 그리고 이미 저장된 활동들 : [%s] 그리고 직전에 추천해줬던 요소들 : [%s] 과 유사한 내용은 제외하고 새로운 추천만 해줘.
		        제목과 링크 포함해서 알려줘.
		        """.formatted(spec, havebeen, excludedActs, list);
		        
		    case "기타 활동" -> """
		        %s와 관련된 실전 경험을 쌓을 수 있는 공모전, 대외활동, 봉사활동 중에서
		        단, 사용자가 이전에 언급한 활동: "%s" 그리고 이미 저장된 활동들 : [%s] 그리고 직전에 추천해줬던 요소들 : [%s] 과 겹치지 않는 새로운 활동 3가지를 추천해줘.
		        활동명 제공해주고 관련 URL이 있다면 URL 함께 제공해줘.
		        만약 관련 기타 활동이 없으면 반드시 빈칸을 보내줘.
		        """.formatted(spec, havebeen, excludedActs, list);
		        
		    default -> """
		        %s에 도움이 될 활동을 추천해줘. 단 "%s"와 비슷한 것은 제외해줘.
		        """.formatted(spec, havebeen);
		};
		}
		

		String gptAnswer = gptApiService.callGPT(prompt);
		System.out.println(gptAnswer);
		
		if(gptAnswer == null || gptAnswer.trim().isEmpty()) {
			ChatbotResponseDto crd = new ChatbotResponseDto();
			
			crd = cantChooseOptions(activityType, session);
			
			return crd;
		    
		} else {
			List<CareerItemDto> checkboxList = extractCheckboxItems(gptAnswer);
			
			if (checkboxList.isEmpty()) {
				ChatbotResponseDto crd = new ChatbotResponseDto();
				
				crd = cantChooseOptions(activityType, session);
				
				return crd;
			}
			
			for (CareerItemDto dto : checkboxList) {
			    session.addRecommendedOption(activityType, dto.getTitle());
			}
			
		    // 🔹 응답 메시지 문자열 생성
		    StringBuilder msgBuilder = new StringBuilder();
		    msgBuilder.append("아래 추천된 ").append(activityType).append(" 항목들을 확인해 보세요:\n");
		    for (CareerItemDto dto : checkboxList) {
		        msgBuilder.append("- ").append(dto.getTitle()).append(" (").append(dto.getExplain()).append(")\n");
		    }

		    // 🔹 대화 로그 DB 저장
		    ChatMsg botMsg = new ChatMsg();
		    botMsg.setConvId(session.getConvId());
		    botMsg.setConvTopic(session.getTopic());
		    botMsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); 
		    botMsg.setUserId(session.getUserId());
		    botMsg.setRole("BOT");
		    botMsg.setMsgContent(msgBuilder.toString());
		    chatbotService.insertChatMsg(botMsg);

		    // 🔹 상태 전이
		    session.setChatState(StateActChat.SHOW_MORE_OPTIONS);

		    return new ChatbotResponseDto(
		        "아래 추천된 항목 중 원하는 요소를 선택해 주세요!",
		        checkboxList,
		        List.of("같은 유형으로 더 추천 받기","다른 유형", "종료")
		    );
		}
	}
	
	private ChatbotResponseDto cantChooseOptions(String activityType, ConvSession session){
		ChatMsg botMsg = new ChatMsg();
	    botMsg.setConvId(session.getConvId());
	    botMsg.setConvTopic(session.getTopic());
	    botMsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); 
	    botMsg.setUserId(session.getUserId());
	    botMsg.setRole("BOT");
	    botMsg.setMsgContent(activityType + " 유형의 추천할 만한 요소가 없습니다. 다른 유형을 선택해주세요.");
	    chatbotService.insertChatMsg(botMsg);
	    
	    return new ChatbotResponseDto(
	    	activityType + " 유형의 추천할 만한 요소가 없습니다. 다른 유형을 선택해주세요.",
	        List.of("다른 유형", "종료")
	    );
	}



	private List<CareerItemDto> extractCheckboxItems(String gptAnswer) {
	    return Arrays.stream(gptAnswer.split("\n"))
	        .filter(line -> line.trim().matches("^\\d+\\..*")) 
	        .map(line -> {
	            String content = line.replaceAll("^\\d+\\.\\s*", ""); 
	            
	            CareerItemDto dto = new CareerItemDto();
	            dto.setTitle(content);         
	            dto.setType("act");            
	            return dto;
	        })
	        .collect(Collectors.toList());
	}
    
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


