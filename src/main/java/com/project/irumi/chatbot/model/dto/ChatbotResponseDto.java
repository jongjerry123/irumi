package com.project.irumi.chatbot.model.dto;

import java.util.List;

public class ChatbotResponseDto {
	
	private String gptAnswer;
    private List<String> options; // 선택지가 없으면 null or 빈 리스트
    
    // 생성자 + getters/ setters
	public ChatbotResponseDto() {
		super();
	}
	public ChatbotResponseDto(String gptAnswer, List<String> options) {
		super();
		this.gptAnswer = gptAnswer;
		this.options = options;
	}
	public String getGptAnswer() {
		return gptAnswer;
	}
	public void setGptAnswer(String gptAnswer) {
		this.gptAnswer = gptAnswer;
	}
	public List<String> getOptions() {
		return options;
	}
	public void setOptions(List<String> options) {
		this.options = options;
	}
	

}
