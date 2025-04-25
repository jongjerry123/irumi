package com.project.irumi.chatbot.context;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

import com.project.irumi.chatbot.model.dto.CareerItemDto;
import com.project.irumi.chatbot.model.dto.ChatbotResponseDto;

/* 
한 유저는 항상 하나의 세션만 가질 수 있다
다른 탭으로 넘어가면 기존 세션은 삭제되고 새로 시작된다
서버는 항상 로그인 유저의 userId를 알고 있다
 */

@Component
public class ConvSessionManager {

    private final Map<String /* userId */, ConvSession> sessionMap = new ConcurrentHashMap<>();

    // 새 주제 시작 → 기존 세션 종료 후 새로 생성
    public ConvSession createNewSession(String userId, String topic) {
    	//이미 진행중인 세션이 있는데 호출됐다면 이전 세션 종료
    	if (sessionMap.get(userId)!=null) {
    		sessionMap.remove(userId);
    	}
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

    //세션의 subtopic 아이디 지정.
	public void setConvSubTopic(ConvSession session, CareerItemDto selectedItem) {
		session.setSubtopicId(selectedItem.getItemId());
	}
}
