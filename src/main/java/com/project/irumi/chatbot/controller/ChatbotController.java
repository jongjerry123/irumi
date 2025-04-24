package com.project.irumi.chatbot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.irumi.chatbot.context.ConvSessionManager;
import com.project.irumi.chatbot.manager.ActChatManager;
import com.project.irumi.chatbot.manager.JobChatManager;
import com.project.irumi.chatbot.manager.SpecChatManager;
import com.project.irumi.chatbot.manager.SsChatManager;

@Controller
public class ChatbotController {

	@Autowired
	private ConvSessionManager convManager;
	
	@Autowired private JobChatManager jobManager;
	@Autowired private SpecChatManager specManager;
	@Autowired private SsChatManager ssManager;
	@Autowired private ActChatManager actManager;


	// 탭별로 뷰페이지 내보내기 용도 ===========================
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
	
	// 유저가 탭 내에서 대화 시작하기 버튼 누른 경우 ===========================
	// 세션매니저 관리 시작 (tab 유형에 따라 session 정보 저장)
	
	// 유저가 대화를 시작한 후 메세지 전송버튼 클릭한 경우 ===========================
	// tab 정보에 따라 매니저 서비스 호출
	
	//유저가 챗봇이 준 옵션 중 선택 후 제
}
