package com.project.irumi.chatbot.context;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

@Component
public class ConvSessionManager {

    private final Map<String /* userId */, ConvSession> sessionMap = new ConcurrentHashMap<>();

    // 새 주제 시작 → 기존 세션 종료 후 새로 생성
    public ConvSession createNewSession(String userId, String topic) {
        ConvSession session = new ConvSession(userId, topic);
        sessionMap.put(userId, session);
        return session;
    }

    public ConvSession getSession(String userId) {
        return sessionMap.get(userId);
    }

    public void endSession(String userId) {
        sessionMap.remove(userId);
    }
}
