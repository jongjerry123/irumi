package com.project.irumi.chatbot.manager;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
import com.project.irumi.chatbot.model.dto.CareerItemDTO;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDTO;
import com.project.irumi.chatbot.model.service.ChatbotService;
import com.project.irumi.dashboard.model.service.DashboardService;
import com.project.irumi.user.model.dto.User;

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

	public ChatbotResponseDTO getGptResponse(ConvSession session, String userMsg) {
		StateSpecChat state = (StateSpecChat) session.getChatState();

		ChatMsg botChatMsg = new ChatMsg(session.getUserId(), session.getConvId(), session.getTopic(),
				session.getSubJobTopicId(), "BOT");
		ChatMsg userChatMsg = new ChatMsg(session.getUserId(), session.getConvId(), session.getTopic(),
				session.getSubJobTopicId(), "USER");

		if (state == null) {
			state = StateSpecChat.TEXT_CURRENT_SPEC;
		}
		logger.info("spec chat state: " + state);
		String tempSpecType;
		
				
		switch (state) {
		case START:
			// 유저가 현재 자신의 성격/ 가치관 입력하게 하는 첫 prompt 저장
			botChatMsg.setMsgContent(StateSpecChat.START.getPrompt());
			chatbotService.insertChatMsg(botChatMsg);
			userChatMsg.setMsgContent(userMsg);
			chatbotService.insertChatMsg(userChatMsg);

			// 다음 상태로 이동해 봇 메세지 출력 및 저장
			session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);
			botChatMsg.setMsgContent(StateSpecChat.TEXT_CURRENT_SPEC.getPrompt());
			chatbotService.insertChatMsg(botChatMsg);
			return new ChatbotResponseDTO(StateSpecChat.TEXT_CURRENT_SPEC.getPrompt());

		case TEXT_CURRENT_SPEC:
			// 사용자가 current spec을 입력한 이후.
			// 유저 메세지 저장
			userChatMsg.setMsgContent(userMsg);
			chatbotService.insertChatMsg(userChatMsg);

			// 제대로 된 현재 스펙을 입력한 경우
			if (isSpecRelatedInput(userMsg)) {
				session.addToContextHistory("유저가 현재 보유한 스펙: " + userMsg);
				// 상태를 다음으로 이동해 메세지 출력 및 저장
				session.setChatState(StateSpecChat.OPT_SPEC_TYPE);
				botChatMsg.setMsgContent(StateSpecChat.OPT_SPEC_TYPE.getPrompt());
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDTO(StateSpecChat.OPT_SPEC_TYPE.getPrompt(),
						List.of("어학 능력", "자격증", "인턴십 및 현장실습", "대외 활동", "연구 활동", "기타"));
			}
			// 제대로 된 현재스펙 입력하지 않은 경우, 같은 케이스 반복
			else {
				session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC);

				botChatMsg.setMsgContent(StateSpecChat.TEXT_CURRENT_SPEC.getFallBackPrompt());
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDTO(StateSpecChat.TEXT_CURRENT_SPEC.getFallBackPrompt());
			}

		case OPT_SPEC_TYPE:
			// 유저가 원하는 스펙 타입 선택한 경우
			// 유저 응답 DB 저장
			userChatMsg.setMsgContent(userMsg);
			tempSpecType = userMsg;
			session.addToContextHistory("유저가 관심 있는 스펙 타입: " + userMsg);
			chatbotService.insertChatMsg(userChatMsg);

			// 유저가 원하는 스펙 타입에 따라 추천 리스트 전달.
			String targetJobName = dashboardService.selectJob(session.getSubJobTopicId()).getJobName();
			String serpQuery = targetJobName + "되기 위해 필요한 추천" + userMsg + " 리스트";
			String serpResult = serpApiService.searchJobSpec(serpQuery);
			String userSpecInfo = dashboardService.selectUserSpec(session.getUserId()).toString();
			String gptAnswer = gptApiService.callGPT("""
					다음 정보를 참고하여 유저가 [%s] 직무에 지원할 때 이력으로 적으면 좋을 스펙 3개를 추천해 줘.
					아래와 같은 JSON 배열 형식으로만 응답해.
					응답해야 하는 형태 - 
					[
					  { "title": "정보처리기사", "explain": "정보 시스템과 소프트웨어 기초 역량을 평가하는 자격증" },
					  { "title": "포트폴리오 제작", "explain": "자기 주도적 프로젝트를 통해 실무 능력을 보여주는 활동" }
					]
					(중요)다른 문장이나 설명은 절대 포함하지 말고, [로 시작해서 ]로 끝나는 완벽한 json 형태로 대답해.
					각 스펙은 다음 속성을 포함해야 해:
					- title (스펙 이름)
					- explain (간단한 설명과 필요한 능력 또는 지식 소개)

					예시:
					[
					  { "title": "정보처리기사", "explain": "정보 시스템과 소프트웨어 기초 역량을 평가하는 자격증" },
					  { "title": "포트폴리오 제작", "explain": "자기 주도적 프로젝트를 통해 실무 능력을 보여주는 활동" }
					]
					다음과 같은 특성을 가진 유저에게 적합한 스펙으로 3개 추천해야 해.
					유저의 특성: %s
					
					검색 결과를 참고해서 실제로 존재하는 구체적인 것들로만 추천해 줘. (ex.환경 관련 인턴십 <- 구체적이지 않음)
					
					이외 유저의 학력 상태는 다음과 같음: %s
					추천에 다음 결과를 참고할 수 있음: %s
					""".formatted(targetJobName, String.join(" ", session.getContextHistory())
											,userSpecInfo, serpResult));
			logger.info("받은 응답:" + gptAnswer);
			
			//gpt 응답에서 json만 분리하기
			Pattern pattern = Pattern.compile("\\[.*?\\]", Pattern.DOTALL);
	        Matcher matcher = pattern.matcher(gptAnswer);
	        String gptJSON=null;
	        if (matcher.find()) {
	            gptJSON = matcher.group();
	         
	        } else {
	            System.out.println("JSON 형식의 배열이 없습니다.");
	            return new ChatbotResponseDTO("스펙 정보 추출하지 못함", null);
	        }

			// ✅ JSON → CareerItemDto 리스트로 파싱
			// 사용자가 선택 가능하게 보내는 것.
			List<CareerItemDTO> specCItemList = new ArrayList<>();
			try {
				JSONArray jsonArray = new JSONArray(gptJSON);
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject obj = jsonArray.getJSONObject(i);
					CareerItemDTO dto = new CareerItemDTO();
					dto.setTitle(obj.getString("title"));
					dto.setExplain(obj.getString("explain"));
					dto.setType(tempSpecType);
					specCItemList.add(dto);
				}
				logger.info("specCIitemList:" + specCItemList);
			} catch (JSONException e) {
				e.printStackTrace();
				return new ChatbotResponseDTO("스펙 추천 중 오류가 발생했습니다.", null);
			}

			// 다음 상태로 전환, 봇 메세지 미리 저장
			session.setChatState(StateSpecChat.ASK_WANT_MORE_OPT);
			botChatMsg.setMsgContent(StateSpecChat.ASK_WANT_MORE_OPT.getPrompt());
			chatbotService.insertChatMsg(botChatMsg);
			return new ChatbotResponseDTO(StateSpecChat.ASK_WANT_MORE_OPT.getPrompt(),
					 specCItemList, List.of("네", "아니요"));


		case ASK_WANT_MORE_OPT:
			//더 추천받을지 여부 입력한 경우
			// 사용자 입력 tb 저장
			userChatMsg.setMsgContent(userMsg);
			chatbotService.insertChatMsg(userChatMsg);
			
			if ("네".equals(userMsg)) {
				session.setChatState(StateSpecChat.TEXT_CURRENT_SPEC); // 루프 예시
				botChatMsg.setMsgContent("그렇다면 다시 "+ StateSpecChat.TEXT_CURRENT_SPEC.getPrompt());
				chatbotService.insertChatMsg(botChatMsg);
				
				return new ChatbotResponseDTO("그렇다면 다시 "+ StateSpecChat.TEXT_CURRENT_SPEC.getPrompt(), null);
			}
			else {
				session.setChatState(StateSpecChat.COMPLETE);
				
				botChatMsg.setMsgContent(StateSpecChat.COMPLETE.getPrompt());
				chatbotService.insertChatMsg(botChatMsg);
				return new ChatbotResponseDTO(StateSpecChat.COMPLETE.getPrompt(), null);
			}

		case COMPLETE:
			session.setChatState(StateSpecChat.START); // 여기 오류 가능성
			return new ChatbotResponseDTO("대화가 완료되었습니다. 추가로 필요한 것이 있으면 새로 시작해주세요.", null);

		default:
			session.setChatState(StateSpecChat.START);
			return new ChatbotResponseDTO("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
		}
	}


	private boolean isSpecRelatedInput(String input) {
		String prompt = """
				입력 내용이 사용자가 실제로 보유하고 있을 수 있는 스펙이나 경험(예: 어학 능력, 자격증, 인턴십 및 현장실습, 대외활동, 연구활동 등)에 해당하면 '예', 그렇지 않으면 '아니오'라고만 답하세요.
				다른 설명은 하지 마세요.
				사용자가 없다고 대답하거나 모른다고 대답하면 '예'라고 대답하세요.
				입력: "%s"
				""".formatted(input);

		String reply = gptApiService.callGPT(prompt);
		return reply != null && reply.trim().startsWith("예");
	}

}
