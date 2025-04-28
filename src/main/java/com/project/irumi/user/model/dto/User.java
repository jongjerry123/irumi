package com.project.irumi.user.model.dto;

import java.sql.Date;
import java.time.LocalDateTime;

public class User implements java.io.Serializable{

	private static final long serialVersionUID = -4114402821168721701L;
	private String userId;
	private String userPwd;
	private String userName;
	private String userEmail;
	private java.sql.Date registDate;
	private String userUniversity;
	private String userDegree;
	private String userGradulate;
	private double userPoint;
	private String userAuthority;
	private int userLoginType;
	private String userSocialId;
	private String emailVerification;
	private String emailVerificationToken;
	private java.sql.Date emailTokenExpiry;
	private java.sql.Date chPWD;
	//constructor
	public User() {
		super();
	}
	public User(String userId, String userPwd, String userName, String userEmail, Date registDate,
			String userUniversity, String userDegree, String userGradulate, double userPoint, String userAuthority,
			int userLoginType, String userSocialId, String emailVerification, String emailVerificationToken,
			Date emailTokenExpiry, Date chPWD) {
		super();
		this.userId = userId;
		this.userPwd = userPwd;
		this.userName = userName;
		this.userEmail = userEmail;
		this.registDate = registDate;
		this.userUniversity = userUniversity;
		this.userDegree = userDegree;
		this.userGradulate = userGradulate;
		this.userPoint = userPoint;
		this.userAuthority = userAuthority;
		this.userLoginType = userLoginType;
		this.userSocialId = userSocialId;
		this.emailVerification = emailVerification;
		this.emailVerificationToken = emailVerificationToken;
		this.emailTokenExpiry = emailTokenExpiry;
		this.chPWD = chPWD;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPwd() {
		return userPwd;
	}
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public java.sql.Date getRegistDate() {
		return registDate;
	}
	public void setRegistDate(java.sql.Date registDate) {
		this.registDate = registDate;
	}
	public String getUserUniversity() {
		return userUniversity;
	}
	public void setUserUniversity(String userUniversity) {
		this.userUniversity = userUniversity;
	}
	public String getUserDegree() {
		return userDegree;
	}
	public void setUserDegree(String userDegree) {
		this.userDegree = userDegree;
	}
	public String getUserGradulate() {
		return userGradulate;
	}
	public void setUserGradulate(String userGradulate) {
		this.userGradulate = userGradulate;
	}
	public double getUserPoint() {
		return userPoint;
	}
	public void setUserPoint(double userPoint) {
		this.userPoint = userPoint;
	}
	public String getUserAuthority() {
		return userAuthority;
	}
	public void setUserAuthority(String userAuthority) {
		this.userAuthority = userAuthority;
	}
	public int getUserLoginType() {
		return userLoginType;
	}
	public void setUserLoginType(int userLoginType) {
		this.userLoginType = userLoginType;
	}
	public String getUserSocialId() {
		return userSocialId;
	}
	public void setUserSocialId(String userSocialId) {
		this.userSocialId = userSocialId;
	}
	public String getEmailVerification() {
		return emailVerification;
	}
	public void setEmailVerification(String emailVerification) {
		this.emailVerification = emailVerification;
	}
	public String getEmailVerificationToken() {
		return emailVerificationToken;
	}
	public void setEmailVerificationToken(String emailVerificationToken) {
		this.emailVerificationToken = emailVerificationToken;
	}
	public java.sql.Date getEmailTokenExpiry() {
		return emailTokenExpiry;
	}
	public void setEmailTokenExpiry(java.sql.Date emailTokenExpiry) {
		this.emailTokenExpiry = emailTokenExpiry;
	}
	public java.sql.Date getChPWD() {
		return chPWD;
	}
	public void setChPWD(java.sql.Date chPWD) {
		this.chPWD = chPWD;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	@Override
	public String toString() {
		return "User [userId=" + userId + ", userPwd=" + userPwd + ", userName=" + userName + ", userEmail=" + userEmail
				+ ", registDate=" + registDate + ", userUniversity=" + userUniversity + ", userDegree=" + userDegree
				+ ", userGradulate=" + userGradulate + ", userPoint=" + userPoint + ", userAuthority=" + userAuthority
				+ ", userLoginType=" + userLoginType + ", userSocialId=" + userSocialId + ", emailVerification="
				+ emailVerification + ", emailVerificationToken=" + emailVerificationToken + ", emailTokenExpiry="
				+ emailTokenExpiry + ", chPWD=" + chPWD + "]";
	}
	

}
