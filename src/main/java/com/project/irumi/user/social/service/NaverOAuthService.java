package com.project.irumi.user.social.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.irumi.user.social.dto.SocialUserInfo;

import jakarta.servlet.http.HttpServletRequest;

@Service("naverOAuthService")
public class NaverOAuthService implements SocialOAuthService {

	@Value("${naver.client.id}")
	private String NAVER_CLIENT_ID;

	@Value("${naver.client.secret}")
	private String NAVER_CLIENT_SECRET;

	@Autowired
	private RestTemplate restTemplate;

	@Override
	public SocialUserInfo getUserInfo(String code, HttpServletRequest request) throws Exception {
		int loginType = 4; // Naver

		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/socialCallback.do?provider=naver";

// 토큰 요청
		String tokenUrl = String.format(
				"https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s",
				NAVER_CLIENT_ID, NAVER_CLIENT_SECRET, code);

		ResponseEntity<String> tokenResponse = restTemplate.getForEntity(tokenUrl, String.class);

		ObjectMapper mapper = new ObjectMapper();
		JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());

// 토큰 응답 에러 처리
		if (tokenJson.has("error")) {
			throw new IllegalStateException("Naver token error: " + tokenJson.get("error_description").asText());
		}

// access_token 추출
		String accessToken = tokenJson.get("access_token").asText();

// 유저 정보 요청
		HttpHeaders headers = new HttpHeaders();
		headers.setBearerAuth(accessToken);
		HttpEntity<?> entity = new HttpEntity<>(headers);

		ResponseEntity<String> userResponse = restTemplate.exchange("https://openapi.naver.com/v1/nid/me",
				HttpMethod.GET, entity, String.class);

		JsonNode userJson = mapper.readTree(userResponse.getBody());

// 'response' 필드가 없는 경우 예외 처리
		JsonNode responseNode = userJson.get("response");
		if (responseNode == null) {
			throw new IllegalStateException("Naver user response missing 'response' field.");
		}

// 'id', 'email', 'nickname' 필드가 있는지 체크 후 처리
		String socialId = responseNode.has("id") ? responseNode.get("id").asText() : null;
		String email = responseNode.has("email") ? responseNode.get("email").asText() : null;
		String name = responseNode.has("nickname") ? responseNode.get("nickname").asText() : "Naver User"; // 기본값 설정

// 이메일이 없을 경우 기본 이메일 생성
		if (email == null) {
			email = socialId + "@naver.com"; // 이메일을 socialId 기반으로 설정
		}

		return new SocialUserInfo(socialId, email, name, loginType);
	}
}