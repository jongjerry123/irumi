package com.project.irumi.chatbot.context;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ConvSession {
	private final String convId = UUID.randomUUID().toString();
    private final String topic;
    private final List<String> contextHistory = new ArrayList<>();

    public ConvSession(String topic) {
        this.topic = topic;
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

}
