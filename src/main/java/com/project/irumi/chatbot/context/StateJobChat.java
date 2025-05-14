package com.project.irumi.chatbot.context;

public enum StateJobChat implements ChatState {
    START(null),  // 시작 상태이므로 질문 없음

    ASK_PERSONALITY("희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요."),
    ASK_JOB_CHARACTERISTIC("희망 직무의 특성(예: 연봉, 문화, 업무 방식)을 말씀해주세요."),
    ASK_WORK_CHARACTERISTIC("희망하는 업계가 있다면 알려 주세요.(예: IT, 부동산, 연예계 등)"),
    ASK_WANT_MORE_OPT("더 많은 추천을 받아보고 싶으신가요?"),
    COMPLETE("추천을 마쳤습니다. 도움이 되었기를 바랍니다!"),
    REC_TYPE("어떻게 추천받고 싶으세요?");
	
    private final String prompt;

    StateJobChat(String prompt) {
        this.prompt = prompt;
    }

    public String getPrompt() {
        return prompt;
    }
}
