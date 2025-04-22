package com.project.irumi.chatbot.model.dao;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public class ChatbotDao {
	public void insertChatMsg(ChatMsg msg);
}
