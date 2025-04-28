package com.project.irumi.dashboard.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.dashboard.model.dto.Activity;
import com.project.irumi.dashboard.model.dto.Dashboard;
import com.project.irumi.dashboard.model.dto.Job;
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
	
	public int updateDashboard(Dashboard dashboard) {
		return sqlSessionTemplate.update("dashboardMapper.updateDashboard", dashboard);
	}
	
	public ArrayList<Job> selectUserJobs(String userId) {
		List<Job> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserJobs", userId);
		return (ArrayList<Job>) list;
	}
	
	public ArrayList<Spec> selectUserSpecs(Specific specific) {
		List<Spec> list = sqlSessionTemplate.selectList("dashboardMapper.selectUserSpecs", specific);
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
	
}
