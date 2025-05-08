package com.project.irumi.chatbot.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.manager.ActChatManager;
import com.project.irumi.chatbot.manager.JobChatManager;
import com.project.irumi.chatbot.manager.SpecChatManager;
import com.project.irumi.chatbot.manager.SsChatManager;
import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;
import com.project.irumi.chatbot.model.dto.SessionTopicOpts;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.SpecSchedule;
import com.project.irumi.dashboard.model.dto.Specific;
import com.project.irumi.dashboard.model.service.DashboardService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class ChatbotController {

	@Autowired
	private ConvSessionManager convManager;
	private static final Logger logger = LoggerFactory.getLogger(ChatbotController.class);

	// 추가
	@Autowired
	private ConvSessionManager convSessionManager;

	// 추가
	@Autowired
	private GptApiService gptApiService;

	@Autowired
	private DashboardService dashboardService;

	@Autowired
	private JobChatManager jobManager;
	@Autowired
	private SpecChatManager specManager;
	@Autowired
	private SsChatManager ssManager;
	@Autowired
	private ActChatManager actManager;

	// 탭별로 뷰페이지 내보내기 용도 ===========================
	@RequestMapping("viewActRecChat.do")
	public String ViewActChatBot() {
		return "chatbot/act";
	}

	@RequestMapping("viewJobRecChat.do")
	public String ViewJobChatBot() {
		return "chatbot/job";
	}

	@RequestMapping("viewSpecRecChat.do")
	public String ViewSpecChatBot() {
		return "chatbot/spec";
	}

	@RequestMapping("viewScheduleRecChat.do")
	public String ViewScheduleChatBot() {
		return "chatbot/schedule";
	}

	// 유저가 탭 보여주는 경우 ===========================
	// 세션매니저 관리 시작 (tab 유형에 따라 현재 로그인한 유저가 진행중인 session 정보)
	@RequestMapping(value = "startChatSession.do", method = RequestMethod.POST)
	@ResponseBody
	public SessionTopicOpts startChatSession(@RequestParam("topic") String topic, HttpSession loginSession) {

		// 로그인 세션에서 현 유저 받아옴.
		User loginUser = (User) loginSession.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";
		// 챗봇 세션 생성
		ConvSession session = convManager.createNewSession(userId, topic);

		SessionTopicOpts sessionTopicOpts = new SessionTopicOpts();

		// 직무/ 스펙 원본 리스트
		ArrayList<Job> userJobs;
		ArrayList<Spec> userSpecs;
		ArrayList<SpecSchedule> userSchedules;
		ArrayList<Activity> userActs;

		// CareerItemDto 리스트로 변환하여 저장
		List<CareerItemDto> jobCItemList = new ArrayList<>();
		List<CareerItemDto> specCItemList = new ArrayList<>();
		List<CareerItemDto> scheduleCItemList = new ArrayList<>();
		List<CareerItemDto> activityCItemList = new ArrayList<>();

		switch (topic) {
		case "job":
			userJobs = dashboardService.selectUserJobs(userId);
			for (Job job : userJobs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(job.getJobId());
				dto.setTitle(job.getJobName());
				dto.setExplain(job.getJobExplain());
				dto.setType("job");
				jobCItemList.add(dto);
			}
			sessionTopicOpts.setJobList(jobCItemList); // 변환된 리스트 사용
			break;
		case "spec":
			userJobs = dashboardService.selectUserJobs(userId);
			for (Job job : userJobs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(job.getJobId());
				dto.setTitle(job.getJobName());
				dto.setExplain(job.getJobExplain());
				dto.setType("job");
				jobCItemList.add(dto);
			}
			sessionTopicOpts.setJobList(jobCItemList); // 변환된 리스트 사용
			break;

		case "ss":
			// job setting
			userJobs = dashboardService.selectUserJobs(userId);
			userSpecs = dashboardService.selectCurrUserSpec(userId);
			for (Job job : userJobs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(job.getJobId());
				dto.setTitle(job.getJobName());
				dto.setExplain(job.getJobExplain());
				dto.setType("job");
				jobCItemList.add(dto);
			}
			// spec setting
			for (Spec spec : userSpecs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(spec.getSpecId());
				dto.setTitle(spec.getSpecName());
				dto.setExplain(spec.getSpecExplain());
				dto.setType("spec");
				specCItemList.add(dto);
			}
			sessionTopicOpts.setJobList(jobCItemList); // 변환된 리스트 사용

			// 유저 직무 선택에 따라 sub 주제 세팅
			// userSpecs = dashboardService.selectUserSpecs(...);
			break;

		case "act":
			// job setting
			userJobs = dashboardService.selectUserJobs(userId);
			userSpecs = dashboardService.selectCurrUserSpec(userId);
			for (Job job : userJobs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(job.getJobId());
				dto.setTitle(job.getJobName());
				dto.setExplain(job.getJobExplain());
				dto.setType("job");
				jobCItemList.add(dto);
			}
			// spec setting
			for (Spec spec : userSpecs) {
				CareerItemDto dto = new CareerItemDto();
				dto.setItemId(spec.getSpecId());
				dto.setTitle(spec.getSpecName());
				dto.setExplain(spec.getSpecExplain());
				dto.setType("spec");
				specCItemList.add(dto);
			}
			sessionTopicOpts.setJobList(jobCItemList); // 변환된 리스트 사용
			// 유저 직무 선택에 따라 sub 주제 세팅
			// userSpecs = dashboardService.selectUserSpecs(...);
			break;
		default:
			break;
		}
		//
		return sessionTopicOpts;
	}

	// 대화 시작하고 서브 토픽 [직무] 설정 클릭 ===========================
	// 클릭된 버튼에서 Career Item 객체정보를 받아 convManager에게 보내 subtopic으로 지정
	@RequestMapping(value = "setConvSubJobTopic.do", method = RequestMethod.POST)
	@ResponseBody
	public void setConvSubJobTopic(@RequestBody CareerItemDto selectedItem, HttpSession loginSession) {
		User loginUser = (User) loginSession.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		ConvSession session = convManager.getSession(userId);

		// 세션 sub 주제 설정
		switch (session.getTopic()) {
		case "job":
			break;
		case "spec":
			convManager.setConvSubJobTopic(session, selectedItem);
			break;
		case "ss":
			convManager.setConvSubJobTopic(session, selectedItem);
			break;
		case "act":
			convManager.setConvSubJobTopic(session, selectedItem);
			break;
		}

		logger.info("지정된 subtopic[JOB]: " + selectedItem.getTitle());
	}

	// 대화 시작하고 서브 토픽 [직무] 설정 클릭 ===========================
	// 클릭된 버튼에서 Career Item 객체정보를 받아 convManager에게 보내 subtopic으로 지정
	@RequestMapping(value = "setConvSubSpecTopic.do", method = RequestMethod.POST)
	@ResponseBody
	public void setConvSubSpecTopic(@RequestBody CareerItemDto selectedItem, HttpSession loginSession) {
		User loginUser = (User) loginSession.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		ConvSession session = convManager.getSession(userId);

		// 세션 sub 주제 설정
		switch (session.getTopic()) {
		case "job":
			break;
		case "spec":
			break;
		case "ss":
			convManager.setConvSubSpecTopic(session, selectedItem);
			break;
		case "act":
			convManager.setConvSubSpecTopic(session, selectedItem);
			break;
		}

		logger.info("지정된 sub topic[SPEC]: " + selectedItem.getTitle());
	}

	// 유저가 대화 중 챗봇이 준 옵션 중 선택 후 제출한 경우 // 세션 정보에 따라 매니저 서비스 호출 -> 서비스에서 응답을 화면에
	// append
	// 유저가 챗봇이 준 옵션 중 선택 후 제출한 경우 ===========================

	// 메소드 추가 =====================================================
	// 사용자가 직접 직무/ 스펙/ 일정/ 활동 입력하고 추가 버튼 누르는 경우
	// 1. Dashboard Service(?) 사용해 사용자 career plan에 저장
	// 2. Job, Spec, Ss, Activity Service로 각각의 테이블에 저장
	// -- > 입력된 정보 다시 우측 사이드바에 받아오는 메소드 필요
	@RequestMapping(value = "insertCareerItem.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<?> insertCareerItem(@RequestBody CareerItemDto insertedItem, HttpSession session,
			HttpServletResponse response) {
		/*
		 * try { request.setCharacterEncoding("UTF-8");
		 * response.setContentType("application/json; charset=UTF-8"); } catch
		 * (UnsupportedEncodingException e) { // TODO Auto-generated catch block
		 * e.printStackTrace(); }
		 */
		response.setContentType("application/json; charset=UTF-8");

		User loginUser = (User) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		ConvSession convSession = convManager.getSession(userId);
		String topic = convSession.getTopic();

		switch (topic) {
		case "job":
			// 최대 5개까지 추가할 수 있도록 제한
			List<Job> userJobs = dashboardService.selectUserJobs(userId);
			boolean isDuplicate = false;

			for (Job job : userJobs) {
				logger.info("추가된 jobname:" + insertedItem.getTitle() + ", 비교:" + job.getJobName());
				if (job.getJobName().equals(insertedItem.getTitle())) {
					isDuplicate = true;
					return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("같은 이름의 직무가 이미 존재합니다.");
				}
			}

			if (userJobs.size() < 5 && isDuplicate == false) {

				Job job = new Job();

				// insertedItem을 Job으로 전환
				int jobId = dashboardService.selectNextJobId();
				job.setJobId(String.valueOf(jobId));
				job.setJobName(insertedItem.getTitle());
				job.setJobExplain(insertedItem.getExplain());
				insertedItem.setItemId(String.valueOf(jobId));

				// job table에 추가
				dashboardService.insertJob(job);

				// career plan 테이블에 추가
				Specific specific = new Specific();
				specific.setUserId(userId);
				specific.setJobId(String.valueOf(jobId));
				dashboardService.insertJobLink(specific);
			} else {
				// 5개 초과해 추가하려고 할 경우
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("직무는 최대 5개까지만 추가할 수 있습니다.");

			}
			break;

		case "spec":
			// 같은 직무에 대해 이미 같은 이름의 스펙이 존재하지 않도록 처리
			// 현재 타겟 직무에 대해 저장된 스펙들 불러오기
			Specific specific = new Specific();
			specific.setUserId(userId);
			specific.setJobId(convSession.getSubJobTopicId());
			logger.info("target 직무 아이디"+ specific.getJobId());
			
			List<Spec> specList = dashboardService.selectUserSpecs(specific);
			boolean isSpecDuplicate = false;
			for (Spec spec : specList) {
				if (spec.getSpecName().equals(insertedItem.getTitle())) {
					isSpecDuplicate = true;
					return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("직무에 같은 스펙이 이미 존재합니다.");
				}
			}
			if (isSpecDuplicate == false && specList.size()<7) {
				// 스펙 추천 챗봇에서 선택한 스펙을 저장하기.
				// 프론트에서 받아온 스펙 정보로 스펙 객체 만들기
				Spec spec = new Spec();
				String specId = String.valueOf(dashboardService.selectNextSpecId());
				spec.setSpecId(specId);
				insertedItem.setItemId(String.valueOf(specId)); // ← 이게 빠졌어요
				spec.setSpecName(insertedItem.getTitle());
				spec.setSpecExplain(insertedItem.getExplain());
				spec.setSpecType(insertedItem.getType());

				// 스펙 tb에 저장
				dashboardService.insertSpec(spec);

				// career plan 테이블에 추가
				// 부모 job id에 대한 specific에 넣어야 함.
				// 이미 부모 job에 spec이 있을 경우 새로운 specific 생성
				Specific specific1 = new Specific();
				specific1.setUserId(userId);
				specific1.setJobId(convSession.getSubJobTopicId());
				specific1.setSpecId(specId);

				dashboardService.insertSpecLink(specific1);
			}
			else {
				// 7개 초과해 추가하려고 할 경우
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("스펙은 직무당 최대 7개까지만 추가할 수 있습니다.");
			}
			break;

		case "act":
			Activity act = new Activity();
			String actId = String.valueOf(dashboardService.selectNextActId());
			act.setActId(actId);
			act.setActContent(insertedItem.getTitle());
			act.setActState(insertedItem.getState());

			dashboardService.insertAct(act);

			Specific specific2 = new Specific();
			specific2.setUserId(userId);
			specific2.setJobId(convSession.getSubJobTopicId());
			specific2.setSpecId(convSession.getSubSpecTopicId());
			specific2.setActId(actId);
			dashboardService.insertSpecLink(specific2);

			break;

		case "ss":
			SpecSchedule ss = new SpecSchedule();
			String ssId = String.valueOf(dashboardService.selectNextSsId());
			ss.setSsId(ssId);
			ss.setSpecId(insertedItem.getItemId());
			ss.setSsType(insertedItem.getExplain());
			ss.setSsDate(insertedItem.getSchedule());

			dashboardService.insertSs(ss);
			break;

		default:
			return null;
		}

		return ResponseEntity.ok(insertedItem);

	}

	// 메소드 추가 =====================================================
	@RequestMapping(value = "/sendMessageToChatbot.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto sendMessageToChatbot(@RequestBody Map<String, Object> body, HttpSession session) {
		// 보낸 유저 정보
		User loginUser = (User) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		logger.info("login User: " + userId);

		// 프론트에서 받은 유저 메세지와 토픽 가져오기
		String userMsg = (String) body.get("userMsg");
		String topic = (String) body.get("topic");

		ConvSession convSession = convManager.getSession(userId);
		if (convSession == null || !topic.equals(convSession.getTopic())) {
			convSession = convManager.createNewSession(userId, topic);
			System.out.println("[DEBUG] New ConvSession created for " + userId + " / topic: " + topic);

		}

		ChatbotResponseDto responseDto;

		switch (topic) {
		case "job":
			responseDto = jobManager.getGptResponse(convSession, userMsg);
			break;
		case "spec":
			responseDto = specManager.getGptResponse(convSession, userMsg);
			break;
		case "ss":
			responseDto = ssManager.handleChatMessage(convSession, userMsg);
			break;
		case "act":
			responseDto = actManager.handleChatMessage(convSession, userMsg);
			break;
		default:
			responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
		}

		return responseDto;
	}

	// 메소드 추가
	// Dashboard Service에서 delete job 등 생긴 후 마저 구현

	@RequestMapping(value = "deleteSavedOption.do", method = RequestMethod.POST)
	@ResponseBody
	public void deleteSavedOption(@RequestBody CareerItemDto itemToDelete, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		ConvSession convSession = convManager.getSession(userId);
		String topic = convSession.getTopic();

		switch (topic) {
		case "job":
			// itemToDelete의 id에 해당하는 job 삭제
			// Job table에서 삭제 (--> DB 상에서 career plan에서 자동 삭제)
			dashboardService.deleteJob(itemToDelete.getItemId());
			break;
		case "spec":
			dashboardService.deleteSpec(itemToDelete.getItemId());
			break;
		case "ss":
			break;
		case "act":
			break;
		}

	}

	@RequestMapping(value = "submitChatbotOption.do", method = RequestMethod.POST)
	@ResponseBody
	public ChatbotResponseDto submitChatbotOption(

			@RequestParam("userChoice") String userChoice, HttpSession loginSession) {
		String userId = (String) loginSession.getAttribute("userId");
		ConvSession session = convManager.getSession(userId);
		String topic = session.getTopic();

		ChatbotResponseDto responseDto;

		// handleChatbotOption: // 옵션 유형(대시보드 저장, 추가 추천 여부, 내용 추가 희망 여부)에 따라 // 다르게 동작하여
		// 유저 선택에 대해 응답하도록 함.
		switch (topic) {
		case "job":
			responseDto = jobManager.handleChatbotOption(session, userChoice);
			break;
		case "spec":
			responseDto = specManager.handleChatbotOption(session, userChoice);
			break;
		case "ss":
			responseDto = ssManager.handleChatMessage(session, userChoice);
			break;
		case "act":
			responseDto = actManager.handleChatMessage(session, userChoice);
			break;
		default:
			responseDto = new ChatbotResponseDto("유효하지 않은 주제입니다.", null);
		}

		return responseDto;
	}

	// SPEC CHAT에서 SUBTOPIC JOB 에 따른 저장해둔 스펙 불러와 사이드바에 넣기 위함
	@RequestMapping(value = "getSpecsByJob.do", method = RequestMethod.POST)
	@ResponseBody
	public List<CareerItemDto> getSpecsByJob(@RequestBody CareerItemDto targetJobCI, HttpSession loginSession) {

		// 로그인 세션에서 현 유저 받아옴.
		User loginUser = (User) loginSession.getAttribute("loginUser");
		String userId = (loginUser != null) ? loginUser.getUserId() : "ExUser";

		Specific specific = new Specific();
		specific.setUserId(userId);
		specific.setJobId(targetJobCI.getItemId());

		List<Spec> specList = dashboardService.selectUserSpecs(specific);
		List<CareerItemDto> specCIList = new ArrayList<>();
		for (Spec spec : specList) {
			CareerItemDto dto = new CareerItemDto();
			dto.setItemId(spec.getSpecId()); // 또는 적절한 ID 매핑
			dto.setTitle(spec.getSpecName());
			dto.setExplain(spec.getSpecExplain());
			dto.setType("spec"); // 타입도 지정

			specCIList.add(dto);
		}
		return specCIList;
	}
}
