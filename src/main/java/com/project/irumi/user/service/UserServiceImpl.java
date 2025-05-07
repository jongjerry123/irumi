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
    //로그인용 쿼리
    @Override
    public User selectUser(User user) {
        return userDao.selectUser(user);
    }
    //아이디 중복 확인용
    @Override
    public boolean checkIdAvailability(String userId) {
        return userDao.countByUserId(userId) == 0;
    }
    //이메일 중복확인용
    @Override
    public boolean checkEmailAvailability(String email) {
        return userDao.countByEmail(email) == 0;
    }
    //회원가입용 
    @Override
    public void registerUser(User user) {
        user.setUserPwd(bcryptPasswordEncoder.encode(user.getUserPwd()));
        userDao.registerUser(user);
    }
    //이메일로 아이디 조회 
    @Override
    public String findIdByEmail(String email) {
        return userDao.findIdByEmail(email);
    }
    //아이디와 이메일 매치 확인용
    @Override
    public boolean checkUserMatch(String userId, String email) {
        return userDao.countByUserIdAndEmail(userId, email) > 0;
    }
    //소셜로그인
    @Override
    public User findUserBySocialId(String socialId, int loginType) {
        return userDao.findUserBySocialId(socialId, loginType);
    }
    //비밀번호 변경
    @Override
    public void updatePassword(String userId, String encodedPassword) {
        userDao.updatePassword(userId, encodedPassword);
    }
    //마이페이지 업데이트용
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
    //아이디 찾기
    @Override
    public User selectUserById(String userId) {
        return userDao.selectUserById(userId);
    }
    //권한 수정
    @Override
    public void updateUserAuthority(String userId, String userAuthority) {
        userDao.updateUserAuthority(userId, userAuthority);
    }
    //비밀번호 변경일 갱신용
    @Override
    public void updateChPwd(String userId, Date chPwd) {
        userDao.updateChPwd(userId, chPwd);
    }
    //소셜유저 권환 확인용
	@Override
	public String selectUserAuthority(String socialId) {
		return userDao.selectUserAuthority(socialId);
	}
    
}