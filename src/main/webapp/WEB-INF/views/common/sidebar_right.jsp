<%--  --%><%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
<!DOCTYPE html>
<html>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="${ pageContext.servletContext.contextPath}/resources/css/sidebar_right.css" />

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<script type="text/javascript">
function moveToLogin() {
    location.href = 'loginPage.do';
}

function logout() {
	if(confirm("로그아웃 하시겠습니까?")) {
	    const token = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
	    const header = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') || 'X-CSRF-TOKEN';
	    
	    if (!token || !header) {
	        console.warn('CSRF token or header not found, attempting logout without CSRF');
	        fetch('logout.do', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded'
	            }
	        })
	        .then(response => {
	            if (response.ok) {
	                window.location.href = '/irumi';
	            } else {
	                alert('로그아웃에 실패했습니다.');
	            }
	        })
	        .catch(error => {
	            alert('로그아웃 중 오류가 발생했습니다.');
	        });
	        return;
	    }
	    fetch('logout.do', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded',
	            [header]: token
	        }
	    })
	    .then(response => {
	        if (response.ok) {
	            window.location.href = '/irumi';
	        } else {
	            alert('로그아웃에 실패했습니다.');
	        }
	    })
	    .catch(error => {
	        alert('로그아웃 중 오류가 발생했습니다.');
	    });
	}
}
</script>
<body>
	
	<div class="right-panel">
			<div class="saved-schedule-section">
				<div class="info-row">
				<div class="section-title">🎯 목표 직무</div>
					 <span class="value" style="display: none;"></span>
				</div>
<!-- 				<div class="section-title">저장한 목표 스펙</div> -->
				<div class="saved-spec-list"></div>
				<div class="section-title">➕ 직접 추가하기</div>
				<div class="manual-input-box" style="display: none;">
					<input type="text" placeholder="직접 스펙 입력" class="manual-input" />
					<input type="text" placeholder="스펙 설명 (선택)"
						class="manual-input-explain" />
					<div class="specTypeChoice">
						<!--  List.of("자격증", "어학", "인턴십", "대회/공모전", "자기계발", "기타")); -->
						<button class="specType">어학 능력</button>
						<button class="specType">자격증</button>
						<button class="specType">인턴십 및 현장실습</button>
						<button class="specType">대외 활동</button>
						<button class="specType">연구 활동</button>
						<button class="specType">기타</button>
					</div>
					<button class="add-btn">목표 스펙 추가</button>
				</div>
			</div>
		</div>
	
	
</body>
</html>