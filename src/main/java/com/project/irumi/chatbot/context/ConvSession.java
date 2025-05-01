package com.project.irumi.chatbot.context;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;



public class ConvSession {
	private final String convId = UUID.randomUUID().toString();
	private final String topic;          // 대화 주제: job / spec / act / ss
	private String subtopicId = null;    // 서브 주제 ID (직무 ID or 스펙 ID 등)
	private String userId;
	private String gettedSpec;	 	// 갖고 있던 스펙 (자격증 공모전수상 등)
	

	

	// 추가
	private String lastTopic;
	// 추가 활동 타입 (도서, 영상, 기타 등등)
	private String lastActivityType;
	


	private final List<String> contextHistory = new ArrayList<>();
	

	// ✅ 하나의 상태만 관리
	private ChatState chatState;

	// ✅ 생성자
	public ConvSession(String userId, String topic) {
		this.userId = userId;
		this.topic = topic;
		this.chatState = resolveInitialState(topic); // 초기 상태 자동 세팅
	}

	private ChatState resolveInitialState(String topic) {
		switch (topic) {
			case "job":
				return StateJobChat.ASK_PERSONALITY;
			case "spec":
				return StateSpecChat.TEXT_CURRENT_SPEC;
			case "ss":
				return StateSsChat.SERP_SEARCH;
			case "act":
				return StateActChat.INPUT_SPEC;
			default:
				throw new IllegalArgumentException("Invalid topic: " + topic);
		}
	}

	public List<String> getContextHistory() {
		return contextHistory;
	}

	public void addToContextHistory(String text ) {
		contextHistory.add(text +"\n");
	}

	// ✅ 대화 기록 저장
	public void appendMessage(String role, String content) {
		contextHistory.add(role + ": " + content);
	}

	// ✅ 전체 대화 컨텍스트 가져오기
	public String getContext() {
		return String.join("\n", contextHistory);
	}

	// ✅ Getter/Setter
	public String getConvId() {
		return convId;
	}

	public String getTopic() {
		return topic;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSubtopicId() {
		return subtopicId;
	}

	public void setSubtopicId(String subtopicId) {
		this.subtopicId = subtopicId;
	}

	public ChatState getChatState() {
		return chatState;
	}

	public void setChatState(ChatState chatState) {
		this.chatState = chatState;
	}
	
	// --- 추가 ---------------------------
    public String getLastTopic() {
        return lastTopic;
    }
    public void setLastTopic(String lastTopic) {
        this.lastTopic = lastTopic;
    }
    public String getLastActivityType() {
        return lastActivityType;
    }
    public void setLastActivityType(String lastActivityType) {
        this.lastActivityType = lastActivityType;
    }
    
    
    //  추가
	public String getGettedSpec() {
		return gettedSpec;
	}

	public void setGettedSpec(String gettedSpec) {
		this.gettedSpec = gettedSpec;
	}

    
    


}


