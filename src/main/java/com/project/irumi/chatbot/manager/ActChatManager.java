package com.project.irumi.chatbot.manager;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.context.StateActChat;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.chatbot.model.service.ChatbotService;
import com.project.irumi.chatbot.model.dto.CareerItemDto;

@Component
public class ActChatManager {

	@Autowired
	private GptApiService gptApiService;

	@Autowired
	private ConvSessionManager convManager;
	
	@Autowired
	private ChatbotService chatbotService;
	
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
			userChatMsg.setConvSubTopicJobId(session.getSubtopicId());
			botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
			break;
		case "ss":
			userChatMsg.setConvSubTopicSpecId(session.getSubtopicId());
			botChatMsg.setConvSubTopicSpecId(null); // 직무선택은 subtopic 없음.
			break;
		case "act":
			userChatMsg.setConvSubTopicSpecId(session.getSubtopicId());
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
        	state = StateActChat.INPUT_SPEC;
        }
        String lastSpec = session.getLastTopic();
        String lastActivityType = (String) session.getLastActivityType();
        

        switch (state) {
            case INPUT_SPEC:
                if (userMsg != null && !userMsg.isBlank()) {
                    boolean isMeaningful = isSpecRelatedInput(userMsg);
                    String initMsg = """
    	    	            이곳은 활동 찾기 세션입니다.
    	    	            어떤 스펙(자격증/공모전 등) 에 대한 활동을 추천받고 싶으신가요?
    	    	            """;

    	    	        ChatMsg botMsg = new ChatMsg();
    	    	        botMsg.setConvId(session.getConvId());
    	    	        botMsg.setConvTopic(session.getTopic());
    	    	        botMsg.setConvSubTopicSpecId(session.getSubtopicId());
    	    	        botMsg.setUserId(session.getUserId());
    	    	        botMsg.setRole("BOT");
    	    	        botMsg.setMsgContent(initMsg);

    	    	        chatbotService.insertChatMsg(botMsg); 
                    
                    if(isMeaningful) {
                    	ChatMsg Umsg = new ChatMsg();
    	            	Umsg.setConvId(session.getConvId());
    	            	Umsg.setConvTopic(session.getTopic());
    	            	Umsg.setConvSubTopicSpecId(session.getSubtopicId()); // 필요 시 맞춰 수정
    	            	Umsg.setUserId(session.getUserId());
    	            	Umsg.setRole("USER");
    	            	Umsg.setMsgContent(userMsg);

    	            	chatbotService.insertChatMsg(Umsg);
    	            	
                    	session.setLastTopic(userMsg.trim());
                        session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                        
                        String answer = "'" + userMsg + "'에 대해 어떤 유형의 활동을 추천받으시겠어요?";
                      botChatMsg.setMsgContent(answer);
    					chatbotService.insertChatMsg(botChatMsg);
                        return new ChatbotResponseDto(
                            answer,
                            List.of("도서 추천", "영상 추천", "기타 활동 추천")
                        );
                    } else {
                    	session.setChatState(StateActChat.INPUT_SPEC);
                        return new ChatbotResponseDto(
                            "스펙 관련 입력이 아닌 것 같아요. 자격증, 분야, 기술 등과 관련된 주제로 다시 입력해 주세요."
                        );
                    }
                  } else {
                	  session.setChatState(StateActChat.INPUT_SPEC);
                      return new ChatbotResponseDto("빈 응답이 기록되었습니다. 다시 입력해 주세요.");
                  }
                	
                    
            case CHOOSE_ACTIVITY_TYPE:
                // 버튼 또는 텍스트 입력 모두 허용
            	ChatMsg Umsg = new ChatMsg();
            	Umsg.setConvId(session.getConvId());
            	Umsg.setConvTopic(session.getTopic());
            	Umsg.setConvSubTopicSpecId(session.getSubtopicId()); // 필요 시 맞춰 수정
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
                return recommendActivity(lastSpec, type, session);

            case RECOMMEND:
                // SHOW_MORE_OPTIONS로 자동 이동해서 버튼 선택받기
                session.setChatState(StateActChat.SHOW_MORE_OPTIONS);
                return new ChatbotResponseDto(
                    "더 추천받거나 다른 유형을 원하시면 아래 옵션을 선택하세요.",
                    List.of("다른 유형", "종료")
                );

            case SHOW_MORE_OPTIONS:
                if ("다른 유형".equals(userMsg)) {
	            	botChatMsg.setMsgContent("다른 유형 검색");
					chatbotService.insertChatMsg(botChatMsg);
                    session.setChatState(StateActChat.CHOOSE_ACTIVITY_TYPE);
                    return new ChatbotResponseDto(
                        "어떤 유형의 활동을 추천받으시겠어요?",
                        List.of("도서 추천", "영상 추천", "기타 활동 추천")
                    );
                } else if ("종료".equals(userMsg)) {
	            	botChatMsg.setMsgContent("종료");
					chatbotService.insertChatMsg(botChatMsg);
	            	botChatMsg.setMsgContent("이용해주셔서 감사합니다!");
					chatbotService.insertChatMsg(botChatMsg);
                    convManager.endSession(session.getUserId());   // 종료 누르면 바로 세션 삭제
                    return new ChatbotResponseDto("이용해주셔서 감사합니다!");
                } else {
                    return new ChatbotResponseDto(
                        "원하시는 옵션을 선택해 주세요.",
                        List.of("다른 유형", "종료")
                    );
                }
                
            default:
                session.setChatState(StateActChat.INPUT_SPEC);
                return new ChatbotResponseDto("오류가 발생했습니다. 처음부터 다시 시도해 주세요.");
        }
    }

	/** 활동 유형 및 스펙 기준으로 GPT에게 추천 받는 부분 (도서/영상/기타) */
	private ChatbotResponseDto recommendActivity(String spec, String activityType, ConvSession session) {
	    // 🔹 GPT 프롬프트 생성
	    String prompt = switch (activityType) {
	        case "도서" -> spec + " 학습에 도움 되는 추천 도서 3권만 한글로 알려줘. 도서명, 저자, 간단 설명만.";
	        case "영상" -> spec + " 공부에 추천할 만한 유튜브 채널이나 무료 강의 3개 추천해줘. 제목과 링크 포함해서.";
	        case "기타 활동" -> spec + " 실전 경험을 쌓을 수 있는 공모전, 대외활동, 봉사활동 3가지 추천해줘. 활동명과 URL 포함해서.";
	        default -> spec + "에 도움이 될 활동을 3개 추천해줘. 형식은 자유.";
	    };

	    // 🔹 GPT 호출
	    String gptAnswer = gptApiService.callGPT(prompt);
	    
	    ChatMsg botMsg = new ChatMsg();
	    botMsg.setConvId(session.getConvId());
	    botMsg.setConvTopic(session.getTopic());
	    botMsg.setConvSubTopicSpecId(session.getSubtopicId()); 
	    botMsg.setUserId(session.getUserId());
	    botMsg.setRole("BOT");
	    botMsg.setMsgContent(gptAnswer);
	    chatbotService.insertChatMsg(botMsg);
	    
	    

	    // 🔹 체크박스 항목 추출
	    List<CareerItemDto> checkboxList = extractCheckboxItems(gptAnswer);

	    // 🔹 최종 메시지 조합
	    StringBuilder finalMsg = new StringBuilder();

	    finalMsg.append("아래 추천된 항목 중 원하는 요소를 선택해 주세요!");

	    // 🔹 상태 전이
	    session.setChatState(StateActChat.SHOW_MORE_OPTIONS);

	    return new ChatbotResponseDto(
		        finalMsg.toString(),
		        checkboxList,
		        List.of("다른 유형", "종료")
		    );
	}


	private List<CareerItemDto> extractCheckboxItems(String gptAnswer) {
	    return Arrays.stream(gptAnswer.split("\n"))
	        .filter(line -> line.trim().matches("^\\d+\\..*"))  // 1. ~~ 형식만 필터링
	        .map(line -> {
	            String content = line.replaceAll("^\\d+\\.\\s*", ""); // 번호 제거
	            
	            CareerItemDto dto = new CareerItemDto();
	            dto.setTitle(content);          // 줄 전체를 title로 설정
	            dto.setExplain("");             // 필요 시 파싱해서 설명 넣을 수 있음
	            dto.setType("spec");            // 고정 타입 지정
	            return dto;
	        })
	        .collect(Collectors.toList());
	}
    
    // 추가됨 -- 대화 맥락 파악 후 이상한 대화 거절
    private boolean isSpecRelatedInput(String input) {
        String prompt = """
            다음 문장이 자격증, 직무, 공부, 기술 분야와 관련된 내용이면 '예', 관련 없으면 '아니오'로만 대답해 주세요.
            입력: "%s"
            """.formatted(input);

        String reply = gptApiService.callGPT(prompt);
        return reply != null && reply.trim().startsWith("예");
    }


}


