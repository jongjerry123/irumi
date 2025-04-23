package com.project.irumi.dashboard.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.dashboard.model.dto.Dashboard;

@Repository("dashboardDao")
public class DashboardDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public Dashboard selectUserSpec(String userId){
		return sqlSessionTemplate.selectOne("dashboardMapper.selectUserSpec", userId);
	}
	
}
