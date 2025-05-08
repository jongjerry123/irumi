<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="/WEB-INF/views/common/header.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<style>
body {
	background-color: #000;
	color: #fff;
	font-family: 'Noto Sans KR', sans-serif;
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
textarea {
	display: none;
}
#editor-container {
	height: 300px;
	background-color: white;
	color: black;
	border-radius: 6px;
}
.btn-wrap {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}
.btn-submit, .btn-cancel, .btn-remove {
	padding: 10px 24px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	border: none;
	transition: all 0.3s ease;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
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
.btn-remove {
	background-color: #4c1f35;
}
.btn-remove:hover {
	background-color: #a9446f;
	box-shadow: 0 3px 6px rgba(169, 67, 111, 0.4);
	transform: translateY(-1px);
}
.existing-file {
	margin-top: 10px;
	padding: 10px;
	background-color: #1a1a1a;
	border: 1px solid #333;
	border-radius: 6px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	font-size: 14px;
}
.existing-file a {
	color: #A983A3;
}
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
</head>
<body>
<div class="main-content">
	<h2>게시글 수정</h2>

	<form action="updatePost.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="postId" value="${post.postId}" />
		<input type="hidden" name="postType" value="${post.postType}" />

		<label for="category">카테고리</label>
		<select id="category" name="category" disabled>
			<option value="일반" ${post.postType eq '일반' ? 'selected' : ''}>자유게시판</option>
			<option value="질문" ${post.postType eq '질문' ? 'selected' : ''}>Q&A</option>
			<c:if test="${loginUser.userAuthority eq '2'}">
				<option value="공지" ${post.postType eq '공지' ? 'selected' : ''}>공지사항</option>
			</c:if>
		</select>

		<label for="title">제목</label>
		<input type="text" id="title" name="postTitle" value="${post.postTitle}" required />

		<label for="editor-container">내용</label>
		<div id="editor-container"></div>
		<textarea id="content" name="postContent" style="display:none;">${post.postContent}</textarea>

		<c:if test="${not empty post.postOriginalName}">
		  <div class="existing-file" id="existingFileBox">
		    <div>
		      <strong>첨부파일:</strong> 
		      <a href="resources/uploads/${post.postSavedName}" download="${post.postOriginalName}">
		        ${post.postOriginalName}
		      </a>
		    </div>
		    <div>
		      <button type="button" class="btn-delete" onclick="removeAttachedFile()">제거</button>
		    </div>
		  </div>
		  <input type="hidden" name="deleteFile" id="deleteFile" value="false" />
		</c:if>

		<label for="fileUpload">새 파일 첨부</label>
		<input type="file" id="fileUpload" name="uploadFile"
		       accept=".png,.jpg,.jpeg,.gif,.pdf,.zip,.docx,.txt" />

		<div class="btn-wrap">
			<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
			<button type="submit" class="btn-submit">수정 완료</button>
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
              const range = quill.getSelection(true);
              quill.insertEmbed(range.index, 'image', imageUrl);
            } catch (err) {
              console.error('이미지 업로드 실패', err);
              alert('이미지 업로드 실패!');
            }
          };
        }
      }
    }
  }
});

// 기존 내용 불러오기
quill.root.innerHTML = document.getElementById('content').value;

// 제출 시 textarea에 내용 삽입
document.querySelector('form').addEventListener('submit', function () {
  document.getElementById('content').value = quill.root.innerHTML;
});

// 첨부파일 제거 버튼
function removeAttachedFile() {
  const box = document.getElementById("existingFileBox");
  if (box) {
    box.remove();
    document.getElementById("deleteFile").value = "true";
  }
}
</script>

<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>