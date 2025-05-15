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
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.StateJobChat;
import com.project.irumi.chatbot.model.dto.CareerItemDTO;
import com.project.irumi.chatbot.model.dto.ChatMsg;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDTO;
import com.project.irumi.chatbot.model.service.ChatbotService;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.service.DashboardService;

@Component
public class JobChatManager {
	@Autowired
	private GptApiService gptApiService;

//	@Autowired
//	private ChatbotService chatbotService;
	
	@Autowired
	private DashboardService dashboardService;

	private static final Logger logger = LoggerFactory.getLogger(JobChatManager.class);

	public ChatbotResponseDTO getGptResponse(ConvSession session, String userMsg) {


		StateJobChat state = (StateJobChat) session.getChatState();
		if (state == null)
			state = StateJobChat.ASK_PERSONALITY;
		logger.info("job chat state: " + state);

		switch (state) {
		// 성격 정보를 저장.
		case START:
			// chatbotService로 챗봇의 첫 chatMsg 저장
//			botChatMsg.setMsgContent("내게 맞는 직무 찾기 세션입니다.\r\n" + "먼저, 희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요.");
//			chatbotService.insertChatMsg(botChatMsg);
		case ASK_PERSONALITY:

			boolean isMeaningful = isPersonaliltyRelatedInput(userMsg);
			if (isMeaningful) {
				session.addToContextHistory("유저는 자신에 대해 다음과 같이 설명함: " + userMsg);
				session.setChatState(StateJobChat.ASK_JOB_CHARACTERISTIC);
				return new ChatbotResponseDTO("희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요.", null);
			} else {
				session.setChatState(StateJobChat.ASK_PERSONALITY);
				return new ChatbotResponseDTO("잘못된 응답을 하셨습니다. 다시 입력해주세요. 내게 맞는 직무 찾기 세션입니다.\r\n"
						+ "희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요.");
			}

		case ASK_JOB_CHARACTERISTIC:
			isMeaningful = isHopeJobRelatedInput(userMsg);
			if (isMeaningful) {
				session.addToContextHistory("유저가 원하는 희망 직무의 특성은 다음과 같음: " + userMsg);
				session.setChatState(StateJobChat.ASK_WORK_CHARACTERISTIC);
				return new ChatbotResponseDTO("희망하는 업계가 있다면 알려 주세요.(예: IT, 부동산, 연예계 등)", null);
			} 
			else {
				session.setChatState(StateJobChat.ASK_JOB_CHARACTERISTIC);
				return new ChatbotResponseDTO("잘못된 응답을 하셨습니다. 다시 입력해주세요.\r\n" + "희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요.");
			}

		case ASK_WORK_CHARACTERISTIC:
			isMeaningful = isHopeIndustryRelatedInput(userMsg);
			if (isMeaningful) {
				session.addToContextHistory("유저는 다음과 같은 업계를 선호함: " + userMsg);
				ArrayList<Job> userJobs = dashboardService.selectUserJobs(session.getUserId());
				String userJobStr="";
				for (Job job: userJobs) {
					userJobStr+=job.getJobName();
					userJobStr+="/ ";
				}
				if (userJobStr.endsWith("/ ")) {
				    userJobStr = userJobStr.substring(0, userJobStr.length() - 2);  // 마지막 "/ " 제거
				}

				String gptAnswer = gptApiService.callGPT("""
					    다음 정보는 사용자가 원하는 직무 특성, 성격, 가치관, 선호하는 업무 환경 등을 담고 있는 매우 중요한 기준입니다.
					    이 정보를 최우선으로 고려하여, 가장 잘 맞는 직무를 3개 추천해 주세요.

					    단, 반드시 아래 형식의 JSON 배열로만 응답하세요. 숫자, 설명, 다른 텍스트는 절대 포함하지 마세요.
					    각 직무는 다음과 같은 속성을 가져야 합니다:
					    - jobName (직무 이름)
					    - jobExplain (간단한 설명)

					    예시 형식:
					    [
					      {
					        "jobName": "데이터 분석가",
					        "jobExplain": "데이터 기반 의사결정을 지원하는 직무"
					      },
					      {
					        "jobName": "프론트엔드 개발자",
					        "jobExplain": "사용자 인터페이스를 개발하는 직무"
					      },
					      {
					        "jobName": "AI 엔지니어",
					        "jobExplain": "머신러닝 기반 시스템을 개발하는 직무"
					      }
					    ]

					    절대 다른 설명을 덧붙이지 말고, JSON 배열만 반환하세요.
					    🔽 다음과 같은 특성을 가진 유저에게 적합한 직무를 3가지 찾아 반환하세요. %s
					    
					    다음 리스트에서 너무 비슷하거나 동일한 것은 제외하여 3개 추천하세요. %s
					    """.formatted(String.join(" ", session.getContextHistory()),
					    							userJobStr/*이미 저장된 직무 리스트*/));

				logger.info("gpt 응답?:" + gptAnswer);

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
				
				// GPT 응답을 CareerItem DTO 리스트로 변환
				List<CareerItemDTO> jobCIList = new ArrayList<>();
				try {
					// GPT 응답을 JSON 배열로 파싱
					JSONArray jsonArray = new JSONArray(gptJSON);

					// JSON 배열에서 각 객체를 Job 객체로 변환
					for (int i = 0; i < jsonArray.length(); i++) {
						JSONObject jobJson = jsonArray.getJSONObject(i);
						String jobName = jobJson.getString("jobName");
						String jobExplain = jobJson.getString("jobExplain");

						CareerItemDTO careerItem = new CareerItemDTO();
						careerItem.setTitle(jobName);
						careerItem.setExplain(jobExplain);
						careerItem.setType("job");
						jobCIList.add(careerItem);
					}

				} catch (JSONException e) {
					e.printStackTrace(); // JSON 파싱 오류 처리
					return new ChatbotResponseDTO("직무 추천 처리 중 오류가 발생했습니다.", null);
				}

				// 추천하는 직무를 선택하는 체크박스 리스트 보여주기
				session.setChatState(StateJobChat.ASK_WANT_MORE_OPT);
				return new ChatbotResponseDTO("더 많은 추천을 받아보고 싶으신가요?", jobCIList, List.of("네", "아니요"));
			} else {
				session.setChatState(StateJobChat.ASK_WORK_CHARACTERISTIC);
				return new ChatbotResponseDTO(
						"잘못된 응답을 하셨습니다. 다시 입력해주세요.\r\n" + "희망하는 업계가 있다면 알려 주세요.(예: IT, 부동산, 연예계 등)");
			}

		case ASK_WANT_MORE_OPT:
			if ("네".equals(userMsg)) {
				session.setChatState(StateJobChat.REC_TYPE);
				return new ChatbotResponseDTO(StateJobChat.REC_TYPE.getPrompt() , List.of("이어서 추천받기", "내 정보 더 입력하기"));
			} else {
				session.setChatState(StateJobChat.COMPLETE);
				return new ChatbotResponseDTO("추천을 마쳤습니다. 도움이 되었기를 바랍니다!", null);
			}
		case REC_TYPE:
			if ("이어서 추천받기".equals(userMsg)) {
				// 여기서 바로 gpt 응답 받아 리턴
				ArrayList<Job> userJobs = dashboardService.selectUserJobs(session.getUserId());
				String userJobStr="";
				for (Job job: userJobs) {
					userJobStr+=job.getJobName();
					userJobStr+="/ ";
				}
				if (userJobStr.endsWith("/ ")) {
				    userJobStr = userJobStr.substring(0, userJobStr.length() - 2);  // 마지막 "/ " 제거
				}

				String gptAnswer = gptApiService.callGPT("""
					    다음 정보는 사용자가 원하는 직무 특성, 성격, 가치관, 선호하는 업무 환경 등을 담고 있는 매우 중요한 기준입니다.
					    이 정보를 최우선으로 고려하여, 가장 잘 맞는 직무를 3개 추천해 주세요.

					    단, 반드시 아래 형식의 JSON 배열로만 응답하세요. 숫자, 설명, 다른 텍스트는 절대 포함하지 마세요.
					    각 직무는 다음과 같은 속성을 가져야 합니다:
					    - jobName (직무 이름)
					    - jobExplain (간단한 설명)

					    예시 형식:
					    [
					      {
					        "jobName": "데이터 분석가",
					        "jobExplain": "데이터 기반 의사결정을 지원하는 직무"
					      },
					      {
					        "jobName": "프론트엔드 개발자",
					        "jobExplain": "사용자 인터페이스를 개발하는 직무"
					      },
					      {
					        "jobName": "AI 엔지니어",
					        "jobExplain": "머신러닝 기반 시스템을 개발하는 직무"
					      }
					    ]

					    절대 다른 설명을 덧붙이지 말고, JSON 배열만 반환하세요.
					    🔽 다음과 같은 특성을 가진 유저에게 적합한 직무를 3가지 찾아 반환하세요. %s
					    
					    다음 리스트에서 너무 비슷하거나 동일한 것은 제외하여 3개 추천하세요. %s
					    """.formatted(String.join(" ", session.getContextHistory()),
					    							userJobStr/*이미 저장된 직무 리스트*/));

				logger.info("gpt 응답?:" + gptAnswer);

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
				
				// GPT 응답을 CareerItem DTO 리스트로 변환
				List<CareerItemDTO> jobCIList = new ArrayList<>();
				try {
					// GPT 응답을 JSON 배열로 파싱
					JSONArray jsonArray = new JSONArray(gptJSON);

					// JSON 배열에서 각 객체를 Job 객체로 변환
					for (int i = 0; i < jsonArray.length(); i++) {
						JSONObject jobJson = jsonArray.getJSONObject(i);
						String jobName = jobJson.getString("jobName");
						String jobExplain = jobJson.getString("jobExplain");

						CareerItemDTO careerItem = new CareerItemDTO();
						careerItem.setTitle(jobName);
						careerItem.setExplain(jobExplain);
						careerItem.setType("job");
						jobCIList.add(careerItem);
					}

				} catch (JSONException e) {
					e.printStackTrace(); // JSON 파싱 오류 처리
					return new ChatbotResponseDTO("직무 추천 처리 중 오류가 발생했습니다.", null);
				}

				// 추천하는 직무를 선택하는 체크박스 리스트 보여주기
				session.setChatState(StateJobChat.ASK_WANT_MORE_OPT);
				return new ChatbotResponseDTO("더 많은 추천을 받아보고 싶으신가요?", jobCIList, List.of("네", "아니요"));
			

				
			}
			// 정보 입력으로 이동
			else {
				// 성격부터 다시 물어봄
				session.setChatState(StateJobChat.ASK_PERSONALITY);
				return new ChatbotResponseDTO("그럼 다시  희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요", null);
			}
			

		case COMPLETE:
			session.setChatState(StateJobChat.ASK_PERSONALITY);
			return new ChatbotResponseDTO("대화가 완료되었습니다.", null);

		default:
			session.setChatState(StateJobChat.ASK_PERSONALITY);
			return new ChatbotResponseDTO("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.", null);
		}
	}



