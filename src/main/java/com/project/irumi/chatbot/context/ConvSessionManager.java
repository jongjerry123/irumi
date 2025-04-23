package com.project.irumi.chatbot.context;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

@Component
public class ConvSessionManager {
	  private final Map<String, ConvSession> sessionMap = new ConcurrentHashMap<>();

	    public ConvSession createSession(String topic) {
	        ConvSession conv = new ConvSession(topic);
	        sessionMap.put(conv.getConvId(), conv);
	        return conv;
	    }

	    public ConvSession getSession(String convId) {
	        return sessionMap.get(convId);
	    }

	    public void endSession(String convId) {
	        sessionMap.remove(convId);
	    }

}
