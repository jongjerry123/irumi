package com.project.irumi.dashboard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.service.DashboardService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpSession;

@Controller
public class DashboardController {
	
	@Autowired
	private DashboardService dashboardService;
	
	@RequestMapping(value = "userSpecView.do", method = RequestMethod.POST, produces = "application/json; charset:UTF-8")
	@ResponseBody
	public Dashboard selectUserSpec(HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser != null) {
			String userId = loginUser.getUserId();
			return dashboardService.selectUserSpec(userId);
		}
		return null;
		
	}
}
