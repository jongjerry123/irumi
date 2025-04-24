package com.project.irumi.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.irumi.user.model.dao.UserDao;
import com.project.irumi.user.model.dto.User;

@Service("userService")
public class UserServiceImpl implements UserService{
	
	@Autowired
	private UserDao userDao;
	
	@Autowired
    private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Override
	public User selectUser(User user) {
		return userDao.selectUser(user);
	}
	@Override
    public boolean checkIdAvailability(String userId) {
        return userDao.countByUserId(userId) == 0;
    }

    @Override
    public void registerUser(User user) {
        // 비밀번호 암호화
        user.setUserPwd(bcryptPasswordEncoder.encode(user.getUserPwd()));
        // 기본 권한 설정
        user.setUserAuthority("1"); // 일반 사용자
        userDao.insertUser(user);
    }

}
