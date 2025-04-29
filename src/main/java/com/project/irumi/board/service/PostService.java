package com.project.irumi.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.project.irumi.board.dao.PostDAO;
import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;

import jakarta.annotation.Resource;

@Service
public class PostService {

    @Resource
    private PostDAO postDAO;

    // ✅ 게시글 등록
    public void insertPost(PostDTO post) { postDAO.insertPost(post); }

    // ✅ 게시글 등록 후 ID 반환
    public Long insertPostAndReturnId(PostDTO post) { return postDAO.insertPostAndReturnId(post); }

    // ✅ 게시글 단건 조회
    public PostDTO getPostById(Long postId) { return postDAO.getPostById(postId); }

    // ✅ 게시글 댓글 전체 조회
    public List<CommentDTO> getCommentsByPostId(Long postId) { return postDAO.getCommentsByPostId(postId); }

    // ✅ 게시글 타입별 조회
    public List<PostDTO> getPostsByType(String postType) { return postDAO.selectByType(postType); }

    // ✅ 게시글 타입별 페이징 조회
    public List<PostDTO> getPostsByTypeWithPaging(String postType, int offset, int pageSize) { return postDAO.selectByTypeWithPaging(postType, offset, pageSize); }

    // ✅ 게시글 타입별 수 조회
    public int countPostsByType(String postType) { return postDAO.countPostsByType(postType); }

    // ✅ 게시글 필터링/검색 조회
    public List<PostDTO> getFilteredPosts(String postType, String period, String sort, String keyword, int offset, int pageSize) {
        return postDAO.selectFilteredPosts(postType, period, sort, keyword, offset, pageSize);
    }

    // ✅ 게시글 필터링/검색 수 조회
    public int countFilteredPosts(String postType, String period, String keyword) { return postDAO.countFilteredPosts(postType, period, keyword); }

    // ✅ 조회수 증가
    public void increasePostViewCount(Long postId) { postDAO.updatePostViewCount(postId); }

    // ✅ 신고된 댓글 조회
    public List<CommentDTO> getReportedComments(int offset, int pageSize) { return postDAO.selectReportedComments(offset, pageSize); }

    // ✅ 신고된 댓글 수
    public int countReportedComments() { return postDAO.countReportedComments(); }

    // ✅ 댓글 삭제 (복수 선택)
    public void deleteCommentsByIds(List<Long> commentIds) { postDAO.deleteComments(commentIds); }

    // ✅ 댓글 삭제 (단건)
    public void deleteComment(Long commentId) { postDAO.deleteComment(commentId); }

    // ✅ 관리자 답변 여부
    public boolean hasAnswer(Long postId) { return postDAO.existsAnswerByPostId(postId); }

    // ✅ 내 QnA 조회
    public List<PostDTO> getMyQnaPosts(String userId, int offset, int pageSize) { return postDAO.selectMyOwnPosts(userId, offset, pageSize); }

    // ✅ 내 QnA 수
    public int countMyQnaPosts(String userId) { return postDAO.countMyQnaPosts(userId); }

    // ✅ 게시글 수정
    public void updatePost(PostDTO post) { postDAO.updatePost(post); }

    // ✅ 게시글 삭제 (단건)
    public void deletePost(Long postId) { postDAO.deletePost(postId); }

    // ✅ 추천 수 증가
    public void recommendPost(Long postId) { postDAO.increaseRecommend(postId); }

    // ✅ 신고 수 증가
    public void reportPost(Long postId) { postDAO.increaseReport(postId); }

    // ✅ 댓글 등록 (일반 및 대댓글)
    public void addComment(Long postId, String commentContent, String userId, Long parentId) {
        CommentDTO comment = new CommentDTO();
        comment.setPostId(postId);
        comment.setComContent(commentContent);
        comment.setComWrId(userId);
        comment.setComParentId(parentId);
        postDAO.insertComment(comment);
    }

    // ✅ 댓글 추천 수 증가
    public void recommendComment(Long commentId) { postDAO.increaseCommentRecommend(commentId); }

    // ✅ 댓글 신고 수 증가
    public void reportComment(Long commentId) { postDAO.increaseCommentReport(commentId); }

    // ✅ 게시글 추천 중복 체크
    public boolean hasAlreadyRecommendedPost(String userId, Long postId) { return postDAO.countPostRecommend(userId, postId) > 0; }

