package com.project.irumi.dashboard.controller;

import java.util.ArrayList;
import java.util.HashMap;
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
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.JobList;
import com.project.irumi.dashboard.model.dto.Spec;
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
	
	
	
	@RequestMapping("addSpec.do")
	public String moveToAddSpec() {
		return "dashboard/newSpec";
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
	public Map<String, Object> noticeNewTop3Method(@RequestParam("jobId") String jobId, @RequestParam("specId") String specId, Model model, HttpSession session) { // Jackson 라이브러리 사용시 리턴방식
		
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
			ModelAndView mv, @RequestParam("keyword") String keyword, @RequestParam(name = "page", required = false) String page, @RequestParam(name = "limit", required = false) String slimit) {
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
		int listCount = dashboardService.selectSearchJobCount(keyword);
		// 페이지 관련 항목들 계산 처리
		Paging paging = new Paging(listCount, limit, currentPage, "jobSearch.do");
		paging.calculate();

		// 마이바티스 매퍼에서 사용되는 메소드는 Object 1개만 전달할 수 있음
		// paging.startRow, paging.endRow, keyword 같이 전달해야 하므로 => 객체 하나를 만들어서 저장해서 보냄
		Search search = new Search();
		search.setKeyword(keyword);
		search.setStartRow(paging.getStartRow());
		search.setEndRow(paging.getEndRow());

		// 서비스 모델로 페이징 적용된 목록 조회 요청하고 결과받기
		ArrayList<JobList> list = dashboardService.selectSearchJob(search);

		if (list != null && list.size() > 0) { // 조회 성공시
			// ModelAndView : Model + View
			mv.addObject("list", list); // request.setAttribute("list", list) 와 같음
			mv.addObject("paging", paging);
			mv.addObject("keyword", keyword);

			mv.setViewName("dashboard/newJob");
		} else { // 조회 실패시
			mv.addObject("message", keyword + " 검색 결과가 존재하지 않습니다.");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping("jobDetail.do")
	public ModelAndView jobDetailMethod(@RequestParam("jobListId") String jobListId, ModelAndView mv) {
		
		JobList jobList = dashboardService.selectOneJobList(jobListId);


		if (jobList != null) {
			mv.addObject("jobList", jobList);
			mv.setViewName("dashboard/newSpec");
		} else {
			mv.addObject("message", "직무 상세보기 요청 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}
	
	@RequestMapping(value = "insertJob.do", method = RequestMethod.POST)
	public ModelAndView insertJobMethod(Job job, ModelAndView mv, HttpSession session) {
		
		int jobId = dashboardService.selectMaxJobId() + 1;
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
	
}
