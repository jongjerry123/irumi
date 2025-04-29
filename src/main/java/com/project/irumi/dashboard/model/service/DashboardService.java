package com.project.irumi.dashboard.model.service;

import java.util.ArrayList;

import com.project.irumi.common.Paging;
import com.project.irumi.common.Search;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.JobList;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.SpecSchedule;
import com.project.irumi.dashboard.model.dto.Specific;

public interface DashboardService {
	
	Dashboard selectUserSpec(String userId);
	int updateDashboard(Dashboard dashboard);
	ArrayList<Job> selectUserJobs(String userId);
	ArrayList<Spec> selectUserSpecs(Specific specific);
	ArrayList<Activity> selectUserActs(Specific specific);
	ArrayList<SpecSchedule> selectUserSpecSchedule(String specId);
	int selectJobListCount();
	ArrayList<JobList> selectJobList(Paging paging);
	int selectSearchJobCount(String keyword);
	ArrayList<JobList> selectSearchJob(Search search);
	JobList selectOneJobList(String jobListId);
	int selectMaxJobId();
	int insertJob(Job job);
	int insertJobLink(Specific specific);
	
}
