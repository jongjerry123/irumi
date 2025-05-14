package com.project.irumi.chatbot.manager;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.api.SerpApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.context.StateSsChat;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.chatbot.model.service.ChatbotService;

@Component
public class SsChatManager {

	@Autowired
	private SerpApiService serpApiService;
	
	@Autowired
	private GptApiService gptApiService;
	
	@Autowired
	private ConvSessionManager convManager;
	
	@Autowired
	private ChatbotService chatbotService;
	
	private static final Logger logger = LoggerFactory.getLogger(JobChatManager.class);

	
//	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
//		// TODO Auto-generated method stub
//		return null;
//	}
	
	public ChatbotResponseDto handleChatMessage(ConvSession session, String userMsg) {

		ChatMsg botChatMsg = new ChatMsg();

		// 보내온 유저의 메세지 tb에 저장
		ChatMsg userChatMsg = new ChatMsg();
		userChatMsg.setConvId(session.getConvId());
		botChatMsg.setConvId(session.getConvId());
		userChatMsg.setConvTopic(session.getTopic());
		botChatMsg.setConvTopic(session.getTopic());
		switch (session.getTopic()) {
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

		
	    StateSsChat state = (StateSsChat) session.getChatState();
	    if (state == null) {
	    	session.setChatState(StateSsChat.SERP_SEARCH); 
	    }

	    switch (state) {

	        case SERP_SEARCH:
	        	
	            if (userMsg != null && !userMsg.isBlank()) {
	            boolean isMeaningful = isSpecRelatedInput(userMsg);
	            
	            String initMsg = """
	    	            이곳은 일정 찾기 세션입니다.
	    	            어떤 일정이 궁금하신가요? 알고 싶으신 일정의 명칭을 입력해주세요!
	    	            (예: oooo기사 시험 일정, xxx 공모전 일정, &&& 인턴십 일정)
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
	            	// SerpAPI 호출
	            	ChatMsg Umsg = new ChatMsg();
	            	Umsg.setConvId(session.getConvId());
	            	Umsg.setConvTopic(session.getTopic());
	            	Umsg.setConvSubTopicSpecId(session.getSubSpecTopicId()); // 필요 시 맞춰 수정
	            	Umsg.setUserId(session.getUserId());
	            	Umsg.setRole("USER");
	            	Umsg.setMsgContent(userMsg);

	            	chatbotService.insertChatMsg(Umsg);

	           	            	
	                String serpResult = serpApiService.searchExamSchedule(userMsg);
	                ChatMsg serpMsg = new ChatMsg();
	                
	                serpMsg.setConvId(session.getConvId());
	                serpMsg.setConvTopic(session.getTopic());
	                serpMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
	                serpMsg.setUserId(session.getUserId());
	                serpMsg.setRole("BOT");
	                serpMsg.setMsgContent(serpResult);

	                chatbotService.insertChatMsg(serpMsg);
	                
	                session.setChatState(StateSsChat.ASK_WANT_MORE);
	                return new ChatbotResponseDto(
	                    serpResult,
	                    List.of("다른 일정 검색", "종료")
	                );
	            } else {
	            	session.setChatState(StateSsChat.SERP_SEARCH);
	            	return new ChatbotResponseDto("잘못된 응답을 하셨습니다. 알고 싶으신 일정의 명칭을 입력해주세요! (예 :  oooo기사 시험 일정, xxx 공모전 일정, &&& 인턴십 일정)");
	            }
	            	
	            } else {
	            	session.setChatState(StateSsChat.SERP_SEARCH);
	                return new ChatbotResponseDto("일정명을 다시 입력해주세요.");
	            }

	        case ASK_WANT_MORE:
	            if ("다른 일정 검색".equals(userMsg)) {
	            	botChatMsg.setMsgContent("다른 일정 검색");
					chatbotService.insertChatMsg(botChatMsg);
	                session.setChatState(StateSsChat.SERP_SEARCH);
	                botChatMsg.setMsgContent("어떤 일정이 궁금하신가요? (예: oooo기사 시험 일정, xxx 공모전 일정, &&& 인턴십 일정)");
					chatbotService.insertChatMsg(botChatMsg);
	                return new ChatbotResponseDto("어떤 일정이 궁금하신가요? 알고 싶으신 일정의 명칭을 입력해주세요! (예: oooo기사 시험 일정, xxx 공모전 일정, &&& 인턴십 일정)");
	            } else {
	            	botChatMsg.setMsgContent("종료");
					chatbotService.insertChatMsg(botChatMsg);
	            	botChatMsg.setMsgContent("이용해주셔서 감사합니다!");
					chatbotService.insertChatMsg(botChatMsg);
	            	convManager.endSession(session.getUserId());
	                return new ChatbotResponseDto("이용해주셔서 감사합니다!");
	            }
	        
	        default:
	            session.setChatState(StateSsChat.SERP_SEARCH);
	            return new ChatbotResponseDto("처음부터 다시 진행할게요!");
	    }
	}

	// 추가됨 -- 대화 맥락 파악 후 이상한 대화 거절
	private boolean isSpecRelatedInput(String input) {
        String prompt = """
        		입력 문장이 자격증, 시험, 공모전, 인턴십 등의 '스펙'에 대한 일정에 관련된 내용인지 판별하세요.
        		반드시 '예' 또는 '아니오' 중 하나만 출력하세요. 다른 설명은 하지 마세요.

        		입력: "%s"
            """.formatted(input);

        String reply = gptApiService.callGPT(prompt);
        return reply != null && reply.trim().startsWith("예");
    }
    

}


