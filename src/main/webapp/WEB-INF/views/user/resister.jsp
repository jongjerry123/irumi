<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            padding: 40px;
            border-radius: 10px;
            width: 500px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .terms-section {
            margin-bottom: 20px;
        }

        .terms-box {
            background-color: #333;
            padding: 10px;
            height: 150px;
            overflow-y: scroll;
            border-radius: 5px;
            margin-top: 5px;
            font-size: 14px;
        }

        .checkbox-group {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

        .label-title {
            font-weight: bold;
        }

        input[type="checkbox"] {
            transform: scale(1.2);
            cursor: pointer;
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
        }

        #nextBtn:disabled {
            background-color: #666;
            cursor: not-allowed;
        }
            .checkbox-label {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 8px;
        width: 100%;
    }
    </style>
    <script>
        function toggleCheckboxes(source) {
            const checkboxes = document.querySelectorAll('.agree-check');
            checkboxes.forEach(cb => cb.checked = source.checked);
            updateButtonState(); // 버튼도 갱신
        }

        function updateButtonState() {
            const checkboxes = document.querySelectorAll('.agree-check');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);

            // 버튼과 전체동의 상태 갱신
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

<div class="checkbox-group">
    <label class="checkbox-label">
        <span class="label-title">전체 동의</span>
        <input type="checkbox" id="allAgree" onclick="toggleCheckboxes(this)">
    </label>
</div>

    <div class="terms-section">
        <div class="checkbox-group">
            <span class="label-title">약관 1 (필수)</span>
            <input type="checkbox" class="agree-check" onclick="updateButtonState()">
        </div>
        <div class="terms-box">
            제1조(목적) 이 약관은 회사(전자상거래 사업자)가 운영하는 웹사이트에서 제공하는 서비스의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다. ...
        </div>
    </div>

    <div class="terms-section">
        <div class="checkbox-group">
            <span class="label-title">약관 2</span>
            <input type="checkbox" class="agree-check" onclick="updateButtonState()">
        </div>
        <div class="terms-box">
            개인정보처리방침<br>
            [차례]<br>
            1. 총칙<br>
            2. 개인정보 수집에 대한 동의<br>
            ...
        </div>
    </div>

    <button id="nextBtn" onclick="goToNext()" disabled>다음 단계로</button>
</div>
</body>
</html>