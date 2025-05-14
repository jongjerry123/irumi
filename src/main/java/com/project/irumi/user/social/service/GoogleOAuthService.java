package com.project.irumi.user.social.service;

import java.util.Random;

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
import com.project.irumi.user.service.UserService;
import com.project.irumi.user.social.dto.SocialUserInfo;

import jakarta.servlet.http.HttpServletRequest;

@Service("googleOAuthService")
public class GoogleOAuthService implements SocialOAuthService{

	@Value("${google.client.id}")
    private String GOOGLE_CLIENT_ID;

    @Value("${google.client.secret}")
    private String GOOGLE_CLIENT_SECRET;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private UserService userService;

    @Override
    public SocialUserInfo getUserInfo(String code, HttpServletRequest request) throws Exception {
        int loginType = 3; // Google

        String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" +
                request.getServerPort() + request.getContextPath() + "/socialCallback.do?provider=google";

        // 토큰 요청
        String tokenUrl = String.format(
                "https://oauth2.googleapis.com/token?grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
                GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, redirectUri, code);

        ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());

        if (tokenJson.has("error")) {
            throw new IllegalStateException("Google token error: " + tokenJson.get("error_description").asText());
        }

        String accessToken = tokenJson.get("access_token").asText();

        // 유저 정보 요청
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<String> userResponse = restTemplate.exchange(
                "https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, entity, String.class);

        JsonNode userJson = mapper.readTree(userResponse.getBody());

        String socialId = userJson.get("id").asText();
        String email = userJson.has("email") ? userJson.get("email").asText() : null;
        String name = userJson.has("name") ? userJson.get("name").asText() : "Google User";

        // email이 없을 경우 임시 이메일 생성
        if (email == null) {
            int suffix = 100000 + new Random().nextInt(900000);
            email = socialId + "@gmail.com" + suffix;
            while (!userService.checkEmailAvailability(email)) {
                suffix++;
                email = socialId + "@gmail.com" + suffix;
            }
        }

        return new SocialUserInfo(socialId, email, name, loginType);
    }

}	
