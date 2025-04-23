<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>커뮤니티</title>
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
    .filters {
      display: flex;
      gap: 12px;
      margin-bottom: 20px;
    }
    .dropdown {
      position: relative;
    }
    .dropdown-button {
      background-color: #222;
      color: #fff;
      padding: 8px 16px;
      border: 1px solid #444;
      border-radius: 8px;
      cursor: pointer;
    }
    .dropdown-button.selected {
      border: 1px solid #A983A3;
      color: #A983A3;
    }
    .dropdown-content {
      display: none;
      position: absolute;
      background-color: #222;
      border: 1px solid #444;
      top: 38px;
      left: 0;
      z-index: 1;
      border-radius: 8px;
    }
    .dropdown-content button {
      display: block;
      padding: 8px 16px;
      width: 100%;
      border: none;
      background-color: #222;
      color: #fff;
      text-align: left;
      cursor: pointer;
    }
    .dropdown-content button:hover {
      background-color: #333;
    }
    .filters .sort-btn {
      background-color: #222;
      color: #fff;
      border: 1px solid #444;
      padding: 8px 16px;
      border-radius: 8px;
      cursor: pointer;
    }
    .filters .sort-btn.selected {
      border: 1px solid #A983A3;
      color: #A983A3;
    }
    .board-header {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      margin-bottom: 20px;
    }
    .board-header .write-btn {
      background-color: #A983A3;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      color: #fff;
      cursor: pointer;
    }
    table.board-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    table.board-table th, table.board-table td {
      border: 1px solid #444;
      padding: 12px;
      text-align: center;
    }
    table.board-table th {
      background-color: #222;
    }
    table.board-table td {
      background-color: #1a1a1a;
    }
    table.board-table td:nth-child(2) {
      text-align: left;
      padding-left: 20px;
      width: 60%;
    }
    table.board-table td:nth-child(1),
    table.board-table td:nth-child(3),
    table.board-table td:nth-child(4),
    table.board-table td:nth-child(5) {
      width: 10%;
    }
    .empty-message {
      text-align: center;
      padding: 40px;
      font-size: 16px;
      color: #aaa;
    }
    .board-footer {
      display: flex;
      flex-direction: column;
      align-items: stretch;
      margin-top: 30px;
      gap: 12px;
    }
    .board-footer-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .board-footer .pagination {
      display: flex;
      gap: 10px;
      justify-content: center;
    }
    .board-footer .pagination button {
      background-color: #222;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
    }
    .board-footer .search-box {
      display: flex;
      gap: 6px;
      align-items: center;
    }
    .board-footer input[type="text"] {
      padding: 8px;
      border-radius: 4px;
      border: 2px solid transparent;
      outline: none;
      background-color: #1a1a1a;
      color: #fff;
      transition: border 0.3s, background-color 0.3s;
    }
    .board-footer input[type="text"]:focus {
      border: 2px solid #A983A3;
      background-color: #222;
    }
    .board-footer button.search-btn {
      background-color: #444;
      color: #fff;
      border: none;
      padding: 8px 14px;
      border-radius: 6px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="main-content">
    <div class="category-bar">
      <h2>커뮤니티</h2>
      <div class="tabs">
        <button class="active" onclick="location.href='boardPage.do'">자유게시판</button>
        <button onclick="location.href='qnaList.do'">Q&A</button>
        <button onclick="location.href='noticeList.do'">공지사항</button>
      </div>
    </div>

    <div class="filters">
      <div class="dropdown">
        <button class="dropdown-button selected" onclick="toggleDropdown(this)" id="periodBtn">단위기간: 전체</button>
        <div class="dropdown-content">
          <button onclick="selectPeriod(this, '전체')">전체</button>
          <button onclick="selectPeriod(this, '최근 한달')">최근 한달</button>
          <button onclick="selectPeriod(this, '최근 1일')">최근 1일</button>
        </div>
      </div>
      <button class="sort-btn" onclick="highlightSort(this)">조회수 정렬</button>
      <button class="sort-btn" onclick="highlightSort(this)">추천순 정렬</button>
    </div>

    <div class="board-header">
      <button class="write-btn">✏ 글쓰기</button>
    </div>

    <table class="board-table">
      <thead>
        <tr>
          <th>작성자</th>
          <th>글 제목</th>
          <th>작성일자</th>
          <th>조회수</th>
          <th>추천</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td colspan="5" class="empty-message">등록된 게시글이 없습니다.</td>
        </tr>
      </tbody>
    </table>

    <div class="board-footer">
      <div class="board-footer-top">
        <div class="post-count">글 수: 0개</div>
        <div class="search-box">
          <input type="text" placeholder="검색 키워드 입력 후 엔터" />
          <button class="search-btn">↵</button>
        </div>
      </div>
      <div class="pagination">
        <button>&lt;</button>
        <button>1</button>
        <button>&gt;</button>
      </div>
    </div>
  </div>
  <c:import url="/WEB-INF/views/common/footer.jsp"></c:import>

  <script>
    function toggleDropdown(btn) {
      const dropdown = btn.nextElementSibling;
      dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    }

    function selectPeriod(el, label) {
      const dropdownBtn = document.getElementById('periodBtn');
      dropdownBtn.innerText = `단위기간: ${label}`;
      dropdownBtn.classList.add('selected');
      el.closest('.dropdown-content').style.display = 'none';
    }

    function highlightSort(button) {
      document.querySelectorAll('.sort-btn').forEach(btn => btn.classList.remove('selected'));
      button.classList.add('selected');
    }
  </script>
</body>
</html>