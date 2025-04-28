<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>이용 약관</title>
<style>
body {
    background-color: #111;
    color: #fff;
    font-family: 'Arial', sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}

.container {
    background-color: #1e1e1e;
    border-radius: 10px;
    padding: 40px;
    width: 400px; /* register.jsp와 동일 */
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}

h2 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 24px;
}

.terms-section {
    margin-bottom: 20px;
}

.terms-box {
    background-color: #333;
    padding: 15px;
    height: 150px;
    overflow-y: scroll; /* 항상 스크롤바 표시 */
    border-radius: 5px;
    margin-top: 8px;
    font-size: 14px;
    line-height: 1.5;
    border: 1px solid #444;
}

/* Webkit 기반 브라우저 스크롤바 스타일 */
.terms-box::-webkit-scrollbar {
    width: 10px;
}

.terms-box::-webkit-scrollbar-track {
    background: #333; /* .terms-box와 동일 */
    border-radius: 5px;
    margin-top: 8px; /* 체크박스와 수평 정렬 */
    margin-bottom: 8px;
}

.terms-box::-webkit-scrollbar-thumb {
    background: #33e3da; /* 버튼 및 체크박스 색상 */
    border-radius: 5px;
    border: 2px solid #333;
}

.terms-box::-webkit-scrollbar-thumb:hover {
    background: #2ccfcf;
}

/* Firefox 스크롤바 스타일 */
.terms-box {
    scrollbar-width: thin;
    scrollbar-color: #33e3da #333;
}

.checkbox-group {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
}

.label-title {
    flex: 1;
    font-weight: bold;
    font-size: 16px;
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 10px;
}

input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
    accent-color: #33e3da;
}

.all-agree-section {
    border-bottom: 1px solid #444;
    padding-bottom: 15px;
    margin-bottom: 20px;
}

#nextBtn {
    width: 100%;
    padding: 12px;
    margin-top: 20px;
    background-color: #33e3da;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    color: #000;
    font-weight: bold;
}

#nextBtn:disabled {
    background-color: #666;
    cursor: not-allowed;
}
</style>
<script>

function toggleCheckboxes(source) {
    const checkboxes = document.querySelectorAll('.agree-check');
    checkboxes.forEach(cb => cb.checked = source.checked);
    updateButtonState();
}

function updateButtonState() {
    const checkboxes = document.querySelectorAll('.agree-check');
    const allChecked = Array.from(checkboxes).every(cb => cb.checked);
    document.getElementById('nextBtn').disabled = !allChecked;
    document.getElementById('allAgree').checked = allChecked;
}

function goToNext() {
    if (!document.getElementById('nextBtn').disabled) {
        window.location.href = "resisterId.do";
    }
}
</script>
</head>
<body>
<div class="container">
    <h2>이용 약관</h2>

    <div class="all-agree-section">
        <div class="checkbox-group">
            <span class="label-title">전체 동의</span>
            <label class="checkbox-label">
                <input type="checkbox" id="allAgree" onclick="toggleCheckboxes(this)">
            </label>
        </div>
    </div>

    <div class="terms-section">
        <div class="checkbox-group">
            <span class="label-title">약관 1 (필수)</span>
            <label class="checkbox-label">
                <input type="checkbox" class="agree-check" onclick="updateButtonState()">
            </label>
        </div>
        <div class="terms-box">
            제1조(목적)<br>
            이 약관은 회사(전자상거래 사업자)가 운영하는 웹사이트에서 제공하는 서비스의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.<br>
            제2조(정의)<br>
            1. "웹사이트"란 회사가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 설정한 가상의 영업장을 말합니다.<br>
            2. "이용자"란 웹사이트에 접속하여 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.<br>
            제3조(약관의 명시와 설명 및 개정)<br>
            1. 회사는 이 약관의 내용을 이용자가 쉽게 알 수 있도록 웹사이트 초기 화면에 게시합니다.<br>
            2. 회사는 약관의규제에관한법률, 전자상거래등에서의소비자보호에관한법률 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.<br>
            추가 내용: 이 약관은 2023년 1월 1일부터 시행됩니다.<br>
            추가 내용: 이용자는 약관 동의 후 서비스를 이용할 수 있습니다.<br>
            추가 내용: 회사는 이용자의 개인정보를 보호하기 위해 최선을 다합니다.<br>
        </div>
    </div>

    <div class="terms-section">
        <div class="checkbox-group">
            <span class="label-title">약관 2</span>
            <label class="checkbox-label">
                <input type="checkbox" class="agree-check" onclick="updateButtonState()">
            </label>
        </div>
        <div class="terms-box">
            개인정보처리방침<br>
            [차례]<br>
            1. 총칙<br>
            2. 개인정보 수집에 대한 동의<br>
            3. 개인정보의 수집 및 이용목적<br>
            4. 수집하는 개인정보 항목 및 수집방법<br>
            5. 개인정보의 보유 및 이용기간<br>
            6. 개인정보의 파기절차 및 방법<br>
            7. 이용자 및 법정대리인의 권리와 그 행사방법<br>
            8. 개인정보 보호를 위한 기술적/관리적 대책<br>
            9. 개인정보 관련 민원처리<br>
            10. 기타<br>
            추가 내용: 개인정보는 회원 탈퇴 시 즉시 파기됩니다.<br>
            추가 내용: 이용자는 언제든지 개인정보 열람을 요청할 수 있습니다.<br>
            추가 내용: 회사는 개인정보 유출 방지를 위해 노력합니다.<br>
        </div>
    </div>

    <button id="nextBtn" onclick="goToNext()" disabled>다음 단계로</button>
</div>
</body>
</html>