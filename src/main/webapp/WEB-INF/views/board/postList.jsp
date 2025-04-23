<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Q&A 게시판</title>
    <style>
        body {
            background-color: #111;
            color: white;
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0;
            padding: 0;
        }

        .wrapper {
            width: 80%;
            margin: 80px auto;
        }

        .tabs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .tab {
            background: #333;
            color: #aaa;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            border: none;
        }

        .tab.selected {
            background: #600c7a;
            color: white;
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background: #1e1e1e;
            border-radius: 12px;
            overflow: hidden;
        }

        th, td {
            padding: 16px;
            border-bottom: 1px solid #333;
            text-align: center;
        }

        th {
            background: #222;
            color: #bbb;
        }

        td a {
            color: #c09;
            font-weight: bold;
            text-decoration: none;
        }

        .footer-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }

        .footer-buttons button {
            background: #600c7a;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 10px;
        }

        .page-btn {
            background: #222;
            color: #aaa;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        .page-btn.selected {
            background: #600c7a;
            color: white;
        }

    </style>
</head>
<body>

<div class="wrapper">
    <div class="tabs">
        <button class="tab selected">Q&A</button>
        <button class="tab">공지사항</button>
        <button class="tab">자유 주제</button>
    </div>

    <table>
        <thead>
        <tr>
            <th>작성자</th>
            <th>글 제목</th>
            <th>답변유무</th>
            <th>작성일자</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>질문맨1</td>
            <td>작성자와 관리자만 볼 수 있는 글입니다.</td>
            <td>N</td>
            <td>2025/03/30</td>
        </tr>
        <tr>
            <td>질문맨2</td>
            <td><a href="#">챗봇 사용관련 문의드립니다.</a></td>
            <td>Y</td>
            <td>2025/03/30</td>
        </tr>
        <tr>
            <td>질문맨3</td>
            <td>작성자와 관리자만 볼 수 있는 글입니다.</td>
            <td>Y</td>
            <td>2025/03/28</td>
        </tr>
        </tbody>
    </table>

    <div class="footer-buttons">
        <button>질문 등록</button>
        <button>내 질문만 보기</button>
    </div>

    <div class="pagination">
        <button class="page-btn">&lt;</button>
        <button class="page-btn selected">2</button>
        <button class="page-btn">&gt;</button>
    </div>
</div>

</body>
</html>