<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style>
body {
	background-color: #000;
	color: #fff;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.container {
	background-color: #000;
	border-radius: 10px;
	padding: 40px;
	width: 400px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	border-left: 3px solid #fff;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	border-right: 3px solid #fff;
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
	display: none; /* 초기에는 숨김 */
}

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
	background: #fff; /* 버튼 및 체크박스 색상 */
	border-radius: 5px;
	border: 2px solid #333;
}

.terms-box::-webkit-scrollbar-thumb:hover {
	background: #fff;
}

.terms-box {
	scrollbar-width: thin;
	scrollbar-color: #fff #333;
}

.checkbox-group {
	display: flex;
	align-items: center;
	margin-bottom: 8px;
}

.checkbox-label {
	display: flex;
	align-items: center;
	gap: 10px;
}

.all {
	flex: 1;
	font-weight: bold;
	font-size: 18px;
}

.label-title {
	flex: 1;
	font-weight: bold;
	font-size: 18px;
	cursor: pointer;
}

input[type="checkbox"] {
	width: 18px;
	height: 18px;
	cursor: pointer;
	accent-color: #fff;
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
	background-color: #fff;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	cursor: pointer;
	color: #000;
	font-weight: bold;
}

#nextBtn:disabled {
	background-color: #000;
	color:#fff;
	cursor: not-allowed;
	border-left: 1px solid #fff;
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	border-right: 1px solid #fff;
}
</style>
<script>
function toggleCheckboxes(source) {
    const checkboxes = document.querySelectorAll('.agree-check');
    checkboxes.forEach(cb => {
        cb.checked = source.checked;
    });
    updateButtonState();
}

function toggleTerms(event) {
    event.preventDefault(); // 링크 클릭 시 페이지 이동 방지
    const termsSection = event.target.closest('.terms-section');
    const termsBox = termsSection.querySelector('.terms-box');
    termsBox.style.display = termsBox.style.display === 'block' ? 'none' : 'block';
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

// 페이지 로드 시 모든 label-title에 클릭 이벤트 추가
document.addEventListener('DOMContentLoaded', function() {
    const labelTitles = document.querySelectorAll('.label-title');
    labelTitles.forEach(title => {
        title.addEventListener('click', toggleTerms);
    });
});
</script>
</head>
<body>
	<c:import url="/WEB-INF/views/common/header.jsp" />
	<div class="container">
		<h2>다음 내용에 동의해주세요</h2>

		<div class="all-agree-section">
			<div class="checkbox-group">
				<label class="checkbox-label"> <input type="checkbox"
					id="allAgree" onclick="toggleCheckboxes(this)">
				</label> <span class="all">모두 동의</span>
			</div>
		</div>

		<div class="terms-section">
			<div class="checkbox-group">
				<label class="checkbox-label"> <input type="checkbox"
					class="agree-check" onclick="updateButtonState();">
				</label> <span class="label-title"><u>1. 서비스 이용약관 동의 (필수)</u></span>
			</div>
			<div class="terms-box">
				<strong>제1조 (목적)</strong><br> 이 약관은 [회사명] (이하 "회사")가 제공하는
				[웹사이트/앱명] 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한
				사항을 규정함을 목적으로 합니다.<br> <br> <strong>제2조 (정의)</strong><br>
				- "이용자"란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.<br> - "회원"이란
				회사와 서비스 이용 계약을 체결하고 사용자 ID를 부여받은 자를 말합니다.<br> <br> <strong>제3조
					(약관의 효력 및 변경)</strong><br> - 본 약관은 서비스 화면에 게시하거나 기타 방법으로 이용자에게 공지함으로써
				효력이 발생합니다.<br> - 회사는 관련 법령을 위배하지 않는 범위에서 약관을 변경할 수 있으며, 변경 시 사전
				공지합니다.<br> <br> <strong>제4조 (이용계약의 체결)</strong><br> -
				이용자는 회사가 정한 절차에 따라 회원가입 신청을 하고, 회사가 이를 승낙함으로써 계약이 체결됩니다.<br> <br>
				<strong>제5조 (서비스의 제공 및 변경)</strong><br> - 회사는 이용자에게 아래와 같은 서비스를
				제공합니다:<br> ① 콘텐츠 정보 제공<br> ② 사용자 커뮤니티<br> ③ 기타 회사가
				정하는 서비스<br> - 회사는 서비스의 내용이나 기술적 사양을 변경할 수 있습니다.<br> <br>
				<strong>제6조 (회원의 의무)</strong><br> - 회원은 타인의 정보를 도용하거나 허위 정보를
				등록해서는 안 되며, 회사의 서비스 이용 시 관련 법령과 본 약관을 준수해야 합니다.<br> <br> <strong>제7조
					(회사의 의무)</strong><br> - 회사는 지속적이고 안정적인 서비스 제공을 위해 노력하며, 회원의 개인정보를 보호하기
				위해 최선을 다합니다.<br> <br> <strong>제8조 (서비스 이용 제한 및
					해지)</strong><br> - 회사는 회원이 본 약관을 위반하거나 법령을 위반한 경우 서비스 이용을 제한하거나 이용 계약을
				해지할 수 있습니다.<br> <br> <strong>제9조 (면책조항)</strong><br>
				- 회사는 천재지변, 불가항력 등으로 서비스를 제공할 수 없는 경우 책임을 지지 않습니다.<br> <br>
			</div>
		</div>

		<div class="terms-section">
			<div class="checkbox-group">
				<label class="checkbox-label"> <input type="checkbox"
					class="agree-check" onclick="updateButtonState();">
				</label> <span class="label-title"><u>2. 개인정보 수집 및 이용 동의(필수)</u></span>
			</div>
			<div class="terms-box">
				<strong>1. 수집하는 개인정보 항목</strong><br> 회사는 회원가입, 상담, 서비스 제공을 위해
				아래와 같은 개인정보를 수집할 수 있습니다.<br> - 필수 항목: 이름, 이메일, 비밀번호, 생년월일,
				휴대폰번호<br> - 자동 수집 항목: IP주소, 쿠키, 방문일시, 서비스 이용기록 등<br> <br>
				<strong>2. 개인정보 수집 및 이용 목적</strong><br> 회사는 수집한 개인정보를 다음의 목적을
				위해 이용합니다.<br> - 회원관리: 회원제 서비스 이용에 따른 본인확인, 가입의사 확인<br> -
				서비스 제공: 콘텐츠 제공, 맞춤형 서비스 제공<br> - 민원 처리 및 고객지원<br> <br>
				<strong>3. 개인정보 보유 및 이용기간</strong><br> - 원칙적으로 개인정보 수집 및 이용 목적이
				달성된 후에는 해당 정보를 지체 없이 파기합니다.<br> - 단, 관련 법령에 따라 보존이 필요한 경우에는 일정
				기간 보관합니다.<br> 예) 전자상거래 등에서의 소비자 보호에 관한 법률: 계약/청약철회 정보 5년 등<br>
				<br> <strong>4. 동의를 거부할 권리</strong><br> - 이용자는 개인정보 수집 및
				이용 동의를 거부할 수 있습니다.<br> - 단, 동의하지 않을 경우 서비스 가입 및 이용이 제한될 수 있습니다.<br>
				<br>
			</div>
		</div>

		<button id="nextBtn" onclick="goToNext()" disabled>다음</button>
	</div>
</body>
</html>