package com.project.irumi.chatbot.context;

public enum StateSsChat implements ChatState{
	START,                // 일정 추천 대화 시작
    SERP_SEARCH,       // 스펙 관련 어떤 일정을 알고 싶은지 묻기 (필기 시험 시작일? 실기 시작일?)
    ASK_WANT_MORE, // 더 알고 싶은 일정이 있는지 묻기(y/n)
    COMPLETE // 종료
}
