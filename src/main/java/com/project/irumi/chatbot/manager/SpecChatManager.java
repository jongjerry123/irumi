package com.project.irumi.chatbot.manager;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.api.SerpApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateSpecChat;
import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.chatbot.model.service.ChatbotService;
import com.project.irumi.dashboard.model.service.DashboardService;

@Component
public class SpecChatManager {

	@Autowired
	private GptApiService gptApiService;

	@Autowired
	private SerpApiService serpApiService;

	@Autowired
	private DashboardService dashboardService;
	
	@Autowired
	private ChatbotService chatbotService;

	private static final Logger logger = LoggerFactory.getLogger(SpecChatManager.class);
	public ChatbotResponseDto getGptResponse(ConvSession session, String userMsg) {
		StateSpecChat state = (StateSpecChat) session.getChatState();
		
		ChatMsg botChatMsg = new ChatMsg();
		ChatMsg userChatMsg = new ChatMsg();
		//MSG 저장시에 필요한 대화 세션 정보 세팅
		userChatMsg.setConvId(session.getConvId());
		botChatMsg.setConvId(session.getConvId());
		userChatMsg.setConvTopic(session.getTopic());
		botChatMsg.setConvTopic(session.getTopic());
		userChatMsg.setConvSubTopicJobId(session.getSubJobTopicId());
		botChatMsg.setConvSubTopicSpecId(session.getSubSpecTopicId());
		
		
		if (state == null) {
			state = StateSpecChat.TEXT_CURRENT_SPEC;
		}
		logger.info("spec chat state: " + state);
		String tempSpecType;

		switch (state) {
		case START:
			botChatMsg.setMsgContent(StateSpecChat.START.getPrompt());
			chatbotService.insertChatMsg(botChatMsg);
			
		case TEXT_CURRENT_SPEC:
			
			if ( isSpecRelatedInput(userMsg)) {
				session.addToContextHistory("유저가 현재 보유한 스펙: " + userMsg);
				session.setChatState(StateSpecChat.OPT_SPEC_TYPE);
				
				
				return new ChatbotResponseDto("어떤 종류의 스펙 추천을 받고 싶으신가요?",
						List.of("자격증", "어학", "인턴십", "대회/공모전", "자기계발", "기타"));
			} 
			else {
				session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
				return new ChatbotResponseDto(
						"잘못된 응답을 하셨습니다. 다시 입력해주세요. 내게 맞는 스펙 추천 세션입니다.\r\n" + "현재 보유하고 있는 스펙이나 경험을 말씀해 주세요.");
			}

		case OPT_SPEC_TYPE:
			tempSpecType = userMsg;
			session.addToContextHistory("유저가 관심 있는 스펙 타입: " + userMsg);

			// 유저 응답에 따라 관련 스펙 리스트 검색

			// 현재 타겟 직업은 job service에서 selectOneJob 개발시 설정
			// String targetJob = session.getSubtopicId();
			String targetJob = dashboardService.selectJob(session.getSubJobTopicId()).getJobName();
			String serpQuery = targetJob + "되기 위해 필요한 " + userMsg + "리스트";
			String serpResult = serpApiService.searchJobSpec(serpQuery);
			String gptAnswer = gptApiService.callGPT("""
					다음 정보를 참고하여 유저가 [%s] 직무에 지원할 때 이력으로 적으면 좋을 스펙 3개를 추천해 줘.
					아래와 같은 JSON 배열 형식으로만 응답해.
					다른 문장이나 설명은 절대 포함하지 마.
					각 스펙은 다음 속성을 포함해야 해:
					- title (스펙 이름)
					- explain (간단한 설명)

					예시:
					[
					  { "title": "정보처리기사", "explain": "정보 시스템과 소프트웨어 기초 역량을 평가하는 자격증" },
					  { "title": "포트폴리오 제작", "explain": "자기 주도적 프로젝트를 통해 실무 능력을 보여주는 활동" }
					]
					참고할 유저 정보: %s
					검색 참고 결과: %s
					""".formatted(targetJob, String.join(" ", session.getContextHistory()), serpResult));
			logger.info("받은 응답:" + gptAnswer);

			// ✅ JSON → CareerItemDto 리스트로 파싱
			// 사용자가 선택 가능하게 보내는 것.
			List<CareerItemDto> specCItemList = new ArrayList<>();
			try {
				JSONArray jsonArray = new JSONArray(gptAnswer);
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject obj = jsonArray.getJSONObject(i);
					CareerItemDto dto = new CareerItemDto();
					dto.setTitle(obj.getString("title"));
					dto.setExplain(obj.getString("explain"));
					dto.setType(tempSpecType);
					specCItemList.add(dto);
				}
				logger.info("specCIitemList:" + specCItemList);
			} catch (JSONException e) {
				e.printStackTrace();
				return new ChatbotResponseDto("스펙 추천 중 오류가 발생했습니다.", null);
			}
			session.setChatState(StateSpecChat.ASK_WANT_MORE_OPT);
			return new ChatbotResponseDto("추가로 더 추천받고 싶으신가요?", specCItemList, List.of("네", "아니요"));


		case ASK_WANT_MORE_OPT:
			//
			if ("네".equals(userMsg)) {
				session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC); // 루프 예시
				return new ChatbotResponseDto("그렇다면 다시 현재 보유한 스펙이나 경험을 말해주세요", null);
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
				사용자가 없다고 대답하면 '예'라고 대답하세요. 
				입력: "%s"
				""".formatted(input);

		String reply = gptApiService.callGPT(prompt);
		return reply != null && reply.trim().startsWith("예");
	}
}
