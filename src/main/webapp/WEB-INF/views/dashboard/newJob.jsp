<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${ empty sessionScope.loginUser }">
	<jsp:forward page="/WEB-INF/views/user/login.jsp"/>
</c:if>
<c:set var="nowpage" value="1" />
<c:if test="${ !empty requestScope.paging.currentPage }">
	<c:set var="nowpage" value="${ requestScope.paging.currentPage }" />
</c:if>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>irumi</title>
<style>
body {
	background-color: #111;
	color: white;
	margin: 0;
	padding: 0;
}

header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 50px;
}

form.sform {
	text-align: center;
	margin-top: 30px;
}

fieldset {
	border: 2px solid #009688;
	border-radius: 10px;
	display: inline-block;
	padding: 20px 30px;
	background-color: #222;
}

legend {
	font-size: 1.2em;
	font-weight: bold;
	color: #00bfa5;
}

input[type="search"] {
	padding: 8px;
	border: 1px solid #555;
	border-radius: 5px;
	width: 1000px;
	background: #333;
	color: white;
}

input[type="submit"], #re {
	padding: 8px 16px;
	border: none;
	border-radius: 5px;
	background-color: #00bfa5;
	color: white;
	cursor: pointer;
	font-weight: bold;
	transition: background-color 0.3s;
}

input[type="submit"]:hover, #re:hover {
	background-color: #00796b;
}

table {
	width: 1000px;
	margin: 40px auto;
	border-collapse: collapse;
	background-color: #1e1e1e;
	box-shadow: 0 0 10px rgba(0,0,0,0.5);
}

th, td {
	padding: 12px;
	border: 1px solid #444;
}

th {
	background-color: #009688;
	color: white;
}

td {
	color: #ccc;
}

td a {
	color: #80cbc4;
	text-decoration: none;
}

td a:hover {
	text-decoration: underline;
}
.checkbox-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 5px 5px;
	max-width: 1200px;
}

.checkbox-grid input[type="checkbox"] {
    display: none;
}

.checkbox-grid label {
    background-color: #333;
    color: #ccc;
    padding: 5px 5px;
    border-radius: 8px;
    text-align: center;
    cursor: pointer;
    border: 1px solid #555;
    transition: all 0.2s ease-in-out;
}

.checkbox-grid input[type="checkbox"]:checked + label {
    background-color: #00bfa5;
    color: white;
    font-weight: bold;
    border-color: #00bfa5;
}

.checkbox-grid label:hover {
    background-color: #444;
}
</style>

</style>
<script>
	function toggleCheckboxes() {
		const container = document.getElementById('checkboxContainer');
		container.style.display = (container.style.display === 'none') ? 'block' : 'none';
	}
	
	function resetPage() {
		location.href = 'addJob.do?page=1';
	}
