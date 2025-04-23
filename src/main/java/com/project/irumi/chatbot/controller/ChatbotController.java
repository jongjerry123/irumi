package com.project.irumi.chatbot.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChatbotController {

	@RequestMapping("startActRecChat.do")
	public String ViewActChatBot() {
		return "chatbot/act";
	}
	
	@RequestMapping("startJobRecChat.do")
	public String ViewJobChatBot() {
		return "chatbot/job";
	}
	
	@RequestMapping("startSpecRecChat.do")
	public String ViewSpecChatBot() {
		return "chatbot/spec";
	}
	
	@RequestMapping("startScheduleRecChat.do")
	public String ViewScheduleChatBot() {
		return "chatbot/schedule";
	}
	
}
