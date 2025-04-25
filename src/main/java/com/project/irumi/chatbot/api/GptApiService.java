package com.project.irumi.chatbot.api;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;
import org.springframework.context.annotation.PropertySource;


@Component
@PropertySource("classpath:application.properties")
public class GptApiService {
    @Value("${openai.api.key}")
    private String openaiApiKey;

    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    public String callGPT(String prompt) {
    	
    	System.out.println("GPT API KEY: " + openaiApiKey);
    	
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(openaiApiKey);

        Map<String, Object> body = new HashMap<>();
        body.put("model", "gpt-3.5-turbo"); 
        List<Map<String, String>> messages = new ArrayList<>();
        messages.add(Map.of("role", "user", "content", prompt));
        body.put("messages", messages);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity(OPENAI_API_URL, entity, Map.class);

        List<Map> choices = (List<Map>) response.getBody().get("choices");
        Map message = (Map) choices.get(0).get("message");
        String gptReply = (String) message.get("content");
        return gptReply.trim();
    }
}