	// 추가됨 -- 대화 맥락 파악 후 이상한 대화 거절
	private boolean isPersonaliltyRelatedInput(String input) {
		String prompt = """
				입력 문장이 사람의 특성(예: 성격, 강점, 가치관, 잘하는 거나 못하는 것)이 될 수 있는 것이면 '예', 아니면 '아니오'라고만 답하세요.
				설명 없이 반드시 '예' 또는 '아니오'로만 대답하세요.

				입력: 나의 특성 -  "%s"
				""".formatted(input);

		String reply = gptApiService.callGPT(prompt);
		return reply != null && reply.trim().startsWith("예");
	}

	private boolean isHopeJobRelatedInput(String input) {
		String prompt = """
				입력 문장이 직무의 특성(예: 연봉, 문화, 업무 방식 등)에 대한 것인지 판단하여,
				오직 '예' 또는 '아니오'로만 대답하세요.
				사용자가 없다고 대답하거나 모른다고 대답하면 '예'라고 대답하세요.
				사용자가 아무거나, 또는 상관없다고 대답해도 '예'라고 대답하세요.

				입력: "%s"
				""".formatted(input);

		String reply = gptApiService.callGPT(prompt);
		return reply != null && reply.trim().startsWith("예");
	}

	private boolean isHopeIndustryRelatedInput(String input) {
		String prompt = """
				입력 문장이 업계의 유형(예: IT, 부동산, 연예계 등)에 관한 내용인지 판단하여,
				오직 '예'또는 '아니오'로만 대답하세요.
				관련이 있으면 '예', 관련이 없으면 '아니오'라고만 대답하세요.
				사용자가 없다고 대답하거나 모른다고 대답하면 '예'라고 대답하세요.
				사용자가 아무거나, 또는 상관없다고 대답해도 '예'라고 대답하세요.

				입력: "%s"
				""".formatted(input);

		String reply = gptApiService.callGPT(prompt);
		return reply != null && reply.trim().startsWith("예");
	}
}