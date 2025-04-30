package com.project.irumi.chatbot.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.chatbot.model.dao.ChatbotDao;
import com.project.irumi.chatbot.model.dto.ChatMsg;

@Service("chatbotService")
public class ChatbotServiceImpl implements ChatbotService{
	
	@Autowired
	private ChatbotDao chatbotDao;

	@Override
	public int insertChatMsg(ChatMsg chatMsg) {
		return chatbotDao.insertChatMsg(chatMsg);
	}

}
