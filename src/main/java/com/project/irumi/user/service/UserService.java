package com.project.irumi.user.service;

import com.project.irumi.user.model.dto.User;

public interface UserService {
    User selectUser(User user);
    boolean checkIdAvailability(String userId);
    boolean checkEmailAvailability(String email);
    void registerUser(User user);
}