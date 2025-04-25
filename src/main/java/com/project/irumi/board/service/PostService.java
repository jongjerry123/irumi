package com.project.irumi.board.service;

import com.project.irumi.board.dao.PostDAO;
import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {

    @Resource
    private PostDAO postDAO;

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

    // 게시글 일반 등록 (공지사항 등)
    public void insertPost(PostDTO post) {
        postDAO.insertPost(post);
    }

    // 자유게시판 목록
    public List<PostDTO> getFreePosts(String period, String sort, String keyword, int offset, int pageSize) {
        return postDAO.selectFreePosts(period, sort, keyword, offset, pageSize);
    }

    // 자유게시판 총 수
    public int countFreePosts(String period, String keyword) {
        return postDAO.countFreePosts(period, keyword);
    }

    // 타입별 게시글 조회 (공지/QnA)
    public List<PostDTO> getPostsByType(String postType) {
        return postDAO.selectByType(postType);
    }

    public List<PostDTO> getPostsByTypeWithPaging(String postType, int offset, int pageSize) {
        return postDAO.selectByTypeWithPaging(postType, offset, pageSize);
    }

    public int countPostsByType(String postType) {
        return postDAO.countPostsByType(postType);
    }

    // QnA 관련
    public List<PostDTO> getQnaPostsWithAnswerFlag(String loginUserId, int offset, int pageSize) {
        return postDAO.selectQnaPostsWithAnswerFlag(loginUserId, offset, pageSize);
    }

    public int countQnaPostsWithAnswerFlag(String loginUserId) {
        return postDAO.countQnaPostsWithAnswerFlag(loginUserId);
    }

    public List<PostDTO> getMyQnaPosts(String loginUserId, int offset, int pageSize) {
        return postDAO.selectMyQnaPosts(loginUserId, offset, pageSize);
    }

    public int countMyQnaPosts(String loginUserId) {
        return postDAO.countMyQnaPosts(loginUserId);
    }

    // 신고 댓글
    public List<CommentDTO> getReportedComments(int offset, int pageSize) {
        return postDAO.selectReportedComments(offset, pageSize);
    }

    public int countReportedComments() {
        return postDAO.countReportedComments();
    }
}