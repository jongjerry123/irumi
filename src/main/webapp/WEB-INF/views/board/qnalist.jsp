<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Q&A 게시판</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board.css">
</head>
<body>

<div class="layout">
    <aside class="sidebar">
        <div class="logo">irumi</div>
        <nav>
            <ul>
                <li>스펙 대시보드</li>
                <li>대화형 도우미</li>
                <li class="active">유저 커뮤니티</li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <header class="board-header">
            <h2>커뮤니티</h2>
            <div class="tabs">
                <button class="tab selected">Q&A</button>
                <button class="tab">공지사항</button>
                <button class="tab">자유 주제</button>
            </div>
            <div class="login-btn">로그아웃 🔒</div>
        </header>

        <section class="board-section">
            <table class="qna-table">
                <thead>
                <tr>
                    <th>작성자</th>
                    <th>글 제목</th>
                    <th>답변유무</th>
                    <th>작성일자</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="post" items="${qnaList}">
                    <tr>
                        <td>${post.postWriter}</td>
                        <td>
                            <c:choose>
                                <c:when test="${post.secret eq 'Y'}">
                                    작성자와 관리자만 볼 수 있는 글입니다.
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/qna/detail?postId=${post.postId}"
                                       style="color:#c09; font-weight:bold;">
                                        ${post.postTitle}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${post.answered eq 'Y' ? 'Y' : 'N'}</td>
                        <td>${post.postTime}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="board-footer">
                <a class="write-btn" href="${pageContext.request.contextPath}/qna/write">질문 등록</a>
                <a class="mine-btn" href="${pageContext.request.contextPath}/qna/myList">내 질문만 보기</a>
            </div>

            <div class="pagination">
                <!-- 페이징 처리는 JSTL로 페이지 번호 뿌리면 됨 -->
                <button disabled>&lt;</button>
                <span class="page-num">2</span>
                <button>&gt;</button>
            </div>
        </section>
    </main>
</div>

</body>
</html>