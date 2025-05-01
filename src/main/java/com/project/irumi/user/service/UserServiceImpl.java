package com.project.irumi.user.service;

import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

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
    @Override
    public void updateUserProfile(Map<String, Object> userData) {
        String userId = (String) userData.get("userId");
        if (userId == null) throw new IllegalArgumentException("User ID is required");

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);

        if (userData.containsKey("password") && userData.get("password") != null) {
            String encodedPassword = bcryptPasswordEncoder.encode((String) userData.get("password"));
            params.put("userPwd", encodedPassword);
        }
        if (userData.containsKey("email") && userData.get("email") != null) {
            params.put("userEmail", userData.get("email"));
        }
        if (userData.containsKey("university") && userData.get("university") != null) {
            params.put("userUniversity", userData.get("university"));
        }
        if (userData.containsKey("degree") && userData.get("degree") != null) {
            params.put("userDegree", userData.get("degree"));
        }
        if (userData.containsKey("graduated") && userData.get("graduated") != null) {
            params.put("userGradulate", userData.get("graduated"));
        }
        if (userData.containsKey("point") && userData.get("point") != null) {
            params.put("userPoint", userData.get("point"));
        }

        userDao.updateUserProfile(params);
    }
    @Override
    public User selectUserById(String userId) {
        return userDao.selectUserById(userId);
    }

    @Override
    public void updateUserAuthority(String userId, String userAuthority) {
        userDao.updateUserAuthority(userId, userAuthority);
    }
    @Override
    public void updateChPwd(String userId, Date chPwd) {
        userDao.updateChPwd(userId, chPwd);
    }
}