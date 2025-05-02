package com.project.irumi.chatbot.api;


import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.project.irumi.chatbot.model.dto.CareerItemDto;

@Service
public class SerpApiService {
	

	private static final Logger logger = LoggerFactory.getLogger(SerpApiService.class);

	@Value("${serp.api.key}")
	private String serpApiKey;
    private static final String BASE_URL = "https://serpapi.com/search";

    public String searchJobSpec(String query) {
    	String gptInput="";
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
            
       

            if (serpJson.has("answer_box")) {
                JSONObject answerBox = serpJson.getJSONObject("answer_box");
                // 필요한 필드 사용
                // 1. answer_box에서 자격증 목록 가져오기
                List<Map<String, String>> certs = serpJson
                    .getJSONObject("answer_box")
                    .getJSONObject("contents")
                    .getJSONArray("formatted")
                    .toList()
                    .stream()
                    .map(o -> (Map<String, String>) o)
                    .collect(Collectors.toList());
                
                // 2. organic_results에서 설명 추출
                List<String> descriptions = serpJson
                    .getJSONArray("organic_results")
                    .toList()
                    .stream()
                    .map(obj -> ((Map<String, Object>) obj).get("snippet").toString())
                    .collect(Collectors.toList());

                // 3. GPT에 넘길 문장 조합 (최대 3~5개 정도 추려서 사용)
                List<String> gptInputLines = new ArrayList<>();
                for (int i = 0; i < Math.min(certs.size(), descriptions.size()); i++) {
                    String cert = certs.get(i).get("자격증_종류");
                    String desc = descriptions.get(i);
                    gptInputLines.add(cert + ": " + desc);
                }
                gptInput = String.join("\n", gptInputLines);
                logger.info("serpapi 검색결과: " +gptInput);
                return gptInput;//parseSearchResult(response);
                
            } else {
                logger.warn("answer_box가 SerpAPI 응답에 존재하지 않음. 대체 정보 사용.");
                // fallback 처리: organic_results 등 다른 필드를 활용하거나 빈 문자열 반환
            }

          
            
        } catch (Exception e) {
            e.printStackTrace();
            return "검색 중 오류가 발생했습니다.";
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
    
    public List<CareerItemDto> searchSerpActivity(String spec, String activityType) {
        // 예: SerpAPI를 통해 도서 / 영상 / 활동 검색
        String query = switch (activityType) {
            case "도서" -> spec + " 공부에 도움이 되는 책 제목과 저자, 출판사만 추천";
            case "영상" -> spec + " 관련 무료 유튜브 강의 추천 site:youtube.com";
            case "기타 활동" -> spec + " 관련 공모전, 대외활동, 봉사활동 소개 site:allcon.or.kr";
            default -> spec + " 관련 유용한 자료 추천";
        };

        // SerpAPI 호출 (예시로 가짜 응답 구성)
        List<CareerItemDto> result = new ArrayList<>();
        // 실제로는 serpApiService.search(query) 처럼 활용
        result.addAll(search(query, activityType));
        
        return result;
    }

    public List<CareerItemDto> search(String query, String activity) {
        List<CareerItemDto> results = new ArrayList<>();

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
                for (int i = 0; i < Math.min(3, organicResults.length()); i++) { // 최대 3개만
                    JSONObject item = organicResults.getJSONObject(i);
                    String title = item.optString("title", "제목 없음");
                    String link = item.optString("link", "");
                    
                    CareerItemDto dto = new CareerItemDto();
                    
                    switch (activity) {
                    case "도서":
                        dto.setTitle(title);
                        break;
                    case "영상":
                        dto.setTitle(title + (link.isEmpty() ? "" : " (" + link + ")"));
                        break;
                    case "기타 활동":
                        dto.setTitle(title);
                        break;
                    default:
                        dto.setTitle(title);
                        break;
                }
                    
                    dto.setType("act");

                    results.add(dto);
                }
            }

        } catch (Exception e) {
            logger.error("SerpAPI 검색 중 오류 발생", e);
        }

        return results;
    }

	
    

}


