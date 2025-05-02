package com.project.irumi.dashboard.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.common.Paging;
import com.project.irumi.common.Search;
import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.JobList;
import com.project.irumi.dashboard.model.dto.Spec;
import com.project.irumi.dashboard.model.dto.SpecSchedule;
import com.project.irumi.dashboard.model.dto.Specific;

@Repository("dashboardDao")
public class DashboardDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public Dashboard selectUserSpec(String userId){
		return sqlSessionTemplate.selectOne("dashboardMapper.selectUserSpec", userId);
	}
	
	public ArrayList<Spec> selectCurrUserSpec(String userId) {
		List<Spec> list = sqlSessionTemplate.selectList("dashboardMapper.selectCurrUserSpec", userId);
		return (ArrayList<Spec>) list;
	}
	
	public int updateDashboard(Dashboard dashboard) {
		return sqlSessionTemplate.update("dashboardMapper.updateDashboard", dashboard);
	}
	
	public ArrayList<Job> selectUserJobs(String userId) {
		List<Job> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserJobs", userId);
		return (ArrayList<Job>) list;
	}
	
	public Job selectJob(String jobId) {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectJob", jobId);
	}
	
	public ArrayList<Spec> selectUserSpecs(Specific specific) {
		List<Spec> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserSpecs", specific);
		return (ArrayList<Spec>) list;
	}
	
	public ArrayList<Spec> selectAllUserSpecs(Specific specific) {
		List<Spec> list = sqlSessionTemplate.selectList("dashboardMapper.selectAllUserSpecs", specific);
		return (ArrayList<Spec>) list;
	}
	
	public ArrayList<Activity> selectUserActs(Specific specific) {
		List<Activity> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserActs", specific);
		return (ArrayList<Activity>) list;
	}
	
	public ArrayList<SpecSchedule> selectUserSpecSchedule(String specId) {
		List<SpecSchedule> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserSpecSchedule", specId);
		return (ArrayList<SpecSchedule>) list;
	}
	
	public int selectJobListCount() {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectJobListCount");
	}
	
	public ArrayList<JobList> selectJobList(Paging paging) {
		List<JobList> list = sqlSessionTemplate.selectList("dashboardMapper.selectJobList", paging);
		return (ArrayList<JobList>) list;
	}
	
	public int selectSearchJobCount(String keyword) {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectSearchJobCount", keyword);
	}
	
	public ArrayList<JobList> selectSearchJob(Search search) {
		List<JobList> list = sqlSessionTemplate.selectList("dashboardMapper.selectSearchJob", search);
		return (ArrayList<JobList>) list;
	}
	
	public JobList selectOneJobList(String jobListId) {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectOneJobList", jobListId);
	}
	
	public int updateAccomplishSpecState(String specId) {
		return sqlSessionTemplate.update("dashboardMapper.updateAccomplishSpecState", specId);
	}
	
	public Spec selectSpec(String specId) {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectSpec", specId);
	}
	
	public int updateActStatus(Activity activity) {
		return sqlSessionTemplate.update("dashboardMapper.updateActStatus", activity);
	}
	
	public String selectJobIdBySpecId(String specId) {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectJobIdBySpecId", specId);
	}
	
	//직무 추가
	public int selectNextJobId() {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectNextJobId");
	}
	public int insertJob(Job job) {
		return sqlSessionTemplate.insert("dashboardMapper.insertJob", job);
	}
	public int insertJobLink(Specific specific) {
		return sqlSessionTemplate.insert("dashboardMapper.insertJobLink", specific);
	}
	
	// 직무 삭제
	public int deleteJob(String jobId) {
		return sqlSessionTemplate.delete("dashboardMapper.deleteJob", jobId);
	}
	
	// 스펙 삭제
	public int deleteSpec(String specId) {
		return sqlSessionTemplate.delete("dashboardMapper.deleteSpec", specId);
	}
	
	// 활동 삭제
	public int deleteAct(String actId) {
		return sqlSessionTemplate.delete("dashboardMapper.deleteAct", actId);
	}
	
	// 스펙 추가
	public int selectNextSpecId() {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectNextSpecId");
	}
	public int insertSpec(Spec spec) {
		return sqlSessionTemplate.insert("dashboardMapper.insertSpec", spec);
	}
	public int insertSpecLink(Specific specific) {
		return sqlSessionTemplate.insert("dashboardMapper.insertSpecLink", specific);
	}
	
	// 활동 추가
	public int selectNextActId() {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectNextActId");
	}
	public int insertAct(Activity act) {
		return sqlSessionTemplate.insert("dashboardMapper.insertAct", act);
	}
	public int insertActLink(Specific specific) {
		return sqlSessionTemplate.insert("dashboardMapper.insertActLink", specific);
	}
	
	// 스펙 일정 추가
	public int selectNextSsId() {
		return sqlSessionTemplate.selectOne("dashboardMapper.selectNextSsId");
	}
	public int insertSs(SpecSchedule ss) {
		return sqlSessionTemplate.insert("dashboardMapper.insertSs", ss);
	}
	
}
