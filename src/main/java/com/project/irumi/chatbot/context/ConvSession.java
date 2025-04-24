package com.project.irumi.chatbot.context;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ConvSession {
	private final String convId = UUID.randomUUID().toString();
    private final String topic;
    private String userId;
    private final List<String> contextHistory = new ArrayList<>();

    public ConvSession(String topic, String userId) {
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

}
