package com.project.irumi.user.service;

import java.util.Map;

import com.project.irumi.user.model.dto.User;

public interface UserService {
    User selectUser(User user);
    boolean checkIdAvailability(String userId);
    boolean checkEmailAvailability(String email);
    void registerUser(User user);
    String findIdByEmail(String email);
    boolean checkUserMatch(String userId, String email);
    void updatePassword(String userId, String encodedPassword);
    User findUserBySocialId(String socialId, int loginType);
    void updateUserProfile(Map<String, Object> userData);
}