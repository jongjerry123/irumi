package com.project.irumi.chatbot.api;


import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.project.irumi.chatbot.model.dto.CareerItemDTO;

@Service
public class SerpApiService {
	

	private static final Logger logger = LoggerFactory.getLogger(SerpApiService.class);

	@Value("${serp.api.key}")
	private String serpApiKey;
    private static final String BASE_URL = "https://serpapi.com/search";

    public String searchJobSpec(String query) {
        String gptInput = "";
        try {
            RestTemplate restTemplate = new RestTemplate();
            
            String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8.toString());

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
            JSONObject serpJson = new JSONObject(response);
            
            logger.info(response);
            
            // 'organic_results' 확인
            if (serpJson.has("organic_results") && serpJson.getJSONArray("organic_results").length() > 0) {
                JSONArray organicResults = serpJson.getJSONArray("organic_results");
                
                // organic_results에서 정보 추출
                List<String> descriptions = new ArrayList<>();
                for (int i = 0; i < organicResults.length(); i++) {
                    JSONObject result = organicResults.getJSONObject(i);
                    String title = result.getString("title");
                    String snippet = result.getString("snippet");
                    
                    // 필요 시 제목과 설명을 조합하여 결과에 추가
                    descriptions.add(title + ": " + snippet);
                }

                // 최대 3개까지만 추출하여 GPT 입력 준비
                gptInput = String.join("\n", descriptions.subList(0, Math.min(descriptions.size(), 7)));
                logger.info("serpapi 검색결과: " + gptInput);
            } else {
                // 'organic_results'가 없을 때 대체 처리
                logger.warn("organic_results가 SerpAPI 응답에 존재하지 않음. 대체 정보 사용.");
                
                // 대체 정보 사용
                gptInput = "검색 결과가 없습니다. 관련 자격증이나 경력에 대해 다시 시도해 주세요.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            gptInput = "검색 중 오류가 발생했습니다.";
        }
        return gptInput;
    }


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
            	.append("🔗 <a href='").append(link).append("' target='_blank' class='custom-link'>공식 사이트 바로가기</a>");
            } else {
                sb.append("🔗 공식 링크를 찾을 수 없습니다. 공식 기관 웹사이트를 참고해 보세요.");
            }

            return sb.toString();

        } catch (Exception e) {
            e.printStackTrace();
            return "검색 결과를 파싱하는 도중 오류가 발생했습니다.";
        }
    }
    
	
    public List<CareerItemDTO> searchSerpActivity(String spec, String activityType, Set<String> excludedTitles) {
    	String query = switch (activityType) {
    		case "도서" -> "%s 공부에 도움이 되는 책 제목과 저자, 출판사만 추천해".formatted(spec);
    		case "영상" -> "%s 관련 무료 유튜브 영상 추천 site:youtube.com".formatted(spec);
//    		case "기타 활동" -> spec + " 관련 공모전, 대외활동, 봉사활동 소개 site:allcon.or.kr";
    		default -> spec + " 관련 유용한 자료 추천";
    	};

    	return search(query, activityType, excludedTitles);
    }

	public List<CareerItemDTO> search(String query, String activity, Set<String> excludedTitles) {
		List<CareerItemDTO> results = new ArrayList<>();

		try {
			RestTemplate restTemplate = new RestTemplate();
			String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8.toString());

			URI uri = UriComponentsBuilder.fromHttpUrl(BASE_URL)
					.queryParam("q", encodedQuery)
					.queryParam("hl", "ko")
					.queryParam("gl", "kr")
					.queryParam("engine", "google")
					.queryParam("api_key", serpApiKey)
					.build(true)
					.toUri();

			String response = restTemplate.getForObject(uri, String.class);
			JSONObject json = new JSONObject(response);
			JSONArray organicResults = json.optJSONArray("organic_results");
			
			if (organicResults != null) {
				for (int i = 0; i < Math.min(9, organicResults.length()); i++) { // 최대 9개 
					JSONObject item = organicResults.getJSONObject(i);
					String title = item.optString("title", "제목 없음");
					String link = item.optString("link", "");
					
					String pureTitle = title.split(" \\(")[0].trim();

					boolean isDuplicate = excludedTitles.stream().anyMatch(ex -> isSimilar(title, ex));
					if (isDuplicate) continue;

					CareerItemDTO dto = new CareerItemDTO();
					dto.setTitle(activity.equals("영상") && !link.isEmpty() ? title + " (" + link + ")" : title);
					dto.setType("act");

					results.add(dto);
					if (results.size() >= 3) break; // 최대 3개만
				}
			}

		} catch (Exception e) {
			logger.error("SerpAPI 검색 중 오류 발생", e);
		}

		return results;
	}

	private boolean isSimilar(String a, String b) {
		a = a.toLowerCase();
		b = b.toLowerCase();

		int maxLength = Math.max(a.length(), b.length());
		if (maxLength == 0) return true;

		int distance = org.apache.commons.lang3.StringUtils.getLevenshteinDistance(a, b);
		return ((double) distance / maxLength) < 0.3; // 70% 이상 유사하면 중복 처리
	}
    

}


