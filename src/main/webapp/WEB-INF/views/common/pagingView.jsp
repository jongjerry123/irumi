<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
 
 <c:set var="paging" value="${ requestScope.paging }" />
 <%-- url 뒤에 추가할 쿼리스트링으로 사용할 변수로 저장함 --%>
 <c:set var="queryParams" value="keyword=${ requestScope.keyword }&begin=${ requestScope.begin }&end=${ end }" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title></title>
<style>
/* 컨테이너를 inline‑flex로 전환해 깔끔한 가로 정렬 유지 */  
div[style*="text-align: center;"] {  
  display: inline-flex;           /* Flexbox 가로 배치 */
  gap: 8px;                        /* 페이지 버튼 간격 */
  align-items: center;             /* 수직 중앙 정렬 */
  padding: 12px 0;                 /* 위아래 여백 */
}  

/* <a>와 <b> 모두 동일한 박스 크기·테두리·애니메이션 */
div[style*="text-align: center;"] a,
div[style*="text-align: center;"] b {
  display: inline-block;           /* 블록처럼 크기 지정 가능 */
  width: 36px;                     /* 고정 너비 */
  height: 36px;                    /* 고정 높이 */
  line-height: 36px;               /* 텍스트 수직 중앙 */
  text-align: center;              /* 텍스트 수평 중앙 */
  border: 1px solid #444;          /* 어두운 테두리 */
  border-radius: 4px;              /* 살짝 둥근 모서리 */
  font-weight: 500;                /* 약간 굵은 글씨 */
  transition: background-color 0.3s, color 0.3s; /* 부드러운 변환 */
}

/* 비활성 링크에 마우스 올릴 때 배경 강조 */  
div[style*="text-align: center;"] a:hover {
  background-color: #2a2a2a;       /* 짙은 회색 배경 */
  color: #fff;                     /* 흰색 글씨 */
}

/* <b> 태그(현재 페이지)에 명확한 강조색 적용 */  
div[style*="text-align: center;"] b {
  background-color: #00bfa5;       /* 메인 강조색 */
  color: #111;                     /* 진한 글씨로 반전 */
  border-color: #00bfa5;           /* 테두리도 강조색 */
}

a {
	color: #80cbc4;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

@media screen and (max-width: 600px) {
  /* 간격·크기 축소 */
  div[style*="text-align: center;"] {
    gap: 4px;
  }
  div[style*="text-align: center;"] a,
  div[style*="text-align: center;"] b {
    width: 28px;
    height: 28px;
    line-height: 28px;
    font-size: 0.9em;               /* 글자 크기 약간 축소 */
  }
}
</style>
</head>
<body>
<div style="text-align: center;">
	<%-- 1페이지로 이동 --%>
	<c:if test="${ paging.currentPage eq 1 }">
		[맨처음] &nbsp;
	</c:if>
	<c:if test="${ paging.currentPage gt 1 }"> <%-- gt : greater than, > 연산자를 의미함 --%>
		<a href="${ paging.urlMapping }?page=1&${ queryParams }" style="width: 100px;">[맨처음]</a> &nbsp;
	</c:if>
	
	<%-- 이전 페이지 그룹으로 이동 --%>
	<%-- 이전 그룹이 있다면 --%>
	<c:if test="${ (paging.startPage - 10) ge 1 }">
		<a href="${ paging.urlMapping }?page=${paging.startPage - 10}&${ queryParams }" style="width: 100px;">[이전그룹]</a> &nbsp;
	</c:if>
	<%-- 이전 그룹이 없다면 --%>
	<c:if test="${ !((paging.startPage - 10) ge 1) }">
		[이전그룹] &nbsp;
	</c:if>
	
	<%-- 현재 출력할 페이지가 속한 페이지 그룹의 페이지 숫자 출력 : 10개 --%>
	<c:forEach begin="${ paging.startPage }" end="${ paging.endPage }" step="1" var="p">
		<c:if test="${ p eq paging.currentPage }">
			<b>${ p }</b>
		</c:if>
		<c:if test="${ p ne paging.currentPage }">
			<a href="${ paging.urlMapping }?page=${ p }&${ queryParams }">${ p }</a>
		</c:if>
	</c:forEach>
	
	<%-- 다음 페이지 그룹으로 이동 --%>
	<%-- 다음 그룹이 있다면 --%>
	<c:if test="${ (paging.startPage + 10) le paging.maxPage }">
		<a href="${ paging.urlMapping }?page=${paging.startPage + 10}&${ queryParams }" style="width: 100px;">[다음그룹]</a> &nbsp;
	</c:if>
	<%-- 다음 그룹이 없다면 --%>
	<c:if test="${ !((paging.startPage + 10) le paging.maxPage) }">
		[다음그룹] &nbsp;
	</c:if>
	
	<%-- 마지막 페이지로 이동 --%>
	<c:if test="${ paging.currentPage ge paging.maxPage }"> <%-- ge : greater equal, >= 연산자임 --%>
		[맨끝] &nbsp;
	</c:if>
	<c:if test="${ !(paging.currentPage ge paging.maxPage) }"> 
		<a href="${ paging.urlMapping }?page=${ paging.maxPage }&${ queryParams }" style="width: 100px;">[맨끝]</a> &nbsp;
	</c:if>
</div>
</body>
</html>