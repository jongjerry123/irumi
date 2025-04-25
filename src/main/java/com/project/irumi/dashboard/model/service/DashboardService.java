package com.project.irumi.dashboard.model.service;

import java.util.ArrayList;

import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.Specific;

public interface DashboardService {
	
	Dashboard selectUserSpec(String userId);
	int updateDashboard(Dashboard dashboard);
	ArrayList<Job> selectUserJobs(String userId);
	ArrayList<Spec> selectUserSpecs(Specific specific);
	
}
