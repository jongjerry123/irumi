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

    // 기존 메서드
    public List<PostDTO> getPostsByType(String postType) {
        return postDAO.selectByType(postType);
    }

    // 자유게시판 - 정렬 및 키워드
    public List<PostDTO> getFreePosts(String period, String sort, String keyword) {
        return postDAO.selectFreePosts(period, sort, keyword);
    }

    public List<PostDTO> getFreePosts(String period, String sort, String keyword, int offset, int pageSize) {
        return postDAO.selectFreePosts(period, sort, keyword, offset, pageSize);
    }

    public int countFreePosts(String period, String keyword) {
        return postDAO.countFreePosts(period, keyword);
    }

    public void insertPost(PostDTO post) {
        postDAO.insertPost(post);
    }

    // QnA, 공지사항 - postType 기반 페이징 조회
    public List<PostDTO> getPostsByTypeWithPaging(String postType, int offset, int pageSize) {
        return postDAO.selectByTypeWithPaging(postType, offset, pageSize);
    }

    public int countPostsByType(String postType) {
        return postDAO.countPostsByType(postType);
    }

    // QnA - 답변 여부 포함된 게시물 조회
    public List<PostDTO> getQnaPostsWithAnswerFlag(String loginUserId, int offset, int pageSize) {
        return postDAO.selectQnaPostsWithAnswerFlag(loginUserId, offset, pageSize);
    }

    public int countQnaPostsWithAnswerFlag(String loginUserId) {
        return postDAO.countQnaPostsWithAnswerFlag(loginUserId);
    }

    // QnA - 내 질문만 보기
    public List<PostDTO> getMyQnaPosts(String loginUserId, int offset, int pageSize) {
        return postDAO.selectMyQnaPosts(loginUserId, offset, pageSize);
    }

    public int countMyQnaPosts(String loginUserId) {
        return postDAO.countMyQnaPosts(loginUserId);
    }

 // 신고된 댓글 목록 조회
    public List<CommentDTO> getReportedComments(int offset, int pageSize) {
        return postDAO.selectReportedComments(offset, pageSize);
    }

    // 신고된 댓글 개수 조회
    public int countReportedComments() {
        return postDAO.countReportedComments();
    }
}