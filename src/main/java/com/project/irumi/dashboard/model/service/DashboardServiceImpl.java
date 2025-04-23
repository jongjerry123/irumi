package com.project.irumi.dashboard.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.dashboard.model.dao.DashboardDao;
import com.project.irumi.dashboard.model.dto.Dashboard;

@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {
	
	@Autowired
	private DashboardDao dashboardDao;

	@Override
	public Dashboard selectUserSpec(String userId) {
		return dashboardDao.selectUserSpec(userId);
	}
	
}
