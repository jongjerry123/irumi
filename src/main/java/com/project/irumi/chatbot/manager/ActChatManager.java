package com.project.irumi.chatbot.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.api.GptApiService;
import com.project.irumi.chatbot.context.ConvSession;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

@Component
public class ActChatManager {

	@Autowired
	private GptApiService gptApiService;
	
	 public ChatbotResponseDto getGptResponse(ConvSession session, String userMsg) {
	        String context = session.getContext();
	        String prompt = context + "\nuser: " + userMsg;
	        String gptAnswer = gptApiService.callGPT(prompt);

	        session.appendMessage("user", userMsg);
	        session.appendMessage("assistant", gptAnswer);

	        List<String> options = new ArrayList<>();
	        options.add("더 추천받기");
	        options.add("대시보드에 저장");

	        return new ChatbotResponseDto(gptAnswer, options);
	    }

	public ChatbotResponseDto handleChatbotOption(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}

	public ChatbotResponseDto setConvSubTopic(ConvSession session, String userChoice) {
		// TODO Auto-generated method stub
		return null;
	}

	
}
