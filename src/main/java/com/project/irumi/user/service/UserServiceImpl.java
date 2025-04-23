package com.project.irumi.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.user.model.dao.UserDao;
import com.project.irumi.user.model.dto.User;

@Service("userService")
public class UserServiceImpl implements UserService{
	
	@Autowired
	private UserDao userDao;

	@Override
	public User selectUser(User user) {
		return userDao.selectUser(user);
	}

}
