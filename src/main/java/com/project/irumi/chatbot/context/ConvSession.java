package com.project.irumi.chatbot.context;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ConvSession {
	private final String convId = UUID.randomUUID().toString();
	private final String topic;          // 대화 주제: job / spec / act / schedule
    private String subtopicId = null;    // 서브 주제 ID (직무 ID or 스펙 ID 등)
    private String userId;
    private final List<String> contextHistory = new ArrayList<>();

    public ConvSession(String userId, String topic) {  /// 수정
    	// 현재는 subtopic이 세션 중에 변경 가능한 주제인듯?
        this.topic = topic;
        this.userId = userId;
    }

    public void appendMessage(String role, String content) {
        contextHistory.add(role + ": " + content);
    }

    public String getContext() {
        return String.join("\n", contextHistory);
    }

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

}
