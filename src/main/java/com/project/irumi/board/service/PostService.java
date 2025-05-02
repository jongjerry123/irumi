package com.project.irumi.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.irumi.board.dao.PostDAO;
import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;

@Service
public class PostService {

	@Autowired
	private PostDAO postDAO;

	// 게시글 등록
	public void insertPost(PostDTO post) {
		postDAO.insertPost(post);
	}

	// 게시글 등록 후 ID 반환
	public Long insertPostAndReturnId(PostDTO post) {
		return postDAO.insertPostAndReturnId(post);
	}

	// 게시글 단건 조회
	public PostDTO getPostById(Long postId) {
		return postDAO.getPostById(postId);
	}

	// 게시글 댓글 전체 조회
	public List<CommentDTO> getCommentsByPostId(Long postId) {
		return postDAO.getCommentsByPostId(postId);
	}

	// 게시글 타입별 조회
	public List<PostDTO> getPostsByType(String postType) {
		return postDAO.selectByType(postType);
	}

	// 게시글 타입별 페이징 조회 + QnA 답변 여부 체크
	public List<PostDTO> getPostsByTypeWithPaging(String postType, int offset, int pageSize) {
		List<PostDTO> posts = postDAO.selectByTypeWithPaging(postType, offset, pageSize);

		if ("질문".equals(postType)) {
			for (PostDTO post : posts) {
				boolean hasAnswer = postDAO.existsAnswerByPostId(post.getPostId());
				post.setHasAnswer(hasAnswer);
			}
		}

		return posts;
	}

	// 게시글 타입별 수 조회
	public int countPostsByType(String postType) {
		return postDAO.countPostsByType(postType);
	}

	// 게시글 필터링/검색 조회
	public List<PostDTO> getFilteredPosts(String postType, String period, String sort, String keyword, int offset,
			int pageSize) {
		return postDAO.selectFilteredPosts(postType, period, sort, keyword, offset, pageSize);
	}

	// 게시글 필터링/검색 수 조회
	public int countFilteredPosts(String postType, String period, String keyword) {
		return postDAO.countFilteredPosts(postType, period, keyword);
	}

	// 조회수 증가
	public void increasePostViewCount(Long postId) {
		postDAO.updatePostViewCount(postId);
	}

	// 신고된 댓글 조회
	public List<CommentDTO> getReportedComments(int offset, int pageSize) {
		return postDAO.selectReportedComments(offset, pageSize);
	}

	// 신고된 댓글 수
	public int countReportedComments() {
		return postDAO.countReportedComments();
	}

	// 댓글 삭제 (복수 선택)
	public void deleteCommentsByIds(List<Long> commentIds) {
		postDAO.deleteComments(commentIds);
	}

	// 댓글 삭제 (단건)
	public void deleteComment(Long commentId) {
		postDAO.deleteCommentReportsByCommentIds(List.of(commentId));
		postDAO.deleteComment(commentId);
	}

	// 관리자 답변 여부
	public boolean hasAnswer(Long postId) {
		return postDAO.existsAnswerByPostId(postId);
	}

	// 내 QnA 조회
	public List<PostDTO> getMyQnaPosts(String userId, int offset, int pageSize) {
		return postDAO.selectMyOwnPosts(userId, offset, pageSize);
	}

	// 내 QnA 수
	public int countMyQnaPosts(String userId) {
		return postDAO.countMyQnaPosts(userId);
	}

	// 게시글 수정
	public void updatePost(PostDTO post) {
		postDAO.updatePost(post);
	}

	// 게시글 삭제 (단건)
	public void deletePost(Long postId) {
		postDAO.deletePost(postId);
	}

	// 추천 수 증가
	public void recommendPost(Long postId) {
		postDAO.increaseRecommend(postId);
	}

	// 신고 수 증가
	public void reportPost(Long postId) {
		postDAO.increaseReport(postId);
	}

	// 댓글 등록 (일반 및 대댓글)
	public void addComment(Long postId, String commentContent, String userId, Long parentId) {
		CommentDTO comment = new CommentDTO();
		comment.setPostId(postId);
		comment.setComContent(commentContent);
		comment.setComWrId(userId);
		comment.setComParentId(parentId);
		postDAO.insertComment(comment);
	}

	// 댓글 추천 수 증가
	public void recommendComment(Long commentId) {
		postDAO.increaseCommentRecommend(commentId);
	}

	// 댓글 신고 수 증가
	public void reportComment(Long commentId) {
		postDAO.increaseCommentReport(commentId);
	}

	// 게시글 추천 중복 체크
	public boolean hasAlreadyRecommendedPost(String userId, Long postId) {
		return postDAO.countPostRecommend(userId, postId) > 0;
	}

	// 댓글 추천 중복 체크
	public boolean hasAlreadyRecommendedComment(String userId, Long commentId) {
		return postDAO.countCommentRecommend(userId, commentId) > 0;
	}

	// 게시글 추천 처리
	public void recommendPost(Long postId, String userId) {
		postDAO.insertPostRecommend(userId, postId);
		postDAO.increaseRecommend(postId);
	}

