package com.project.irumi.chatbot.model.dto;
import java.util.List;

import com.project.irumi.dashboard.model.dto.Job;
public class ChatbotResponseDTO {
	
	private String gptAnswer;
	//private List<String> checkboxOptions;
	 private List<CareerItemDTO> checkboxOptions;
	   
   private List<String> options; // 선택지가 없으면 null or 빈 리스트
  
   

   
   // 생성자 + getters/ setters
	public ChatbotResponseDTO() {
		super();
	}
	
	
	
	public ChatbotResponseDTO(String gptAnswer) {
		super();
		this.gptAnswer = gptAnswer;
	}



	public ChatbotResponseDTO(String gptAnswer, List<String> options) {
		super();
		this.gptAnswer = gptAnswer;
		this.options = options;
		this.checkboxOptions = null;
	}
	
	
//	public ChatbotResponseDto(String gptAnswer, List<String> checkboxOptions, List<String> options) {
//		super();
//		this.gptAnswer = gptAnswer;
//		this.checkboxOptions = checkboxOptions;
//		this.options = options;
//	}
	
	public ChatbotResponseDTO(String gptAnswer, List<CareerItemDTO> checkboxOption, List<String> options) {
		super();
		this.gptAnswer = gptAnswer;
		this.checkboxOptions = checkboxOption;
		this.options = options;
	}

	

//	public List<String> getCheckboxOptions() {
//		return checkboxOptions;
//	}
//	public void setCheckboxOptions(List<String> checkboxOptions) {
//		this.checkboxOptions = checkboxOptions;
//	}
	public List<CareerItemDTO> getCheckboxOptions() {
		return checkboxOptions;
	}
	public void setCheckboxOptions(List<CareerItemDTO> checkboxOptions) {
		this.checkboxOptions = checkboxOptions;
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

