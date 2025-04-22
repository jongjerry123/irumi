package com.project.irumi.dashboard.model.service;

import com.project.irumi.dashboard.model.dto.Dashboard;

public interface DashboardService {
	
	Dashboard selectUserSpec(String userId);
}
