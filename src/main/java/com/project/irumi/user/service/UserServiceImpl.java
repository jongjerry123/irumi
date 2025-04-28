package com.project.irumi.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.irumi.user.model.dao.UserDao;
import com.project.irumi.user.model.dto.User;

@Service("userService")
public class UserServiceImpl implements UserService {
    
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
    public boolean checkEmailAvailability(String email) {
        return userDao.countByEmail(email) == 0;
    }

    @Override
    public void registerUser(User user) {
        user.setUserPwd(bcryptPasswordEncoder.encode(user.getUserPwd()));
        userDao.registerUser(user);
    }
    @Override
    public String findIdByEmail(String email) {
        return userDao.findIdByEmail(email);
    }
    @Override
    public boolean checkUserMatch(String userId, String email) {
        return userDao.countByUserIdAndEmail(userId, email) > 0;
    }
    @Override
    public void updatePassword(String userId, String encodedPassword) {
        userDao.updatePassword(userId, encodedPassword);
    }

    @Override
    public User findUserBySocialId(String socialId, int loginType) {
        return userDao.findUserBySocialId(socialId, loginType);
    }
}