	// 댓글 추천 처리
	public void recommendComment(Long commentId, String userId) {
		postDAO.insertCommentRecommend(userId, commentId);
		postDAO.increaseCommentRecommend(commentId);
	}

	// 게시글 신고 중복 체크
	public boolean hasAlreadyReportedPost(String userId, Long postId) {
		return postDAO.countPostReport(userId, postId) > 0;
	}

	// 댓글 신고 중복 체크
	public boolean hasAlreadyReportedComment(String userId, Long commentId) {
		return postDAO.countCommentReport(userId, commentId) > 0;
	}

	// 댓글 신고 처리
	public void reportComment(Long commentId, String userId) {
		postDAO.insertCommentReport(commentId, "관리자 수동 신고", userId); // ✅ 순서 맞춤
		postDAO.increaseCommentReport(commentId);
	}

	// 게시글 신고 처리
	public void reportPost(Long postId, String userId) {
		postDAO.insertPostReport(postId, "관리자 수동 신고", userId); // ✅ 순서 맞춤
		postDAO.increaseReport(postId);
	}

	// 게시글 여러 개 삭제 (단독)
	public void deletePosts(List<Long> postIds) {
		postDAO.deletePosts(postIds);
	}

	// 게시글과 관련된 신고 기록 모두 삭제
	public void deletePostReports(List<Long> postIds) {
		postDAO.deletePostReports(postIds);
	}

	// 게시글과 댓글, 신고기록을 모두 삭제하는 메서드
	public void deletePostsAndReports(List<Long> postIds) {
		postDAO.deleteCommentRecommendsByPostIds(postIds); // 1. 댓글 추천 기록 삭제
		postDAO.deleteCommentReportsByPostIds(postIds); // 2. 댓글 신고 기록 삭제
		postDAO.deleteCommentsByPostIds(postIds); // 3. 댓글 삭제
		postDAO.deletePostRecommends(postIds); // 4. 게시글 추천 기록 삭제
		postDAO.deletePostReports(postIds); // 5. 게시글 신고 기록 삭제
		postDAO.deletePosts(postIds); // 6. 게시글 삭제
	}

	// 선택된 댓글들을 추천/신고 기록 포함하여 안전하게 삭제
	public void deleteReportedCommentsByIds(List<Long> commentIds) {
		postDAO.deleteCommentRecommendsByCommentIds(commentIds); // 1. 댓글 추천 기록 삭제
		postDAO.deleteCommentReportsByCommentIds(commentIds); // 2. 댓글 신고 기록 삭제
		postDAO.deleteComments(commentIds); // 3. 댓글 삭제
	}

	// 게시글 ID로 작성자 ID 조회 후 불량이용자로 등록
	public void registerBadUsersFromPosts(List<Long> postIds, String reason, String reportedBy) {
		for (Long postId : postIds) {
			String userId = postDAO.findWriterByPostId(postId);
			if (postDAO.isUserAlreadyBad(userId)) {
				throw new IllegalStateException("이미 등록되어 있는 사용자입니다.");
			}

			boolean alreadyReported = postDAO.countPostReport(reportedBy, postId) > 0;
			if (!alreadyReported) {
				postDAO.insertPostReport(postId, reason, reportedBy);
			}

			postDAO.updateUserAuthorityByPostId(postId);
		}
	}

	// 신고된 게시글 목록 조회
	public List<PostDTO> getReportedPosts(int offset, int pageSize) {
		return postDAO.selectReportedPosts(offset, pageSize);
	}

	// 신고된 게시글 수 조회
	public int countReportedPosts() {
		return postDAO.countReportedPosts();
	}

	// 댓글 ID로 작성자 ID 조회 후 불량이용자로 등록
	public void registerBadUsersFromComments(List<Long> commentIds, String reason, String reportedBy) {
		for (Long commentId : commentIds) {

			// 1. 댓글 작성자 ID 조회
			String userId = postDAO.findCommentWriterByCommentId(commentId);

			// 2. 이미 불량 등록된 사용자면 예외 발생
			if (postDAO.isUserAlreadyBad(userId)) {
				throw new IllegalStateException("이미 등록되어 있는 사용자입니다.");
			}

			// 3. 중복 신고 insert 방지
			boolean alreadyReported = postDAO.countCommentReport(reportedBy, commentId) > 0;
			if (!alreadyReported) {
				postDAO.insertCommentReport(commentId, reason, reportedBy);
			}

			// 4. 사용자 불량 권한 설정
			postDAO.updateUserAuthorityToBad(userId);
		}
	}

	// 사용자 권한 변경
	public void updateUserAuthority(List<String> userIds, int authority) {
		postDAO.updateUserAuthority(userIds, authority);
	}

	// 불량 이용자 조회
	public List<Map<String, Object>> getBadUsers() {
		return postDAO.selectBadUsers();
	}

	// 불량 이용자 카운트
	public int countBadUsers() {
		return postDAO.countBadUsers();
	}
}
