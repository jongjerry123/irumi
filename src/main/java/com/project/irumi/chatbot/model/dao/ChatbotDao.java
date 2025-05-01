package com.project.irumi.chatbot.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.chatbot.model.dto.ChatMsg;


@Repository("chatbotDao")
public class ChatbotDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public int insertChatMsg(ChatMsg chatMsg) {
		return sqlSessionTemplate.insert("messageMapper.insertOneMsg", chatMsg);
	}
}
	