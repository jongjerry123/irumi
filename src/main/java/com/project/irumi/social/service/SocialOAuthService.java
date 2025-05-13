package com.project.irumi.social.service;

import com.project.irumi.social.dto.SocialUserInfo;

import jakarta.servlet.http.HttpServletRequest;

public interface SocialOAuthService {
	SocialUserInfo getUserInfo(String code, HttpServletRequest request) throws Exception;
	}