</script>
</head>
<body>
	<c:set var="menu" value="dashboard" scope="request" />
	<c:import url="/WEB-INF/views/common/header.jsp" />
	
	<form action="jobSearch.do" id="jobform" class="sform" method="get">
	<fieldset>
		<legend>검색할 직업을 입력하세요.</legend>
			<input type="search" name="keyword" size="50"> &nbsp;
			<input type="submit" value="검색">&nbsp;&nbsp;&nbsp;<button id="re" type="button" onclick="resetPage()">목록</button><br>
		<button type="button" onclick="toggleCheckboxes()" style="margin-top: 20px; padding: 10px 20px; background-color: #00bfa5; color: white; border: none; border-radius: 5px; cursor: pointer;">
			상세검색
		</button>
		<div id="checkboxContainer" style="display: none; margin-top: 20px;">
		<div class="checkbox-grid">
		<input type="checkbox" name="type" value="IT관련전문직" id="IT관련전문직">
		    <label for="IT관련전문직">IT관련전문직</label>
		<input type="checkbox" name="type" value="고급 운전 관련직" id="고급 운전 관련직">
		    <label for="고급 운전 관련직">고급 운전 관련직</label>
		<input type="checkbox" name="type" value="공학 기술직" id="공학 기술직">
		    <label for="공학 기술직">공학 기술직</label>
		<input type="checkbox" name="type" value="공학 전문직" id="공학 전문직">
		    <label for="공학 전문직">공학 전문직</label>
		<input type="checkbox" name="type" value="교육관련 서비스직" id="교육관련 서비스직">
		    <label for="교육관련 서비스직">교육관련 서비스직</label>
		<input type="checkbox" name="type" value="금융 및 경영 관련직" id="금융 및 경영 관련직">
		    <label for="금융 및 경영 관련직">금융 및 경영 관련직</label>
		<input type="checkbox" name="type" value="기능직" id="기능직">
		    <label for="기능직">기능직</label>
		<input type="checkbox" name="type" value="기타 게임·오락·스포츠 관련직" id="기타 게임·오락·스포츠 관련직">
		    <label for="기타 게임·오락·스포츠 관련직">기타 게임·오락·스포츠 관련직</label>
		<input type="checkbox" name="type" value="기타 특수 예술직" id="기타 특수 예술직">
		    <label for="기타 특수 예술직">기타 특수 예술직</label>
		<input type="checkbox" name="type" value="기획서비스직" id="기획서비스직">
		    <label for="기획서비스직">기획서비스직</label>
		<input type="checkbox" name="type" value="농생명산업 관련직" id="농생명산업 관련직">
		    <label for="농생명산업 관련직">농생명산업 관련직</label>
		<input type="checkbox" name="type" value="디자인 관련직" id="디자인 관련직">
		    <label for="디자인 관련직">디자인 관련직</label>
		<input type="checkbox" name="type" value="매니지먼트 관련직" id="매니지먼트 관련직">
		    <label for="매니지먼트 관련직">매니지먼트 관련직</label>
		<input type="checkbox" name="type" value="무용 관련직" id="무용 관련직">
		    <label for="무용 관련직">무용 관련직</label>
		<input type="checkbox" name="type" value="미술 및 공예 관련직" id="미술 및 공예 관련직">
		    <label for="미술 및 공예 관련직">미술 및 공예 관련직</label>
		<input type="checkbox" name="type" value="법률 및 사회활동 관련직" id="법률 및 사회활동 관련직">
		    <label for="법률 및 사회활동 관련직">법률 및 사회활동 관련직</label>
		<input type="checkbox" name="type" value="보건의료 관련 서비스직" id="보건의료 관련 서비스직">
		    <label for="보건의료 관련 서비스직">보건의료 관련 서비스직</label>
		<input type="checkbox" name="type" value="사무 관련직" id="사무 관련직">
		    <label for="사무 관련직">사무 관련직</label>
		<input type="checkbox" name="type" value="사회서비스직" id="사회서비스직">
		    <label for="사회서비스직">사회서비스직</label>
		<input type="checkbox" name="type" value="악기 관련직" id="악기 관련직">
		    <label for="악기 관련직">악기 관련직</label>
		<input type="checkbox" name="type" value="언어 관련 전문직" id="언어 관련 전문직">
		    <label for="언어 관련 전문직">언어 관련 전문직</label>
		<input type="checkbox" name="type" value="연기 관련직" id="연기 관련직">
		    <label for="연기 관련직">연기 관련직</label>
		<input type="checkbox" name="type" value="영상 관련직" id="영상 관련직">
		    <label for="영상 관련직">영상 관련직</label>
		<input type="checkbox" name="type" value="영업관련 서비스직" id="영업관련 서비스직">
		    <label for="영업관련 서비스직">영업관련 서비스직</label>
		<input type="checkbox" name="type" value="예술기획 관련직" id="예술기획 관련직">
		    <label for="예술기획 관련직">예술기획 관련직</label>
		<input type="checkbox" name="type" value="운동 관련직" id="운동 관련직">
		    <label for="운동 관련직">운동 관련직</label>
		<input type="checkbox" name="type" value="웹·게임·애니메이션 관련직" id="웹·게임·애니메이션 관련직">
		    <label for="웹·게임·애니메이션 관련직">웹·게임·애니메이션 관련직</label>
		<input type="checkbox" name="type" value="음악 관련직" id="음악 관련직">
		    <label for="음악 관련직">음악 관련직</label>
		<input type="checkbox" name="type" value="의료관련 전문직" id="의료관련 전문직">
		    <label for="의료관련 전문직">의료관련 전문직</label>
		<input type="checkbox" name="type" value="의복제조 관련직" id="의복제조 관련직">
		    <label for="의복제조 관련직">의복제조 관련직</label>
		<input type="checkbox" name="type" value="이공계 교육 관련직" id="이공계 교육 관련직">
		    <label for="이공계 교육 관련직">이공계 교육 관련직</label>
		<input type="checkbox" name="type" value="이미용 관련직" id="이미용 관련직">
		    <label for="이미용 관련직">이미용 관련직</label>
		<input type="checkbox" name="type" value="이학 전문직" id="이학 전문직">
		    <label for="이학 전문직">이학 전문직</label>
		<input type="checkbox" name="type" value="인문 및 사회과학 관련직" id="인문 및 사회과학 관련직">
		    <label for="인문 및 사회과학 관련직">인문 및 사회과학 관련직</label>
		<input type="checkbox" name="type" value="인문계 교육 관련직" id="인문계 교육 관련직">
		    <label for="인문계 교육 관련직">인문계 교육 관련직</label>
		<input type="checkbox" name="type" value="일반 서비스직" id="일반 서비스직">
		    <label for="일반 서비스직">일반 서비스직</label>
		<input type="checkbox" name="type" value="일반운전 관련직" id="일반운전 관련직">
		    <label for="일반운전 관련직">일반운전 관련직</label>
		<input type="checkbox" name="type" value="자연친화 관련직" id="자연친화 관련직">
		    <label for="자연친화 관련직">자연친화 관련직</label>
		<input type="checkbox" name="type" value="작가 관련직" id="작가 관련직">
		    <label for="작가 관련직">작가 관련직</label>
		<input type="checkbox" name="type" value="조리 관련직" id="조리 관련직">
		    <label for="조리 관련직">조리 관련직</label>
		<input type="checkbox" name="type" value="환경관련 전문직" id="환경관련 전문직">
		    <label for="환경관련 전문직">환경관련 전문직</label>
		<input type="checkbox" name="type" value="회계 관련직" id="회계 관련직">
    		<label for="회계 관련직">회계 관련직</label>
    	</div>
    </div>
	</fieldset>
	</form>
	<c:if test="${ empty requestScope.list }">
		<div style="display: flex; align-items: center; justify-content: center; height: 500px">표시할 내용이 없습니다</div>
	</c:if>
	<c:if test="${ !empty requestScope.list }">
		<table>
			<tr>
				<th width="100px">직업</th>
				<th>내용</th>
				<th width="100px">분류</th>
			</tr>
			<c:forEach items="${ requestScope.list }" var="jobList">
				<tr align="center">
					<td>
						<c:url var="link" value="jobDetail.do">
							<c:param name="jobListId" value="${ jobList.jobListId }" />
						</c:url>
						<a href="${ link }">${ jobList.jobName }</a>
					</td>
					<td align="left">${ jobList.jobExplain }</td>
					<td>${ jobList.jobType }</td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
	
	<div style="display: flex; align-items: center; justify-content: center;">
		<c:import url="/WEB-INF/views/common/pagingView.jsp" />
	</div>
	
	<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>