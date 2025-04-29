package com.project.irumi.chatbot.context;

public enum StateActChat implements ChatState{
	/*예시로 작성한 내용임.*/
	START,                  // 1. 활동 추천 대화 시작 ("활동 추천을 시작합니다!")
    INPUT_SPEC,             // 2. 어떤 '스펙(자격증/분야)'에 대한 활동을 추천받을지 입력받기
    CHOOSE_ACTIVITY_TYPE,   // 3. 추천받고 싶은 활동 유형 선택 (도서/영상/기타 활동)
    RECOMMEND,              // 4. 해당 스펙 + 유형 기반 활동 추천
    SHOW_MORE_OPTIONS      // 5. 추가 추천/다른 유형/종료 등 옵션 제공 
               
}