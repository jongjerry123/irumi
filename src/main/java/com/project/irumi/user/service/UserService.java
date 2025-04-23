package com.project.irumi.user.service;

import org.springframework.stereotype.Service;

import com.project.irumi.user.model.dto.User;


public interface UserService {

	User selectUser(User user);
	 

}
