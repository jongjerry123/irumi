package com.project.irumi.chatbot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.project.irumi.chatbot.context.ConvSessionManager;

@Controller
public class ChatbotController {
	
	@Autowired
	private ConvSessionManager convManager;
	
	
	
}
