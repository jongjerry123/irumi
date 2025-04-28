<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>신고된 댓글 관리</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #111;
      color: #fff;
    }

    .main-content {
      padding: 40px 140px;
      max-width: 1280px;
      margin: 0 auto;
    }

    .category-bar {
      display: flex;
      align-items: center;
      gap: 30px;
      margin-bottom: 30px;
    }

    .category-bar h2 {
      margin: 0;
    }

    .tabs {
      display: flex;
      gap: 12px;
    }

    .tabs button {
      background-color: #222;
      color: #fff;
      padding: 10px 24px;
      border: 1px solid transparent;
      border-radius: 10px;
      cursor: pointer;
    }

    .tabs .active {
      border: 1px solid #A983A3;
      color: #A983A3;
    }

    .admin-btn {
      background-color: #222;
      border: 1px solid #ff4c4c;
      border-radius: 10px;
      padding: 8px;
      cursor: pointer;
    }

    .admin-btn.active {
      border: 2px solid #ff4c4c;
      background-color: #1a1a1a;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin: 40px 0 20px 0;
    }

    th, td {
      border: 1px solid #444;
      padding: 14px;
      text-align: center;
    }

    th {
      background-color: #222;
    }

    td {
      background-color: #1a1a1a;
    }

    .bottom-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 60px;
    }

    .bottom-bar .left {
      font-size: 14px;
    }

    .bottom-bar .right {
      display: flex;
      gap: 10px;
    }

    .btn-action {
      background-color: transparent;
      border: 1px solid #A983A3;
      color: #A983A3;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
    }

    .btn-danger {
      border: 1px solid #ff4c4c;
      color: #ff4c4c;
    }

    .pagination {
      display: flex;
      gap: 10px;
      justify-content: center;
      margin-top: 20px;
    }

    .pagination button {
      background-color: #222;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
    }

    .pagination button.selected {
      border: 1px solid #A983A3;
      color: #A983A3;
    }

    input[type="checkbox"] {
      accent-color: #A983A3;
      width: 18px;
      height: 18px;
    }
  </style>

  <script>
    function deleteSelectedComments() {
      const selected = Array.from(document.querySelectorAll('input[name="selectedComments"]:checked'))
                             .map(checkbox => checkbox.value);

      if (selected.length === 0) {
        alert('삭제할 댓글을 선택하세요.');
        return;
      }

      if (!confirm('선택한 댓글을 삭제하시겠습니까?')) {
        return;
      }

      fetch('deleteSelectedComments.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(selected)
      })
      .then(response => {
        if (response.ok) {
          alert('삭제 완료되었습니다.');
          location.reload();
        } else {
          alert('삭제 실패. 다시 시도해주세요.');
        }
      });
    }
  </script>
</head>
<body>
<div class="main-content">

  <!-- 상단 카테고리 -->
  <div class="category-bar">
    <h2>불량 이용자 관리</h2>
    <div class="tabs">
      <button onclick="location.href='freeBoard.do'">자유게시판</button>
      <button onclick="location.href='qnaList.do'">Q&A</button>
      <button onclick="location.href='noticeList.do'">공지사항</button>
      <c:if test="${loginUser.userAuthority == '2'}">
        <button class="admin-btn active" onclick="location.href='badUserList.do'">
          <img src="/irumi/resources/images/bell.png" alt="관리자 알림" height="20" />
        </button>
      </c:if>
    </div>
  </div>

  <!-- 신고 카테고리 탭 -->
  <div class="tabs" style="margin-top: 30px;">
    <button onclick="location.href='reportedPosts.do'">신고된 게시글</button>
    <button class="active">신고된 댓글</button>
    <button onclick="location.href='badUserList.do'">불량 이용자 목록</button>
  </div>

  <!-- 댓글 테이블 -->
  <table>
    <thead>
      <tr>
        <th>작성자</th>
        <th>댓글 내용</th>
        <th>원본 게시글 제목</th>
        <th>신고수</th>
        <th>선택</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="comment" items="${reportedCommentList}">
        <tr>
          <td>${comment.comWrId}</td>
          <td>${comment.comContent}</td>
          <td>-</td> <!-- (나중에 원본 게시글 제목 연결하고 싶으면 추가 가능) -->
          <td>${comment.comReportCount}</td>
          <td><input type="checkbox" name="selectedComments" value="${comment.comId}" /></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 하단 정보 -->
  <div class="bottom-bar">
    <div class="left">신고된 댓글 수: ${fn:length(reportedCommentList)}개</div>
    <div class="right">
      <button class="btn-action" onclick="deleteSelectedComments()">선택한 댓글 삭제</button>
      <button class="btn-action btn-danger">불량 이용자 등록</button>
    </div>
  </div>

  <!-- 페이징 -->
  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <button onclick="location.href='reportedComments.do?page=${currentPage - 1}'">&lt;</button>
    </c:if>
    <c:forEach begin="1" end="${totalPages}" var="pageNum">
      <button onclick="location.href='reportedComments.do?page=${pageNum}'" class="${pageNum == currentPage ? 'selected' : ''}">${pageNum}</button>
    </c:forEach>
    <c:if test="${currentPage < totalPages}">
      <button onclick="location.href='reportedComments.do?page=${currentPage + 1}'">&gt;</button>
    </c:if>
  </div>

</div>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>