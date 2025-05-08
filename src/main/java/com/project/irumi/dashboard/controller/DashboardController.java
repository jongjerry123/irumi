package com.project.irumi.dashboard.controller;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.project.irumi.common.Paging;
import com.project.irumi.common.Search;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.JobList;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.SpecSchedule;
import com.project.irumi.dashboard.model.dto.Specific;
import com.project.irumi.dashboard.model.service.DashboardService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {
	
	@Autowired
	private DashboardService dashboardService;
	
	@RequestMapping("upDash.do")
	public String memberDetailMethod(Model model, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");
		
		// 서비스 모델로 아이디 전달해서, 학력 정보 조회한 결과 리턴받기
		Dashboard dashboard = dashboardService.selectUserSpec(loginUser.getUserId());

		// 리턴받은 결과를 가지고 성공 또는 실패 페이지 내보내기
		if (dashboard != null) { // 조회 성공
			model.addAttribute("dashboard", dashboard);

			return "dashboard/dashboardUpdate";
		} else { // 조회 실패
			model.addAttribute("message", loginUser.getUserId() + " 에 대한 학력 정보 조회 실패! 아이디를 다시 확인하세요.");
			return "common/error";
		}
	}
	
	@RequestMapping("movetoAddSpec.do")
	public String moveToSpecPage(@RequestParam("jobId") String jobId, Model model) {
		Job job = dashboardService.selectJob(jobId);
		
		if (job != null) {
			model.addAttribute("job", job);
			return "dashboard/newSpec";
		}
		
		model.addAttribute("message", "스펙 추가하는 직무 조회 실패!");
		return "common/error";
	}
	
	@RequestMapping("searchJob.do")
	public String moveToSearchJob() {
		return "chatbot/job";
	}
	
	@RequestMapping("searchSpec.do")
	public String moveToSearchSpec() {
		return "chatbot/spec";
	}
	
	// 유저의 현재 스펙(userUniversity, userDegree, userGraduate, userPoint)을 보여주는 메소드
	@RequestMapping(value="userSpecView.do", method=RequestMethod.POST, produces="application/json; charset:UTF-8")
	@ResponseBody
	public Dashboard selectUserSpec(HttpSession session) {
		
		// 로그인 유저 불러오기
		User loginUser = (User) session.getAttribute("loginUser");
		
		
		if (loginUser != null) {
			String userId = loginUser.getUserId();
			return dashboardService.selectUserSpec(userId);	// 서비스로 userId를 보내고 그 유저의 학력정보를 받음
		}
		return null;	// userId 조회결과가 없을 시 ajax에서 에러가 발생함
		
	}
	
	@RequestMapping(value="userCurrSpecView.do", method=RequestMethod.POST, produces="application/json; charset:UTF-8")
	@ResponseBody
	public ArrayList<Spec> selectUserCurrSpec(HttpSession session) {
		
		// 로그인 유저 불러오기
		User loginUser = (User) session.getAttribute("loginUser");
		
		
		if (loginUser != null) {
			String userId = loginUser.getUserId();
			return dashboardService.selectCurrUserSpec(userId);	// 서비스로 userId를 보내고 그 유저의 현재 스펙 정보를 받음
		}
		return null;	// userId 조회결과가 없을 시 ajax에서 에러가 발생함
		
	}
	
	// 대시보드를 업데이트 하는 메소드
	@RequestMapping(value="dashUpdate.do", method=RequestMethod.POST)
	public String memberUpdateMethod(Dashboard dashboard, Model model, HttpServletRequest request) {
		
		// 서비스 모델의 메소드 실행 요청하고 결과받기
		if (dashboardService.updateDashboard(dashboard) > 0) { // 학력 정보 수정 성공시
			// 컨트롤러 메소드에서 다른 컨트롤러 메소드를 실행시킬 경우
			return "redirect:dashboard.do";
		} else { // 학력 정보 수정 실패시
			model.addAttribute("message", "학력 정보 수정 실패! 확인하고 다시 가입해 주세요.");
			return "common/error";
		}
	}
	
	@RequestMapping(value="userJobView.do", method=RequestMethod.POST, produces="application/json; charset:UTF-8")
	@ResponseBody
	public ArrayList<Job> selectUserJobs(Model model, HttpSession session) {
		
		// 로그인 유저 불러오기
		User loginUser = (User) session.getAttribute("loginUser");
		return dashboardService.selectUserJobs(loginUser.getUserId());
	}
	
	@RequestMapping(value="userSpecsView.do", method=RequestMethod.POST, produces="application/json; charset:UTF-8")
	@ResponseBody
	public ArrayList<Spec> selectUserSpecs(@RequestParam("jobId") String jobId, Model model, HttpSession session) {
		
		// 로그인 유저 불러오기
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		return dashboardService.selectUserSpecs(specific);
		
	}
	
	@RequestMapping(value = "userSpecStuff.do", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> selectUserSpecAndSchedule(@RequestParam("jobId") String jobId, @RequestParam("specId") String specId, Model model, HttpSession session) { // Jackson 라이브러리 사용시 리턴방식
		
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		specific.setSpecId(specId);
		Map<String, Object> result = new HashMap<>();
		result.put("acts", dashboardService.selectUserActs(specific));
		result.put("specSchedules", dashboardService.selectUserSpecSchedule(specId));
		return result;
	}
	
	@RequestMapping("addJob.do")
	public ModelAndView addJobMethod(ModelAndView mv, @RequestParam(name = "page", required = false) String page, @RequestParam(name = "limit", required = false) String slimit) {

		int currentPage = 1;
		if (page != null) {
			currentPage = Integer.parseInt(page);
		}
		
		int limit = 20;
		if (slimit != null) {
			limit = Integer.parseInt(slimit);
		}
		
		int listCount = dashboardService.selectJobListCount();
		
		Paging paging = new Paging(listCount, limit, currentPage, "addJob.do");
		paging.calculate();
		
		ArrayList<JobList> list = dashboardService.selectJobList(paging);
		
		if (list != null && list.size() > 0) {
			mv.addObject("list", list);
			mv.addObject("paging", paging);
			mv.setViewName("dashboard/newJob");
		}
		else {
			mv.addObject("message", currentPage + "페이지에 출력할 직업 목록 조회 실패!");
			mv.setViewName("common.error");
		}
		return mv;
	}
	
	@RequestMapping("jobSearch.do")
	public ModelAndView jobSearchMethod(
			ModelAndView mv, Search search, @RequestParam(name = "page", required = false) String page, @RequestParam(name = "limit", required = false) String slimit) {
		// 페이징 처리
		int currentPage = 1;
		if (page != null) {
			currentPage = Integer.parseInt(page);
		}

		// 한 페이지에 출력할 목록 갯수 기본 10개로 지정함
		int limit = 20;
		if (slimit != null) {
			limit = Integer.parseInt(slimit);
		}

		// 검색결과가 적용된 총 목록 갯수 조회해서, 총 페이지 수 계산함
		int listCount = dashboardService.selectSearchJobCount(search);
		// 페이지 관련 항목들 계산 처리
		Paging paging = new Paging(listCount, limit, currentPage, "jobSearch.do");
		paging.calculate();

		// 마이바티스 매퍼에서 사용되는 메소드는 Object 1개만 전달할 수 있음
		// paging.startRow, paging.endRow, keyword 같이 전달해야 하므로 => 객체 하나를 만들어서 저장해서 보냄
		Search ss = new Search();
		ss.setKeyword(search.getKeyword());
		ss.setType(search.getType());
		ss.setStartRow(paging.getStartRow());
		ss.setEndRow(paging.getEndRow());

		// 서비스 모델로 페이징 적용된 목록 조회 요청하고 결과받기
		ArrayList<JobList> list = dashboardService.selectSearchJob(search);


		// ModelAndView : Model + View
		mv.addObject("list", list); // request.setAttribute("list", list) 와 같음
		mv.addObject("paging", paging);
		mv.addObject("keyword", search.getKeyword());

		mv.setViewName("dashboard/newJob");

		return mv;
	}
	
	@RequestMapping("jobDetail.do")
	public ModelAndView jobDetailMethod(@RequestParam("jobListId") String jobListId, ModelAndView mv) {
		
		JobList jobList = dashboardService.selectOneJobList(jobListId);


		if (jobList != null) {
			mv.addObject("jobList", jobList);
			mv.setViewName("dashboard/jobDetail");
		} else {
			mv.addObject("message", "직무 상세보기 요청 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping(value = "insertJob.do", method = RequestMethod.POST)
	public ModelAndView insertJobMethod(Job job, ModelAndView mv, HttpSession session) {
		
		int jobId = dashboardService.selectNextJobId();
		job.setJobId(String.valueOf(jobId));
		
		int resultOne = dashboardService.insertJob(job);
		
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(String.valueOf(jobId));
		
		int resultTwo = dashboardService.insertJobLink(specific);
		
		if (resultOne > 0 && resultTwo > 0) {
			mv.addObject("job", job);
			mv.setViewName("chatbot/spec");
		} else {
			mv.addObject("message", "직무 추가 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping("deleteJob.do")
	public String deleteJobMethod(@RequestParam("jobId") String jobId, Model model) {
		
		if (dashboardService.deleteJob(jobId) > 0) {
			return "redirect:dashboard.do";
		} else {
			model.addAttribute("message", "직무 삭제 실패!");
			return "common/error";
		}
	}
	
	@RequestMapping("deleteSpec.do")
	public String deleteSpecMethod(@RequestParam("specId") String specId, Model model) {
		
		if (dashboardService.deleteSpec(specId) > 0) {
			return "redirect:dashboard.do";
		} else {
			model.addAttribute("message", "스펙 삭제 실패!");
			return "common/error";
		}
	}
	
	// 추가 -- 일정 삭제 용도
	@RequestMapping("CdeleteSpecSchedule.do")
	public String deleteSpecScheduleMethod(@RequestParam("ssId") String ssId, Model model) {
		
		if (dashboardService.deleteSpecSchedule(ssId) > 0) {
			return "redirect:viewScheduleRecChat.do";
		} else {
			model.addAttribute("message", "일정 삭제 실패!");
			return "common/error";
		}
	}
	
	@RequestMapping("deleteAct.do")
	public String deleteActMethod(@RequestParam("actId") String actId, Model model) {
		
		if (dashboardService.deleteAct(actId) > 0) {
			return "redirect:dashboard.do";
		} else {
			model.addAttribute("message", "스펙 삭제 실패!");
			return "common/error";
		}
	}
	
	// 추가 -- 일정 추가 메소드
	@RequestMapping(value = "insertSpecSchedule.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertSpecSchedule(
	        @RequestParam("specId") String specId,
	        @RequestParam("ssType") String ssType,
	        @RequestParam("ssDate") String ssDate) {

	    Map<String, Object> result = new HashMap<>();

	    int ssId = dashboardService.selectNextSsId();
	    SpecSchedule ss = new SpecSchedule(
	        String.valueOf(ssId),
	        specId,
	        ssType,
	        Date.valueOf(ssDate)
	    );

	    boolean success = dashboardService.insertSs(ss) > 0;

	    result.put("success", success);
	    result.put("ssId", ssId);

	    return result;
	}
	
	// 추가 -- 활동 추가 메소드
	@ResponseBody
	@RequestMapping(value = "insertAct.do", method = RequestMethod.POST)
	public Map<String, Object> insertActMethod(@RequestParam("jobId") String jobId,
	                                           @RequestParam("specId") String specId,
	                                           @RequestParam("actContent") String actContent,
	                                           HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    
	    User loginUser = (User) session.getAttribute("loginUser");

	    String actId = String.valueOf(dashboardService.selectNextActId());
	    Activity act = new Activity(actId, actContent);

	    Specific specific = new Specific();
	    specific.setUserId(loginUser.getUserId());
	    specific.setJobId(jobId);
	    specific.setSpecId(specId);
	    specific.setActId(actId);

	    boolean success = dashboardService.insertAct(act) > 0 &&
	                      dashboardService.insertActLink(specific) > 0;

	    result.put("success", success); // insert 확인 용도, 프런트에서 확인
	    result.put("actId", actId);
	    return result;
	}

	
	
	@RequestMapping(value = "insertSpec.do", method = RequestMethod.POST)
	public ModelAndView insertSpecMethod(Spec spec, @RequestParam("jobId") String jobId, @RequestParam("ssType") List<String> ssType, @RequestParam("ssDate") List<String> ssDate, @RequestParam("actContent") List<String> actContent, ModelAndView mv, HttpSession session) {
		
		// 스펙 추가
		boolean resultOne = true;
		String specId = String.valueOf(dashboardService.selectNextSpecId());
		spec.setSpecId(specId);
		int one = dashboardService.insertSpec(spec);
		
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		specific.setSpecId(specId);
		int two = dashboardService.insertSpecLink(specific);
		
		if (one < 1 || two < 1) {
			resultOne = false;
		}
		
		// 스펙 스케줄 추가
		boolean resultTwo = true;
		if (ssType.size() == ssDate.size()) {
			for (int i = 0; i < ssType.size(); i++) {
				if (ssType.get(i) != null && ssDate.get(i) != null && !ssType.get(i).isEmpty() && !ssDate.get(i).isEmpty()) {
					int ssId = dashboardService.selectNextSsId();
					if (dashboardService.insertSs(new SpecSchedule(String.valueOf(ssId), String.valueOf(specId), ssType.get(i), Date.valueOf(ssDate.get(i)))) < 1) {
						resultTwo = false;
					}
				}
				
			}
		}
		
		// 활동 추가
		boolean resultThree = true;
		for (int i = 0; i < actContent.size(); i++) {
			if (actContent.get(i) != null && !actContent.get(i).isEmpty()) {
				int actId = dashboardService.selectNextActId();
				Activity act = new Activity(String.valueOf(actId), actContent.get(i));
				specific.setActId(String.valueOf(actId));
				if (dashboardService.insertAct(act) < 1 || dashboardService.insertActLink(specific) < 1) {
					resultThree = false;
				}
			}
			
		}
		
		
		if (resultOne && resultTwo && resultThree) {
			mv.setViewName("redirect:dashboard.do");
		} else {
			mv.addObject("message", "스펙 추가 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping("updateSpecStatus.do")
	public String updateSpecStatusMethod(@RequestParam("specId") String specId, Model model) {
		
		if (dashboardService.updateAccomplishSpecState(specId) > 0) {
			return "redirect:dashboard.do";
		}
		model.addAttribute("message", "스펙 업데이트 실패!");
		return "common/error";
	}
	
	@RequestMapping("updateSpec.do")
	public String updateSpecMethod(@RequestParam("specId") String specId, Model model, HttpSession session) {
		
		String jobId = dashboardService.selectJobIdBySpecId(specId);
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		specific.setSpecId(specId);
		
		Job job = dashboardService.selectJob(jobId);
		Spec spec = dashboardService.selectSpec(specId);
		ArrayList<SpecSchedule> ss = dashboardService.selectUserSpecSchedule(specId);
		ArrayList<Activity> acts = dashboardService.selectUserActs(specific);
		
		if (spec != null) {
			model.addAttribute("job", job);
			model.addAttribute("spec", spec);
			model.addAttribute("ss", ss);
			model.addAttribute("acts", acts);
			return "dashboard/editSpec";
		}
		model.addAttribute("message", "스펙 업데이트 실패!");
		return "common/error";
	}
	
	@RequestMapping(value = "deleteAndInsertSpec.do", method = RequestMethod.POST)
	public ModelAndView deleteAndInsertSpecMethod(Spec spec, @RequestParam("jobId") String jobId, @RequestParam("ssType") List<String> ssType, @RequestParam("ssDate") List<String> ssDate, @RequestParam("actContent") List<String> actContent, ModelAndView mv, HttpSession session) {

		// 기존 스펙 삭제 -- 활동은 안지워짐 (TB_CAREER_PLAN에는 없지만 TB_ACTIVITY에는 남아있음)
		int resultDelete = dashboardService.deleteSpec(spec.getSpecId());
		
		// 스펙 추가
		boolean resultOne = true;
		String specId = String.valueOf(dashboardService.selectNextSpecId());
		spec.setSpecId(specId);
		int one = dashboardService.insertSpec(spec);

		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		specific.setSpecId(specId);
		int two = dashboardService.insertSpecLink(specific);

		if (one < 1 || two < 1) {
			resultOne = false;
		}

		// 스펙 스케줄 추가
		boolean resultTwo = true;
		if (ssType.size() == ssDate.size()) {
			for (int i = 0; i < ssType.size(); i++) {
				if (ssType.get(i) != null && ssDate.get(i) != null && !ssType.get(i).isEmpty() && !ssDate.get(i).isEmpty()) {
					int ssId = dashboardService.selectNextSsId();
					if (dashboardService.insertSs(new SpecSchedule(String.valueOf(ssId), String.valueOf(specId), ssType.get(i), Date.valueOf(ssDate.get(i)))) < 1) {
						resultTwo = false;
					}
				}
			}
		}

		// 활동 추가
		boolean resultThree = true;
		for (int i = 0; i < actContent.size(); i++) {
			if (actContent.get(i) != null && !actContent.get(i).isEmpty()) {
				int actId = dashboardService.selectNextActId();
				Activity act = new Activity(String.valueOf(actId), actContent.get(i));
				specific.setActId(String.valueOf(actId));
				if (dashboardService.insertAct(act) < 1 || dashboardService.insertActLink(specific) < 1) {
					resultThree = false;
				}
			}

		}

		if (resultDelete > 0 && resultOne && resultTwo && resultThree) {
			mv.setViewName("redirect:dashboard.do");
		} else {
			mv.addObject("message", "스펙 추가 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping("updateActStatus.do")
	public String updateActStatus(@RequestParam("actId") String actId, @RequestParam("actState") String actState, Model model) {
		
		Activity act = new Activity();
		act.setActId(actId);

		if (actState.equals("N")) {
			act.setActState("Y");
		}
		else {
			act.setActState("N");
		}
		
		if (dashboardService.updateActStatus(act) > 0) {
			return "redirect:dashboard.do";
		}
		
		model.addAttribute("message", "활동 업데이트 실패!");
		return "common/error";
	}
	
	@RequestMapping(value = "updateProgressBar.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Double> updateProgressBarMethod(@RequestParam("jobId") String jobId, HttpSession session) {
		
		double result = 0;
		
		User loginUser = (User) session.getAttribute("loginUser");
		Specific specific = new Specific();
		specific.setUserId(loginUser.getUserId());
		specific.setJobId(jobId);
		ArrayList<Spec> jobList = dashboardService.selectAllUserSpecs(specific);
		
		for (int i = 0; i < jobList.size(); i++) {
			if (jobList.get(i).getSpecState().equals("Y")) {
				result += 1.0 / jobList.size();
			}
			else {
				specific.setSpecId(jobList.get(i).getSpecId());
				ArrayList<Activity> actList = dashboardService.selectUserActs(specific);
				for (int j = 0; j < actList.size(); j++) {
					if (actList.get(j).getActState().equals("Y")) {
						result += (1.0 / jobList.size()) / actList.size();
					}
				}
			}
		}
		Map<String, Double> response = new HashMap<String, Double>();
		response.put("progress", result * 100);
		return response;
	}
	
	
}
