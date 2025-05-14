package com.project.irumi.user.social.service;

import com.project.irumi.user.social.dto.SocialUserInfo;

import jakarta.servlet.http.HttpServletRequest;

public interface SocialOAuthService {
	SocialUserInfo getUserInfo(String code, HttpServletRequest request) throws Exception;
	}
