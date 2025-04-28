package com.project.irumi.board.service;

import java.util.List;

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
    public void insertPost(PostDTO post) {
        postDAO.insertPost(post);
    }

    // ✅ 게시글 등록 후 ID 반환
    public Long insertPostAndReturnId(PostDTO post) {
        return postDAO.insertPostAndReturnId(post);
    }

    // ✅ 게시글 단건 조회
    public PostDTO getPostById(Long postId) {
        return postDAO.getPostById(postId);
    }

    // ✅ 게시글 댓글 전체 조회
    public List<CommentDTO> getCommentsByPostId(Long postId) {
        return postDAO.getCommentsByPostId(postId);
    }

    // ✅ 타입별 게시글 조회 (공지/QnA)
    public List<PostDTO> getPostsByType(String postType) {
        return postDAO.selectByType(postType);
    }

    // ✅ 타입별 게시글 페이징 조회
    public List<PostDTO> getPostsByTypeWithPaging(String postType, int offset, int pageSize) {
        return postDAO.selectByTypeWithPaging(postType, offset, pageSize);
    }

    // ✅ 타입별 게시글 수 조회
    public int countPostsByType(String postType) {
        return postDAO.countPostsByType(postType);
    }

    // ✅ 자유게시판, QnA 필터링 조회
    public List<PostDTO> getFilteredPosts(String postType, String period, String sort, String keyword, int offset, int pageSize) {
        return postDAO.selectFilteredPosts(postType, period, sort, keyword, offset, pageSize);
    }

    // ✅ 자유게시판, QnA 필터링된 게시글 수 조회
    public int countFilteredPosts(String postType, String period, String keyword) {
        return postDAO.countFilteredPosts(postType, period, keyword);
    }

    // ✅ 게시글 조회수 증가
    public void increasePostViewCount(Long postId) {
        postDAO.updatePostViewCount(postId);
    }

    // ✅ 신고된 댓글 조회
    public List<CommentDTO> getReportedComments(int offset, int pageSize) {
        return postDAO.selectReportedComments(offset, pageSize);
    }

    // ✅ 신고된 댓글 수 조회
    public int countReportedComments() {
        return postDAO.countReportedComments();
    }

    // ✅ 불량 이용자 게시판의 체크박스 선택 후 댓글 삭제
    public void deleteCommentsByIds(List<Long> commentIds) {
        postDAO.deleteComments(commentIds);
    }
    
    // 댓글 삭제
    public void deleteComment(Long commentId) {
        postDAO.deleteComment(commentId);
    }

    // ✅ 답변 여부 조회 (특정 게시글에 관리자 댓글 존재 여부)
    public boolean hasAnswer(Long postId) {
        return postDAO.existsAnswerByPostId(postId);
    }

    // ✅ 내 질문 목록 조회
    public List<PostDTO> getMyQnaPosts(String userId, int offset, int pageSize) {
        return postDAO.selectMyOwnPosts(userId, offset, pageSize);
    }

    // ✅ 내 질문 수 조회
    public int countMyQnaPosts(String userId) {
        return postDAO.countMyQnaPosts(userId);
    }

    // ✅ 게시글 수정
    public void updatePost(PostDTO post) {
        postDAO.updatePost(post);
    }

    // ✅ 게시글 삭제
    public void deletePost(Long postId) {
        postDAO.deletePost(postId);
    }

    // ✅ 게시글 추천
    public void recommendPost(Long postId) {
        postDAO.increaseRecommend(postId);
    }

    // ✅ 게시글 신고
    public void reportPost(Long postId) {
        postDAO.increaseReport(postId);
    }

    // ✅ 댓글 추가 (일반 댓글 / 대댓글 모두 지원)
    public void addComment(Long postId, String commentContent, String userId, Long parentId) {
        CommentDTO comment = new CommentDTO();
        comment.setPostId(postId);
        comment.setComContent(commentContent);
        comment.setComWrId(userId);
        comment.setComParentId(parentId); // ✅ 대댓글이면 parentId 세팅, 아니면 null
        postDAO.insertComment(comment);
    }

    // ✅ 댓글 추천
    public void recommendComment(Long commentId) {
        postDAO.increaseCommentRecommend(commentId);
    }

    // ✅ 댓글 신고
    public void reportComment(Long commentId) {
        postDAO.increaseCommentReport(commentId);
    }
}