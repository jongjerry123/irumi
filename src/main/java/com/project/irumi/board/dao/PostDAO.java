package com.project.irumi.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.dashboard.model.dto.Job;

@Repository
public class PostDAO {

	@Autowired
	private SqlSession sqlSession;

	// 게시글 등록
	public void insertPost(PostDTO post) {
		sqlSession.insert("boardMapper.insertPost", post);
	}

	// 게시글 등록 후 ID 반환
	public Long insertPostAndReturnId(PostDTO post) {
		sqlSession.insert("boardMapper.insertPost", post);
		return sqlSession.selectOne("boardMapper.selectLastPostId");
	}

	// 게시글 단건 조회
	public PostDTO getPostById(Long postId) {
		return sqlSession.selectOne("boardMapper.selectPostById", postId);
	}

	// 게시글 댓글 전체 조회 (대댓글 순서 수정)
	public List<CommentDTO> getCommentsByPostId(Long postId) {
		return sqlSession.selectList("boardMapper.selectCommentsByPostIdOrdered", postId);
	}

	// 자유게시판/질문게시판 필터+정렬+검색 조회
	public List<PostDTO> selectFilteredPosts(String postType, String period, String sort, String keyword, int offset,
			int pageSize) {
		Map<String, Object> param = new HashMap<>();
		param.put("postType", postType);
		param.put("period", period);
		param.put("sort", sort);
		param.put("keyword", keyword);
		param.put("offset", offset);
		param.put("pageSize", pageSize);
		return sqlSession.selectList("boardMapper.selectFilteredPosts", param);
	}

	// 자유게시판/질문게시판 필터+검색된 게시글 수
	public int countFilteredPosts(String postType, String period, String keyword) {
		Map<String, Object> param = new HashMap<>();
		param.put("postType", postType);
		param.put("period", period);
		param.put("keyword", keyword);
		return sqlSession.selectOne("boardMapper.countFilteredPosts", param);
	}

	// 게시글 조회수 증가
	public void updatePostViewCount(Long postId) {
		sqlSession.update("boardMapper.updatePostViewCount", postId);
	}

	// 타입별 게시글 조회
	public List<PostDTO> selectByType(String postType) {
		return sqlSession.selectList("boardMapper.selectByType", postType);
	}

	// 타입별 게시글 페이징 조회
	public List<PostDTO> selectByTypeWithPaging(String postType, int offset, int pageSize) {
		Map<String, Object> param = new HashMap<>();
		param.put("postType", postType);
		param.put("offset", offset);
		param.put("pageSize", pageSize);
		return sqlSession.selectList("boardMapper.selectByTypeWithPaging", param);
	}

	// 타입별 게시글 수 조회
	public int countPostsByType(String postType) {
		return sqlSession.selectOne("boardMapper.countPostsByType", postType);
	}

