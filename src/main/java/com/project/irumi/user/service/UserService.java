package com.project.irumi.user.service;

import java.sql.Date;
import java.util.Map;

import com.project.irumi.user.model.dto.User;

public interface UserService {
	//로그인용 
    User selectUser(User user);
    //아이디 중복 확인
    boolean checkIdAvailability(String userId);
    //이메일 중복 확인
    boolean checkEmailAvailability(String email);
    //회원가입
    void registerUser(User user);
    //이메일로 아이디 찾기
    String findIdByEmail(String email);
    //아이디와 이메일 맞는 지 매치
    boolean checkUserMatch(String userId, String email);
    //비밀번호 업데이트
    void updatePassword(String userId, String encodedPassword);
    User findUserBySocialId(String socialId, int loginType);
    void updateUserProfile(Map<String, Object> userData);
    User selectUserById(String userId);
    void updateUserAuthority(String userId, String userAuthority);
    void updateChPwd(String userId, Date chPwd);
    String selectUserAuthority(String socialId);
}