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
    //소셜아이디 찾기용
    User findUserBySocialId(String socialId, int loginType);
    //마이페이지 업데이트용
    void updateUserProfile(Map<String, Object> userData);
    //아이디로 유저 찾기
    User selectUserById(String userId);
    //유저 권한 업데이트
    void updateUserAuthority(String userId, String userAuthority);
    //유저 비밀번호 최종 변경일 수정
    void updateChPwd(String userId, Date chPwd);
    //소셜 유저 권한 조회용
    String selectUserAuthority(String socialId);
    //유저 인증 정보 업데이트
	void updateUserVerification(User user);
	//유저 아이디로 권한 조회
	String selectUserAuthorityByUserId(String userId);
}