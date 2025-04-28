package com.project.irumi.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;

import jakarta.annotation.Resource;

@Repository
public class PostDAO {

    @Resource(name = "sqlSessionTemplate")
    private SqlSession sqlSession;

    // ✅ 게시글 등록
    public void insertPost(PostDTO post) {
        sqlSession.insert("boardMapper.insertPost", post);
    }

    // ✅ 게시글 등록 후 ID 반환
    public Long insertPostAndReturnId(PostDTO post) {
        sqlSession.insert("boardMapper.insertPost", post);
        return sqlSession.selectOne("boardMapper.selectLastPostId");
    }

    // ✅ 게시글 단건 조회
    public PostDTO getPostById(Long postId) {
        return sqlSession.selectOne("boardMapper.selectPostById", postId);
    }

    // ✅ 게시글 댓글 전체 조회
    public List<CommentDTO> getCommentsByPostId(Long postId) {
        return sqlSession.selectList("boardMapper.selectCommentsByPostId", postId);
    }

    // ✅ 자유게시판/질문게시판 필터+정렬+검색 조회
    public List<PostDTO> selectFilteredPosts(String postType, String period, String sort, String keyword, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("period", period);
        param.put("sort", sort);
        param.put("keyword", keyword);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectFilteredPosts", param);
    }

    // ✅ 자유게시판/질문게시판 필터+검색된 게시글 수
    public int countFilteredPosts(String postType, String period, String keyword) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("period", period);
        param.put("keyword", keyword);
        return sqlSession.selectOne("boardMapper.countFilteredPosts", param);
    }

    // ✅ 게시글 조회수 증가
    public void updatePostViewCount(Long postId) {
        sqlSession.update("boardMapper.updatePostViewCount", postId);
    }

    // ✅ 타입별 게시글 조회 (공지/Q&A)
    public List<PostDTO> selectByType(String postType) {
        return sqlSession.selectList("boardMapper.selectByType", postType);
    }

    // ✅ 타입별 게시글 페이징 조회
    public List<PostDTO> selectByTypeWithPaging(String postType, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectByTypeWithPaging", param);
    }

    // ✅ 타입별 게시글 수 조회
    public int countPostsByType(String postType) {
        return sqlSession.selectOne("boardMapper.countPostsByType", postType);
    }

    // ✅ 내 QnA 질문 목록 조회
    public List<PostDTO> selectMyOwnPosts(String userId, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectMyQnaPosts", param);
    }

    // ✅ 내 QnA 질문 수 조회
    public int countMyQnaPosts(String userId) {
        return sqlSession.selectOne("boardMapper.countMyQnaPosts", userId);
    }

    // ✅ QnA 답변 여부 조회 (관리자 댓글 있는지)
    public boolean existsAnswerByPostId(Long postId) {
        Integer count = sqlSession.selectOne("boardMapper.countAnswersByPostId", postId);
        return count != null && count > 0;
    }

    // ✅ 신고된 게시글 수
    public int countReportedPosts() {
        return sqlSession.selectOne("boardMapper.countReportedPosts");
    }

    // ✅ 신고된 댓글 목록
    public List<CommentDTO> selectReportedComments(int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectReportedComments", param);
    }

    // ✅ 신고된 댓글 수
    public int countReportedComments() {
        return sqlSession.selectOne("boardMapper.countReportedComments");
    }

    // ✅ 댓글 삭제
    public void deleteComments(List<Long> commentIds) {
        sqlSession.delete("boardMapper.deleteSelectedComments", commentIds);
    }

    // ✅ 게시글 수정
    public void updatePost(PostDTO post) {
        sqlSession.update("boardMapper.updatePost", post);
    }

    // ✅ 게시글 삭제
    public void deletePost(Long postId) {
        sqlSession.delete("boardMapper.deletePost", postId);
    }

    // ✅ 게시글 추천 수 증가
    public void increaseRecommend(Long postId) {
        sqlSession.update("boardMapper.increaseRecommend", postId);
    }

    // ✅ 게시글 신고 수 증가
    public void increaseReport(Long postId) {
        sqlSession.update("boardMapper.increaseReport", postId);
    }

    // ✅ 댓글 등록
    public void insertComment(CommentDTO comment) {
        sqlSession.insert("boardMapper.insertComment", comment);
    }

    // ✅ 댓글 추천 수 증가
    public void increaseCommentRecommend(Long commentId) {
        sqlSession.update("boardMapper.increaseCommentRecommend", commentId);
    }

    // ✅ 댓글 신고 수 증가
    public void increaseCommentReport(Long commentId) {
        sqlSession.update("boardMapper.increaseCommentReport", commentId);
    }
}