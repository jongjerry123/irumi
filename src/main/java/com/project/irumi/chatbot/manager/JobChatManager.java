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
import com.project.irumi.chatbot.context.StateJobChat;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.chatbot.model.service.ChatbotService;

@Component
public class JobChatManager {
	@Autowired
	private GptApiService gptApiService;
	
	@Autowired
	private ChatbotService chatbotService;
	
	private static final Logger logger = LoggerFactory.getLogger(JobChatManager.class);
	
	public ChatbotResponseDto getGptResponse(ConvSession session, String userMsg) {
		ChatMsg botChatMsg = new ChatMsg();
		
		//보내온 유저의 메세지 tb에 저장
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
		
		chatbotService.insertChatMsg(userChatMsg);
		 
		
		StateJobChat state = (StateJobChat) session.getChatState();
		if (state == null) state = StateJobChat.ASK_PERSONALITY;
		logger.info("job chat state: "+ state);
	
		switch (state) {
				// 성격 정보를 저장.
		case START:
				// chatbotService로 챗봇의 첫 chatMsg 저장
				botChatMsg.setMsgContent("내게 맞는 직무 찾기 세션입니다.\r\n"
						+ "먼저, 희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요.");
				chatbotService.insertChatMsg(botChatMsg);
		case ASK_PERSONALITY:
				session.addToContextHistory("유저는 자신에 대해 다음과 같이 설명함: "+userMsg);
				session.setChatState(StateJobChat.ASK_JOB_CHARACTERISTIC);
				
				botChatMsg.setMsgContent("희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요.");
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDto("희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요.", null);

			case ASK_JOB_CHARACTERISTIC:
				session.addToContextHistory("유저가 원하는 희망 직무의 특성은 다음과 같음: "+userMsg);
				session.setChatState(StateJobChat.ASK_WORK_CHARACTERISTIC);
				
				botChatMsg.setMsgContent("희망하는 업계가 있다면 알려 주세요.(예: IT, 부동산, 연예계 등)");
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDto("희망하는 업계가 있다면 알려 주세요.(예: IT, 부동산, 연예계 등)", null);
			
			case ASK_WORK_CHARACTERISTIC:
				session.addToContextHistory("유저는 다음과 같은 업계를 선호함: "+userMsg);
				
                String gptAnswer = gptApiService.callGPT("다음 정보를 참고하여 유저에게 추천할 만한 직무들을 3개 추천해 줘. 한 줄에 1개씩 출력해줘."+
                																				String.join(" ", session.getContextHistory()));
                List<String> jobList = Arrays.stream(gptAnswer.split("\n"))
                        .map(s -> s.replaceAll("^\\d+\\.\\s*", "")) // 번호 제거
                        .collect(Collectors.toList());
                
                session.setChatState(StateJobChat.ASK_WANT_MORE_OPT);
                
                botChatMsg.setMsgContent("더 많은 추천을 받아보고 싶으신가요?");
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDto("더 많은 추천을 받아보고 싶으신가요?", 
						jobList, List.of("네", "아니요"));

			case ASK_WANT_MORE_OPT:
				if ("네".equals(userMsg)) {
					session.setChatState(StateJobChat.ASK_PERSONALITY); // 루프 예시
					
					 botChatMsg.setMsgContent("그럼 다시  희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요\",");
						chatbotService.insertChatMsg(botChatMsg);
					return new ChatbotResponseDto("그럼 다시  희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요", null);
				} else {
					session.setChatState(StateJobChat.COMPLETE);
					// db에 job 저장하기
					
					 botChatMsg.setMsgContent("추천을 마쳤습니다. 도움이 되었기를 바랍니다!");
						chatbotService.insertChatMsg(botChatMsg);
					return new ChatbotResponseDto("추천을 마쳤습니다. 도움이 되었기를 바랍니다!", null);
				}

			case COMPLETE:
				 session.setChatState(StateJobChat.ASK_PERSONALITY);
				 
				 botChatMsg.setMsgContent("대화가 완료되었습니다.");
					chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDto("대화가 완료되었습니다.", null);

			default:
				 session.setChatState(StateJobChat.ASK_PERSONALITY);
				 
				 botChatMsg.setMsgContent("알 수 없는 상태입니다. 처음부터 다시 시도해주세요");
					chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDto("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
		}
	}

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// 아직 옵션 클릭 처리 미구현
		return new ChatbotResponseDto("선택하신 직무 옵션에 대한 처리를 진행합니다. (아직 미구현)", null);
	}
}