    // ✅ 댓글 추천 중복 체크
    public boolean hasAlreadyRecommendedComment(String userId, Long commentId) { return postDAO.countCommentRecommend(userId, commentId) > 0; }

    // ✅ 게시글 추천 처리
    public void recommendPost(Long postId, String userId) {
        postDAO.insertPostRecommend(userId, postId);
        postDAO.increaseRecommend(postId);
    }

    // ✅ 댓글 추천 처리
    public void recommendComment(Long commentId, String userId) {
        postDAO.insertCommentRecommend(userId, commentId);
        postDAO.increaseCommentRecommend(commentId);
    }

    // ✅ 게시글 신고 중복 체크
    public boolean hasAlreadyReportedPost(String userId, Long postId) { return postDAO.countPostReport(userId, postId) > 0; }

    // ✅ 댓글 신고 중복 체크
    public boolean hasAlreadyReportedComment(String userId, Long commentId) { return postDAO.countCommentReport(userId, commentId) > 0; }

    // ✅ 댓글 신고 처리
    public void reportComment(Long commentId, String userId) {
        postDAO.insertCommentReport(userId, commentId);
        postDAO.increaseCommentReport(commentId);
    }

    // ✅ 게시글 신고 처리
    public void reportPost(Long postId, String userId) {
        postDAO.insertPostReport(userId, postId);
        postDAO.increaseReport(postId);
    }

    // ✅ 게시글 여러 개 삭제 (단독)
    public void deletePosts(List<Long> postIds) { postDAO.deletePosts(postIds); }

    // ✅ 게시글과 관련된 신고 기록 모두 삭제
    public void deletePostReports(List<Long> postIds) { postDAO.deletePostReports(postIds); }

 // ✅ 게시글과 댓글, 신고기록을 모두 삭제하는 메서드
    public void deletePostsAndReports(List<Long> postIds) {
        postDAO.deleteCommentRecommendsByPostIds(postIds);  // 1. 댓글 추천 기록 삭제
        postDAO.deleteCommentReportsByPostIds(postIds);     // 2. 댓글 신고 기록 삭제
        postDAO.deleteCommentsByPostIds(postIds);           // 3. 댓글 삭제
        postDAO.deletePostRecommends(postIds);               // 4. 게시글 추천 기록 삭제
        postDAO.deletePostReports(postIds);                  // 5. 게시글 신고 기록 삭제
        postDAO.deletePosts(postIds);                        // 6. 게시글 삭제
    }
    
 // ✅ 선택된 댓글들을 추천/신고 기록 포함하여 안전하게 삭제
    public void deleteReportedCommentsByIds(List<Long> commentIds) {
        postDAO.deleteCommentRecommendsByCommentIds(commentIds); // 1. 댓글 추천 기록 삭제
        postDAO.deleteCommentReportsByCommentIds(commentIds);    // 2. 댓글 신고 기록 삭제
        postDAO.deleteComments(commentIds);                      // 3. 댓글 삭제
    }
    
    // ✅ 게시글 ID로 작성자 ID 조회 후 불량이용자로 등록
    public void registerBadUsersFromPosts(List<Long> postIds) {
        List<String> userIds = postDAO.findWritersByPostIds(postIds);
        if (userIds != null && !userIds.isEmpty()) {
            postDAO.updateUsersToBad(userIds);
        }
    }

    // ✅ 신고된 게시글 목록 조회
    public List<PostDTO> getReportedPosts(int offset, int pageSize) { return postDAO.selectReportedPosts(offset, pageSize); }

    // ✅ 신고된 게시글 수 조회
    public int countReportedPosts() { return postDAO.countReportedPosts(); }
    
    public void registerBadUsersFromComments(List<Long> commentIds, String reason) {
        List<String> userIds = postDAO.findWritersByCommentIds(commentIds);  // 댓글 작성자 조회
        if (userIds != null && !userIds.isEmpty()) {
            postDAO.updateUsersToBad(userIds);  // 불량 사용자로 업데이트

            // ✅ 신고 테이블에 사유와 함께 기록 남기기
            for (String userId : userIds) {
                postDAO.insertReport(userId, reason);  // 그냥 String 2개 넘김 (Map 아님!)
            }
        }
    }
} 
