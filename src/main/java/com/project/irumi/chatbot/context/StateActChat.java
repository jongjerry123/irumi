package com.project.irumi.chatbot.context;

public enum StateActChat implements ChatState{
	/*예시로 작성한 내용임.*/
	START,                        // 활동 추천 시작
    RECOMMEND_RESOURCE,           // 관련 추천 자료 제공 (도서/영상 등)
    ASK_REQUIRED_SKILL,          // 필요한 능력/지식/조건 질문
    SELECT_SPEC_TOPIC,           // 어떤 스펙 항목에 대해 추천 받을지 선택
    COMPLETE                     // 추천 종료
}