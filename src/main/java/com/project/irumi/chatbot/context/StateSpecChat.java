package com.project.irumi.chatbot.context;


public enum StateSpecChat implements ChatState {
	
	START("내게 맞는 직무 찾기 세션입니다.\\r\\n\" + \"먼저, 희망 직무 추천에 도움이 될 사용자님의 특성(성격, 강점, 가치관 등)을 말해주세요."),

    TEXT_CURRENT_SPEC("현재 가지고 있는 스펙이나 경험을 알려주세요."),

    OPT_SPEC_TYPE("어떤 종류의 스펙 추천을 받고 싶으신가요?"),

    ASK_WANT_MORE_OPT("추가로 더 추천받고 싶으신가요?"),

    COMPLETE("추천을 완료했습니다. 준비 잘하시길 응원합니다."),

    UNKNOWN("알 수 없는 상태입니다. 처음부터 다시 시도해주세요.");

    private final String prompt;

    StateSpecChat(String prompt) {
        this.prompt = prompt;
    }

    public String getPrompt() {
        return prompt;
    }
}
