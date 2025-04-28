package com.project.irumi.chatbot.context;

public enum StateSpecChat implements ChatState {
	//START,                 // 스펙 추천 대화 시작
    TEXT_CURRENT_SPEC,   // 현재 가진 스펙 정보 받기
    OPT_SPEC_TYPE,          //  관심 있는 스펙 타입 선택(옵션 - 자격증, 어학, 인턴십, 대회/공모전, 자기계발, 기타)
    ASK_WANT_MORE_OPT,    // 스펙 추천 더 원하는지
    COMPLETE               // 스펙 추천 완료
}
