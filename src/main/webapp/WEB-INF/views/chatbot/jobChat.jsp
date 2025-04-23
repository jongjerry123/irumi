<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi - 대화형 도우미</title>
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #111;
	color: #fff;
	display: flex;
	height: 100vh;
}

.column {
	padding: 20px;
}

.col-1 {
	width: 20%;
	background-color: #000;
	display: flex;
	flex-direction: column;
	align-items: center;
}

.col-1 .logo {
	margin-bottom: 40px;
	font-size: 1.5em;
	font-weight: bold;
}

.col-1 .menu {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.col-2 {
	width: 60%;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	border-left: 1px solid #444;
	border-right: 1px solid #444;
}

.chat-area {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.message {
	max-width: 70%;
	padding: 10px 15px;
	border-radius: 12px;
	line-height: 1.5;
	font-size: 0.95em;
	word-wrap: break-word;
}

.user-msg {
	background-color: #0066cc;
	align-self: flex-end;
	text-align: right;
}

.bot-msg {
	align-self: flex-start;
	text-align: left;
	padding: 0; /* padding 제거 */
	background-color: transparent; /* 배경 제거 */
	max-width: 100%;
	font-size: 0.95em;
	line-height: 1.6;
	white-space: pre-wrap;
}

.chat-input {
	display: flex;
	align-items: center;
	border-top: 1px solid #333;
	padding: 10px;
	background-color: #222;
}

.chat-input input[type="text"] {
	flex: 1;
	padding: 10px;
	font-size: 1em;
	background-color: #333;
	color: white;
	border: none;
	border-radius: 5px;
	margin-right: 6px;
}

.chat-input button {
	padding: 8px 12px;
	background-color: #007bff;
	border: none;
	border-radius: 4px;
	color: white;
	font-size: 0.95em;
	cursor: pointer;
}

.chat-input button:hover {
	background-color: #0056b3;
}

.col-3 {
	width: 20%;
	display: flex;
	flex-direction: column;
}

.user-info {
	background-color: #222;
	padding: 20px;
	text-align: right;
	border-bottom: 1px solid #333;
}

.col-3 .content-area {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
}

.logout-btn {
	background: none;
	border: 1px white;
	color: white;
	font-size: 1em;
	display: flex;
	align-items: center;
	gap: 5px;
	cursor: pointer;
}

.logout-btn:hover {
	opacity: 0.8;
}

.logo {
	cursor: pointer;
	display: box;
}
</style>
</head>
<body>
	<div class="column col-1">
		<div class="logo" onclick="moveToMain()">▲ irumi</div>
		<div class="menu">
			<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
		</div>
	</div>

	<div class="column col-2">
		<div class="chat-area" id="chatArea">
			<!-- 챗 메시지 렌더링 영역 -->
			<h3>전체 메세지 내역</h3>
			<!-- 유저 메세지 하나 가져오기 -->


		</div>
		<div class="chat-input">
			<input id="userInput" type="text" placeholder="무엇이든 물어보세요">
			<button type="button" onclick="sendMessage()">보내기</button>
		</div>
	</div>

	<div class="column col-3">
		<div class="user-info">
			<button class="logout-btn">로그아웃</button>
		</div>
		<div class="content-area">
			<!-- 관심 직무 리스트, 저장 정보 등 출력 -->
		</div>
	</div>

	<script>
	
		window.addEventListener("DOMContentLoaded", loadMessages);
		function loadMessages() {
	        const chatArea = document.getElementById("chatArea");
	        fetch("/chatbot/viewChat.do?convId=demo-conv-id&topic=job")
	            .then(res => res.json())
	            .then(data => {
	                data.forEach(msg => {
	                    const div = document.createElement("div");
	                    div.className = msg.role === 'user' ? "message user-msg" : "bot-msg";
	                    div.textContent = msg.msgContent;
	                    chatArea.appendChild(div);
	                });
	                chatArea.scrollTop = chatArea.scrollHeight;
	            });
	    }
	
		function moveToMain() {
		    location.href = 'main.do';
		}
        
		function sendMessage() {
	           const userInput = document.getElementById("userInput");
	           const chatArea = document.getElementById("chatArea");
	           const message = userInput.value.trim();
	           if (!message) return;
	           // 사용자 메시지 출력 (오른쪽 정렬, 박스)
	           const userDiv = document.createElement("div");
	           userDiv.className = "message user-msg";
	           userDiv.textContent = message;
	           chatArea.appendChild(userDiv);
	           
	           fetch("/chatbot/sendUserMsg.do", {
	               method: "POST",
	               headers: { "Content-Type": "application/x-www-form-urlencoded" },
	               body: new URLSearchParams({
	                   convId: "demo-conv-id",
	                   topic: "job",
	                   userMsg: message
	               })
	           })
	           .then(response => response.text())
	           .then(gptReply => {
	               const botDiv = document.createElement("div");
	               botDiv.className = "message bot-msg";
	               botDiv.textContent = gptReply;
	               chatArea.appendChild(botDiv);
	               userInput.value = "";
	               chatArea.scrollTop = chatArea.scrollHeight;
	           });
	       }

    </script>
</body>
</html>