	// 내 QnA 질문 목록 조회
	public List<PostDTO> selectMyOwnPosts(String userId, int offset, int pageSize) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("offset", offset);
		param.put("pageSize", pageSize);
		return sqlSession.selectList("boardMapper.selectMyQnaPosts", param);
	}

	// 내 QnA 질문 수 조회
	public int countMyQnaPosts(String userId) {
		return sqlSession.selectOne("boardMapper.countMyQnaPosts", userId);
	}

	// QnA 답변 여부 조회
	public boolean existsAnswerByPostId(Long postId) {
		Integer count = sqlSession.selectOne("boardMapper.countAnswersByPostId", postId);
		return count != null && count > 0;
	}

	// 신고된 게시글 수
	public int countReportedPosts() {
		return sqlSession.selectOne("boardMapper.countReportedPosts");
	}

	// 신고된 댓글 목록
	public List<CommentDTO> selectReportedComments(int offset, int pageSize) {
		Map<String, Object> param = new HashMap<>();
		param.put("offset", offset);
		param.put("pageSize", pageSize);
		return sqlSession.selectList("boardMapper.selectReportedComments", param);
	}

	// 신고된 댓글 수
	public int countReportedComments() {
		return sqlSession.selectOne("boardMapper.countReportedComments");
	}

	// 댓글 삭제
	public void deleteComment(Long commentId) {
		sqlSession.delete("boardMapper.deleteComment", commentId);
	}

	// 게시글 수정
	public void updatePost(PostDTO post) {
		sqlSession.update("boardMapper.updatePost", post);
	}
	

	// 게시글 삭제
	public void deletePost(Long postId) {
		sqlSession.delete("boardMapper.deletePost", postId);
	}

	// 게시글 추천 수 증가
	public void increaseRecommend(Long postId) {
		sqlSession.update("boardMapper.increaseRecommend", postId);
	}

	// 게시글 신고 수 증가
	public void increaseReport(Long postId) {
		sqlSession.update("boardMapper.increaseReport", postId);
	}

	// 댓글 등록
	public void insertComment(CommentDTO comment) {
		sqlSession.insert("boardMapper.insertComment", comment);
	}

	// 댓글 추천 수 증가
	public void increaseCommentRecommend(Long commentId) {
		sqlSession.update("boardMapper.increaseCommentRecommend", commentId);
	}

	// 댓글 신고 수 증가
	public void increaseCommentReport(Long commentId) {
		sqlSession.update("boardMapper.increaseCommentReport", commentId);
	}

	// 게시글 추천 중복 여부 확인
	public int countPostRecommend(String userId, Long postId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("postId", postId);
		return sqlSession.selectOne("boardMapper.countPostRecommend", param);
	}

	// 댓글 추천 중복 여부 확인
	public int countCommentRecommend(String userId, Long commentId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("commentId", commentId);
		return sqlSession.selectOne("boardMapper.countCommentRecommend", param);
	}

	// 게시글 추천 기록 삽입
	public void insertPostRecommend(String userId, Long postId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("postId", postId);
		sqlSession.insert("boardMapper.insertPostRecommend", param);
	}

	// 댓글 추천 기록 삽입
	public void insertCommentRecommend(String userId, Long commentId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("commentId", commentId);
		sqlSession.insert("boardMapper.insertCommentRecommend", param);
	}

	// 게시글 신고 중복 여부 확인
	public int countPostReport(String userId, Long postId) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("postId", postId);
		return sqlSession.selectOne("boardMapper.countPostReport", map);
	}

	public int countCommentReport(String userId, Long commentId) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("commentId", commentId);
		return sqlSession.selectOne("boardMapper.countCommentReport", map);
	}

	// 댓글 신고 기록 저장
	public void insertCommentReport(Long commentId, String reason, String reportedBy) {
		Map<String, Object> map = new HashMap<>();
		map.put("commentId", commentId);
		map.put("reason", reason);
		map.put("reportedBy", reportedBy);
		sqlSession.insert("boardMapper.insertCommentReport", map);
	}

	// 게시글 신고 기록 저장
	public void insertPostReport(Long postId, String reason, String reportedBy) {
		Map<String, Object> map = new HashMap<>();
		map.put("postId", postId);
		map.put("reason", reason);
		map.put("reportedBy", reportedBy);
		sqlSession.insert("boardMapper.insertPostReport", map);
	}

	// 게시글 ID 목록으로 작성자 ID 목록 조회
	public List<String> findWritersByPostIds(List<Long> postIds) {
		return sqlSession.selectList("boardMapper.findWritersByPostIds", postIds);
	}

	public String findWriterByPostId(Long postId) {
		return sqlSession.selectOne("boardMapper.findWriterByPostId", postId);
	}

	// 사용자 ID 목록을 불량 이용자로 업데이트
	public void updateUsersToBad(List<String> userIds) {
		sqlSession.update("boardMapper.updateUsersToBad", userIds);
	}

	public List<PostDTO> selectReportedPosts(int offset, int pageSize) {
		Map<String, Object> param = new HashMap<>();
		param.put("offset", offset);
		param.put("pageSize", pageSize);
		return sqlSession.selectList("boardMapper.selectReportedPosts", param);
	}

	// 게시글 삭제 전 신고 기록 삭제
	public void deletePostReports(List<Long> postIds) {
		sqlSession.delete("boardMapper.deletePostReports", postIds);
	}

	// 게시글 ID들에 해당하는 모든 댓글 삭제
	public void deleteCommentsByPostIds(List<Long> postIds) {
		sqlSession.delete("boardMapper.deleteCommentsByPostIds", postIds);
	}

	// 게시글 삭제
	public void deletePosts(List<Long> postIds) {
		sqlSession.delete("boardMapper.deletePosts", postIds);
	}
	
	//
	public List<Long> getCommentIdsByPostId(Long postId) {
	    return sqlSession.selectList("boardMapper.selectCommentIdsByPostId", postId);
	}


	// 게시글 ID 기준 댓글 신고 기록 삭제
	public void deleteCommentReportsByPostIds(List<Long> postIds) {
		sqlSession.delete("boardMapper.deleteCommentReportsByPostIds", postIds);
	}
	
	// 게시글 ID 기준 댓글 신고 신고기록 삭제 (TB_COMREPORT)
	public void deleteCommentReportReportsByPostIds(List<Long> postIds) {
		sqlSession.delete("boardMapper.deleteCommentReportReportsByPostIds", postIds);
	}
	
	// TB_COMREPORT: 댓글 신고 기록 삭제 - 댓글 ID 기준
	public void deleteCommentReportReportsByCommentIds(List<Long> commentIds) {
		sqlSession.delete("boardMapper.deleteCommentReportReportsByCommentIds", commentIds);
	}

	// 게시글 ID 기준 댓글 추천 기록 삭제
	public void deleteCommentRecommendsByPostIds(List<Long> postIds) {
		sqlSession.delete("boardMapper.deleteCommentRecommendsByPostIds", postIds);
	}

	// 게시글 ID 기준 게시글 추천 기록 삭제
	public void deletePostRecommends(List<Long> postIds) {
		sqlSession.delete("boardMapper.deletePostRecommends", postIds);
	}

	// 댓글 추천 삭제
	public void deleteCommentRecommendsByCommentIds(List<Long> commentIds) {
		sqlSession.delete("boardMapper.deleteCommentRecommendsByCommentIds", commentIds);
	}

	// 댓글 신고 삭제
	public void deleteCommentReportsByCommentIds(List<Long> commentIds) {
		sqlSession.delete("boardMapper.deleteCommentReportsByCommentIds", commentIds);
	}

	// 댓글 삭제
	public void deleteComments(List<Long> commentIds) {
		sqlSession.delete("boardMapper.deleteComments", commentIds);
	}

	// 댓글 ID 리스트로 작성자 ID 조회
	public List<String> findWritersByCommentIds(List<Long> commentIds) {
		return sqlSession.selectList("boardMapper.findWritersByCommentIds", commentIds);
	}

	public String findCommentWriterByCommentId(Long commentId) {
		return sqlSession.selectOne("boardMapper.findCommentWriterByCommentId", commentId);
	}

	// 사용자 권한 변경
	public void updateUserAuthorityToBad(String userId) {
		sqlSession.update("boardMapper.updateUserAuthorityToBad", userId);
	}

	public boolean isUserAlreadyBad(String userId) {
		Integer result = sqlSession.selectOne("boardMapper.isUserAlreadyBad", userId);
		return result != null && result == 1;
	}

	public void updateUserAuthority(List<String> userIds, int authority) {
		Map<String, Object> param = new HashMap<>();
		param.put("userIds", userIds);
		param.put("authority", authority);
		sqlSession.update("boardMapper.updateUserAuthority", param);
	}

	public void updateUserAuthorityByPostId(Long postId) {
		sqlSession.update("boardMapper.updateUserAuthorityByPostId", postId);
	}

	// 불량 이용자 전체 조회 (페이징 X, 전체 조회용이면 그대로 사용)
	public List<Map<String, Object>> selectBadUsers() {
		return sqlSession.selectList("boardMapper.selectBadUsers");
	}

	// 불량 이용자 수 카운트
	public int countBadUsers() {
		return sqlSession.selectOne("boardMapper.countBadUsers");
	}
	
	// 불량 이용자 등록 사유 업데이트하기
	public void updatePostReportReason(Long postId, String reportedBy, String reason) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("postId", postId);
	    map.put("reportedBy", reportedBy);
	    map.put("reason", reason);
	    sqlSession.update("boardMapper.updatePostReportReason", map);
	}
	
	public void updateCommentReportReason(Long commentId, String reportedBy, String reason) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("commentId", commentId);
	    map.put("reportedBy", reportedBy);
	    map.put("reason", reason);
	    sqlSession.update("boardMapper.updateCommentReportReason", map);
	}
	
	// 사용자 권한 조회
	public int getUserAuthority(String userId) {
	    return sqlSession.selectOne("boardMapper.selectUserAuthority", userId);
	}
	
}
