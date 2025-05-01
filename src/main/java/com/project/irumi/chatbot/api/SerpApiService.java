package com.project.irumi.chatbot.api;


import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;



@Service
public class SerpApiService {
	
	@Value("${serp.api.key}")
	private String serpApiKey;
    private static final String BASE_URL = "https://serpapi.com/search";

    public String searchExamSchedule(String query) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            
            String refinedQuery = query + " 시험 일정";
            String encodedQuery = URLEncoder.encode(refinedQuery, StandardCharsets.UTF_8.toString());


            URI uri = UriComponentsBuilder.fromHttpUrl(BASE_URL)
            	    .queryParam("q", encodedQuery) // 인코딩된 검색어
            	    .queryParam("hl", "ko")
            	    .queryParam("gl", "kr")
            	    .queryParam("engine", "google")
            	    .queryParam("api_key", serpApiKey)
            	    .build(true)
            	    .toUri();

            // API 호출
            String response = restTemplate.getForObject(uri, String.class);
            
            return parseSearchResult(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "검색 중 오류가 발생했습니다.";
        }
    }
    
    private String parseSearchResult(String json) {
        try {
            JSONObject obj = new JSONObject(json);

            // 첫 번째 검색 결과 링크
            String link = "";
            JSONArray results = obj.optJSONArray("organic_results");
            if (results != null && results.length() > 0) {
                link = results.getJSONObject(0).optString("link", "");
            }

            // ✅ 메시지 구성
            StringBuilder sb = new StringBuilder();
       

            if (!link.isBlank()) {
            	sb.append("📚 입력하신 시험 일정은 관련 링크를 참조해 주세요!<br>")
            	.append("🔗 <a href='").append(link).append("' target='_blank'>공식 사이트 바로가기</a>");
            } else {
                sb.append("🔗 공식 링크를 찾을 수 없습니다. 공식 기관 웹사이트를 참고해 보세요.");
            }

            return sb.toString();

        } catch (Exception e) {
            e.printStackTrace();
            return "검색 결과를 파싱하는 도중 오류가 발생했습니다.";
        }
    }
    

}


