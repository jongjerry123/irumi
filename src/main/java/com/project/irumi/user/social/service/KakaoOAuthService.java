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

@Service("kakaoOAuthService")
public class KakaoOAuthService implements SocialOAuthService {
	@Value("${kakao.client.id}")
    private String KAKAO_CLIENT_ID;

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public SocialUserInfo getUserInfo(String code, HttpServletRequest request) throws Exception {
        int loginType = 5; // Kakao

        String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" +
                request.getServerPort() + request.getContextPath() + "/socialCallback.do?provider=kakao";

        // 토큰 요청
        String tokenUrl = String.format(
                "https://kauth.kakao.com/oauth/token?grant_type=authorization_code&client_id=%s&redirect_uri=%s&code=%s",
                KAKAO_CLIENT_ID, redirectUri, code);

        ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());

        if (tokenJson.has("error")) {
            throw new IllegalStateException("Kakao token error: " + tokenJson.get("error_description").asText());
        }

        String accessToken = tokenJson.get("access_token").asText();

        // 유저 정보 요청
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<String> userResponse = restTemplate.exchange(
                "https://kapi.kakao.com/v2/user/me", HttpMethod.GET, entity, String.class);

        JsonNode userJson = mapper.readTree(userResponse.getBody());

        String socialId = userJson.get("id").asText();
        String email = userJson.get("kakao_account").get("email") != null
                ? userJson.get("kakao_account").get("email").asText() : null;
        String name = userJson.get("properties").get("nickname").asText();
        if (name == null) {
            name = "Kakao User";
        }

        return new SocialUserInfo(socialId, email, name, loginType);
    }

}
