<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>글쓰기</title>

<!-- ✅ Quill 에디터 -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #000 !important;
	color: #fff;
}

.main-content {
	padding: 40px 140px;
	max-width: 800px;
	margin: 0 auto;
}
h2 {
	margin-bottom: 30px;
	color: #A983A3;
}
form {
	display: flex;
	flex-direction: column;
	gap: 16px;
}
label {
	font-size: 16px;
	margin-bottom: 6px;
}
input[type="text"], select {
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #444;
	background-color: #1a1a1a;
	color: #fff;
	width: 100%;
}
#editor-container {
	height: 300px;
	background-color: white;
	color: black;
	border-radius: 6px;
}
textarea {
	display: none;
}
.btn-wrap {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 20px;
}
.btn-submit, .btn-cancel {
	padding: 10px 24px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	transition: all 0.3s ease;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
	border: none;
}
.btn-submit {
	background-color: #A983A3;
}
.btn-submit:hover {
	background-color: #8c6c8c;
	box-shadow: 0 4px 8px rgba(169, 131, 163, 0.4);
	transform: translateY(-1px);
}
.btn-cancel {
	background-color: #444;
}
.btn-cancel:hover {
	background-color: #666;
	box-shadow: 0 3px 6px rgba(255, 255, 255, 0.1);
	transform: translateY(-1px);
}

/* ✅ 파일 첨부 스타일 개선 */
input[type="file"] {
	background-color: #1a1a1a;
	color: white;
	border: 1px solid #A983A3;
	padding: 8px 14px;
	border-radius: 8px;
	cursor: pointer;
}
input[type="file"]::file-selector-button {
	background-color: #A983A3;
	color: white;
	border: none;
	padding: 6px 12px;
	border-radius: 6px;
	cursor: pointer;
}
input[type="file"]::file-selector-button:hover {
	background-color: #8c6c8c;
}

/* ✅ Quill 다크 테마 */
.ql-toolbar.ql-snow {
	background-color: #1a1a1a;
	border: 1px solid #444;
}
.ql-toolbar.ql-snow .ql-picker-label,
.ql-toolbar.ql-snow .ql-picker-item {
	color: #fff;
}
.ql-container.ql-snow {
	background-color: #111;
	color: #fff;
	border: 1px solid #444;
}
.ql-editor::before {
	color: #777;
}
</style>

<script>
function updateHeaderAndType(select) {
  const type = select.value;
  const header = document.getElementById('post-header');
  const hiddenInput = document.querySelector('input[name="postType"]');

  switch (type) {
    case '질문': header.innerText = '질문 등록'; break;
    case '공지': header.innerText = '공지사항 등록'; break;
    default: header.innerText = '글쓰기';
  }

  hiddenInput.value = type;
}
</script>
</head>

<body>
<div class="main-content">
	<h2 id="post-header">
		<c:choose>
			<c:when test="${param.type eq '질문'}">질문 등록</c:when>
			<c:when test="${param.type eq '공지'}">공지사항 등록</c:when>
			<c:otherwise>글쓰기</c:otherwise>
		</c:choose>
	</h2>

	<form action="insertPost.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="postType" value="${param.type}" />

		<label for="category">카테고리</label>
		<select id="category" name="category" onchange="updateHeaderAndType(this)">
			<option value="일반" ${param.type eq '일반' ? 'selected' : ''}>자유게시판</option>
			<option value="질문" ${param.type eq '질문' ? 'selected' : ''}>Q&A</option>
			<c:if test="${loginUser.userAuthority eq '2'}">
				<option value="공지" ${param.type eq '공지' ? 'selected' : ''}>공지사항</option>
			</c:if>
		</select>

		<label for="title">제목</label>
		<input type="text" id="title" name="postTitle" required />

		<label for="editor-container">내용</label>
		<div id="editor-container"></div>
		<textarea name="postContent" id="content"></textarea>

		<label for="fileUpload">파일 첨부</label>
		<input type="file" id="fileUpload" name="uploadFile"
		       accept=".png,.jpg,.jpeg,.gif,.pdf,.zip,.docx,.txt" />

		<div class="btn-wrap">
			<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
			<button type="submit" class="btn-submit">등록</button>
		</div>
	</form>
</div>

<!-- ✅ Quill 초기화 및 이미지 업로드 핸들러 -->
<script>
const quill = new Quill('#editor-container', {
  theme: 'snow',
  placeholder: '내용을 입력하세요...',
  modules: {
    toolbar: {
      container: [
        ['bold', 'italic', 'underline'],
        ['link', 'image'],
        [{ 'list': 'ordered' }, { 'list': 'bullet' }],
        ['clean']
      ],
      handlers: {
        image: function () {
          const input = document.createElement('input');
          input.setAttribute('type', 'file');
          input.setAttribute('accept', 'image/*');
          input.click();

          input.onchange = async () => {
            const file = input.files[0];
            if (!file) return;

            const formData = new FormData();
            formData.append('image', file);

            try {
              const res = await fetch('uploadImage.do', {
                method: 'POST',
                body: formData
              });

              const imageUrl = await res.text();
              console.log("✅ 서버가 준 이미지 경로:", imageUrl);

              const range = quill.getSelection(true);
              quill.insertEmbed(range.index, 'image', imageUrl);
            } catch (err) {
              console.error("❌ 이미지 업로드 실패", err);
              alert("이미지 업로드 실패!");
            }
          };
        }
      }
    }
  }
});

// 폼 제출 시 에디터 내용을 textarea에 반영
document.querySelector('form').addEventListener('submit', function () {
  document.getElementById('content').value = quill.root.innerHTML;
});
</script>

<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>