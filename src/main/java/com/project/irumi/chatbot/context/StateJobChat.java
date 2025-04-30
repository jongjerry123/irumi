package com.project.irumi.chatbot.context;

public enum StateJobChat implements ChatState{
	START,               // 대화 시작 직후
    ASK_PERSONALITY,           //희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 설명해주세요.
    ASK_JOB_CHARACTERISTIC,       //직무 추천에 도움이 될 원하는 직무의 특성을 설명해주세요. (연봉수준, 문화, 업무 특성 등)
    ASK_WORK_CHARACTERISTIC, // 원하는 업무의 유형이나 특성
    ASK_WANT_MORE_OPT,            // 더 추천할지 여부 질문
    COMPLETE             // 직무 추천 완료
}
