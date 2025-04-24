package com.project.irumi.dashboard.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.service.DashboardService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {
	
	@Autowired
	private DashboardService dashboardService;
	
	@RequestMapping("upDash.do") // 전송방식 get 임
	public String memberDetailMethod(@RequestParam("userId") String userId, Model model) {

		// 서비스 모델로 아이디 전달해서, 학력 정보 조회한 결과 리턴받기
		Dashboard dashboard = dashboardService.selectUserSpec(userId);

		// 리턴받은 결과를 가지고 성공 또는 실패 페이지 내보내기
		if (dashboard != null) { // 조회 성공
			model.addAttribute("dashboard", dashboard);

			return "dashboard/dashboardUpdate";
		} else { // 조회 실패
			model.addAttribute("message", userId + " 에 대한 학력 정보 조회 실패! 아이디를 다시 확인하세요.");
			return "common/error";
		}
	}
	
	// 유저의 현재 스펙(userUniversity, userDegree, userGraduate, userPoint)을 보여주는 메소드
	@RequestMapping(value = "userSpecView.do", method = RequestMethod.POST, produces = "application/json; charset:UTF-8")
	@ResponseBody
	public Dashboard selectUserSpec(HttpSession session) {
		
		// 로그인 유저 불러오기
		// User loginUser = (User) session.getAttribute("loginUser");	//로그인 기능 완성되면 주석 풀기
		
		// TODO: 테스트용임. 로그인기능 완성되면 지우고 위의 주석 제거
		User loginUser = new User();
		loginUser.setUserId("user1");
		
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
	
	@RequestMapping(value = "userJobView.do", method = RequestMethod.POST, produces = "application/json; charset:UTF-8")
	@ResponseBody
	public ArrayList<Job> selectUserJobs(Model model, HttpSession session) {
		
		// 로그인 유저 불러오기
		// User loginUser = (User) session.getAttribute("loginUser");	//로그인 기능 완성되면 주석 풀기
		// return dashboardService.selectUserJobs(loginUser.getUserId());
		
		// TODO: 테스트용임. 로그인기능 완성되면 지우고 위의 주석 제거
		return dashboardService.selectUserJobs("user0");
		
		
		
	}
	
}
