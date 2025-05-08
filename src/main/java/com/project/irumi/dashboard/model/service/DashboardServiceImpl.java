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
	public ArrayList<Spec> selectAllUserSpecs(Specific specific) {
		return dashboardDao.selectAllUserSpecs(specific);
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
	public int selectSearchJobCount(Search search) {
		return dashboardDao.selectSearchJobCount(search);
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
	public int selectNextJobId() {
		return dashboardDao.selectNextJobId();
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
	public int deleteSpec(String specId) {
		return dashboardDao.deleteSpec(specId);
	}

	@Override
	public int selectNextSpecId() {
		return dashboardDao.selectNextSpecId();
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

	@Override
	public int selectNextActId() {
		return dashboardDao.selectNextActId();
	}

	@Override
	public int insertAct(Activity act) {
		return dashboardDao.insertAct(act);
	}

	@Override
	public int insertActLink(Specific specific) {
		return dashboardDao.insertActLink(specific);
	}

	@Override
	public int selectNextSsId() {
		return dashboardDao.selectNextSsId();
	}

	@Override
	public int insertSs(SpecSchedule ss) {
		return dashboardDao.insertSs(ss);
	}

	@Override
	public Spec selectSpec(String specId) {
		return dashboardDao.selectSpec(specId);
	}

	@Override
	public int updateActStatus(Activity activity) {
		return dashboardDao.updateActStatus(activity);
	}

	@Override
	public String selectJobIdBySpecId(String specId) {
		return dashboardDao.selectJobIdBySpecId(specId);
	}

	@Override
	public int deleteAct(String actId) {
		return dashboardDao.deleteAct(actId);
	}

	@Override
	public int deleteJob(String jobId) {
		return dashboardDao.deleteJob(jobId);
	}

	@Override
	public int deleteSpecSchedule(String ssId) {
		return dashboardDao.deleteSpecSchedule(ssId);
	}

}
