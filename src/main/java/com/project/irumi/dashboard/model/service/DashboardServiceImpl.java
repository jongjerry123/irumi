package com.project.irumi.dashboard.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.common.Paging;
import com.project.irumi.common.Search;
import com.project.irumi.dashboard.model.dao.DashboardDao;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.JobList;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.SpecSchedule;
import com.project.irumi.dashboard.model.dto.Specific;

@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {
	
	@Autowired
	private DashboardDao dashboardDao;

	@Override
	public Dashboard selectUserSpec(String userId) {
		return dashboardDao.selectUserSpec(userId);
	}
	
	@Override
	public ArrayList<Spec> selectCurrUserSpec(String userId) {
		return dashboardDao.selectCurrUserSpec(userId);
	}
	
	@Override
	public int updateDashboard(Dashboard dashboard) {
		return dashboardDao.updateDashboard(dashboard);
	}

	@Override
	public ArrayList<Job> selectUserJobs(String userId) {
		return dashboardDao.selectUserJobs(userId);
	}
	
	@Override
	public Job selectJob(String jobId) {
		return dashboardDao.selectJob(jobId);
	}
	
	@Override
	public ArrayList<Spec> selectUserSpecs(Specific specific) {
		return dashboardDao.selectUserSpecs(specific);
	}

	@Override
	public ArrayList<Activity> selectUserActs(Specific specific) {
		return dashboardDao.selectUserActs(specific);
	}

	@Override
	public ArrayList<SpecSchedule> selectUserSpecSchedule(String specId) {
		return dashboardDao.selectUserSpecSchedule(specId);
	}

	@Override
	public int selectJobListCount() {
		return dashboardDao.selectJobListCount();
	}

	@Override
	public ArrayList<JobList> selectJobList(Paging paging) {
		return dashboardDao.selectJobList(paging);
	}

	@Override
	public int selectSearchJobCount(String keyword) {
		return dashboardDao.selectSearchJobCount(keyword);
	}

	@Override
	public ArrayList<JobList> selectSearchJob(Search search) {
		return dashboardDao.selectSearchJob(search);
	}

	@Override
	public JobList selectOneJobList(String jobListId) {
		return dashboardDao.selectOneJobList(jobListId);
	}

	@Override
	public int selectMaxJobId() {
		return dashboardDao.selectMaxJobId();
	}

	@Override
	public int insertJob(Job job) {
		return dashboardDao.insertJob(job);
	}

	@Override
	public int insertJobLink(Specific specific) {
		return dashboardDao.insertJobLink(specific);
	}

	@Override
	public int deleteSpecLink(Specific specific) {
		return dashboardDao.deleteSpecLink(specific);
	}

	@Override
	public int deleteSpec(String specId) {
		return dashboardDao.deleteSpec(specId);
	}

	@Override
	public int selectMaxSpecId() {
		return dashboardDao.selectMaxSpecId();
	}

	@Override
	public int insertSpec(Spec spec) {
		return dashboardDao.insertSpec(spec);
	}

	@Override
	public int insertSpecLink(Specific specific) {
		return dashboardDao.insertSpecLink(specific);
	}

	@Override
	public int updateAccomplishSpecState(String specId) {
		return dashboardDao.updateAccomplishSpecState(specId);
	}

	

}
