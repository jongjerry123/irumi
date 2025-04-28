package com.project.irumi.user.model.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.user.model.dto.User;

@Repository
public class UserDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 사용자 조회 (로그인 시 사용)
	public User selectUser(User user) {
		return sqlSessionTemplate.selectOne("userMapper.selectUser", user);
	}

	// 아이디 중복 확인
	public int countByUserId(String userId) {
		return sqlSessionTemplate.selectOne("userMapper.countByUserId", userId);
	}

	// 이메일 중복 확인
	public int countByEmail(String email) {
		return sqlSessionTemplate.selectOne("userMapper.countByEmail", email);
	}

	// 사용자 등록 (회원가입)
	public int registerUser(User user) {
		return sqlSessionTemplate.insert("userMapper.insertUser", user);
	}

	// 이메일로 아이디 조회
	public String findIdByEmail(String email) {
		return sqlSessionTemplate.selectOne("userMapper.findIdByEmail", email);
	}

	// 아이디와 이메일 일치 확인 (의존성 추가)
	public int countByUserIdAndEmail(String userId, String email) {
		Map<String, String> params = new HashMap<>();
		params.put("userId", userId);
		params.put("email", email);
		return sqlSessionTemplate.selectOne("userMapper.countByUserIdAndEmail", params);
	}
	public void updatePassword(String userId, String encodedPassword) {
	    Map<String, String> params = new HashMap<>();
	    params.put("userId", userId);
	    params.put("userPwd", encodedPassword);
	    sqlSessionTemplate.update("userMapper.updatePassword", params);
	}
	//구글로그인
	public User findUserBySocialId(String socialId, int loginType) {
        Map<String, Object> params = new HashMap<>();
        params.put("socialId", socialId);
        params.put("loginType", loginType);
        return sqlSessionTemplate.selectOne("userMapper.findUserBySocialId", params);
    }
}