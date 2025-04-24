package com.project.irumi.user.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.user.model.dto.User;

@Repository
public class UserDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public User selectUser(User user) {
		return sqlSessionTemplate.selectOne("userMapper.selectUser", user);
	}

	public int countByUserId(String userId) {
		return sqlSessionTemplate.selectOne("userMapper.countByUserId", userId);
	}

	public int insertUser(User user) {
		return sqlSessionTemplate.insert("userMapper.insertUser", user);
	}

}
