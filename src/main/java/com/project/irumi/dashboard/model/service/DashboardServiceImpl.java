package com.project.irumi.dashboard.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.dashboard.model.dao.DashboardDao;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;

@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {
	
	@Autowired
	private DashboardDao dashboardDao;

	@Override
	public Dashboard selectUserSpec(String userId) {
		return dashboardDao.selectUserSpec(userId);
	}

	@Override
	public int updateDashboard(Dashboard dashboard) {
		return dashboardDao.updateDashboard(dashboard);
	}

	@Override
	public ArrayList<Job> selectUserJobs(String userId) {
		return dashboardDao.selectUserJobs(userId);
	}
	
}
