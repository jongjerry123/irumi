package com.project.irumi.user.model.dao;

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
}