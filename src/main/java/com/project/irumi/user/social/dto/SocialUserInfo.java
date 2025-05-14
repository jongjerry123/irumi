package com.project.irumi.user.social.dto;

public class SocialUserInfo implements java.io.Serializable{

	private static final long serialVersionUID = 8375752639493972157L;
	private String socialId;
	private String email;
	private String name;
	private int loginType;
	
	public SocialUserInfo() {
		super();
	}

	public SocialUserInfo(String socialId, String email, String name, int loginType) {
		super();
		this.socialId = socialId;
		this.email = email;
		this.name = name;
		this.loginType = loginType;
	}

	public String getSocialId() {
		return socialId;
	}

	public void setSocialId(String socialId) {
		this.socialId = socialId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getLoginType() {
		return loginType;
	}

	public void setLoginType(int loginType) {
		this.loginType = loginType;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "SocialUserInfo [socialId=" + socialId + ", email=" + email + ", name=" + name + ", loginType="
				+ loginType + "]";
	}
	
	

	
}
