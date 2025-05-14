package com.project.irumi.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;

@Repository
public class PostDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    public void insertPost(PostDTO post) {
        sqlSessionTemplate.insert("boardMapper.insertPost", post);
    }

    public Long insertPostAndReturnId(PostDTO post) {
        sqlSessionTemplate.insert("boardMapper.insertPost", post);
        return sqlSessionTemplate.selectOne("boardMapper.selectLastPostId");
    }

    public PostDTO getPostById(Long postId) {
        return sqlSessionTemplate.selectOne("boardMapper.selectPostById", postId);
    }

    public List<CommentDTO> getCommentsByPostId(Long postId) {
        return sqlSessionTemplate.selectList("boardMapper.selectCommentsByPostIdOrdered", postId);
    }

    public List<PostDTO> selectFilteredPosts(String postType, String period, String sort, String keyword, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("period", period);
        param.put("sort", sort);
        param.put("keyword", keyword);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSessionTemplate.selectList("boardMapper.selectFilteredPosts", param);
    }

    public int countFilteredPosts(String postType, String period, String keyword) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("period", period);
        param.put("keyword", keyword);
        return sqlSessionTemplate.selectOne("boardMapper.countFilteredPosts", param);
    }

    public void updatePostViewCount(Long postId) {
        sqlSessionTemplate.update("boardMapper.updatePostViewCount", postId);
    }

    public List<PostDTO> selectByType(String postType) {
        return sqlSessionTemplate.selectList("boardMapper.selectByType", postType);
    }

    public List<PostDTO> selectByTypeWithPaging(String postType, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSessionTemplate.selectList("boardMapper.selectByTypeWithPaging", param);
    }

    public int countPostsByType(String postType) {
        return sqlSessionTemplate.selectOne("boardMapper.countPostsByType", postType);
    }

    public List<PostDTO> selectMyOwnPosts(String userId, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSessionTemplate.selectList("boardMapper.selectMyQnaPosts", param);
    }

    public int countMyQnaPosts(String userId) {
        return sqlSessionTemplate.selectOne("boardMapper.countMyQnaPosts", userId);
    }

    public boolean existsAnswerByPostId(Long postId) {
        Integer count = sqlSessionTemplate.selectOne("boardMapper.countAnswersByPostId", postId);
        return count != null && count > 0;
    }

    public int countReportedPosts() {
        return sqlSessionTemplate.selectOne("boardMapper.countReportedPosts");
    }

    public List<CommentDTO> selectReportedComments(int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSessionTemplate.selectList("boardMapper.selectReportedComments", param);
    }

    public int countReportedComments() {
        return sqlSessionTemplate.selectOne("boardMapper.countReportedComments");
    }

    public void deleteComment(Long commentId) {
        sqlSessionTemplate.delete("boardMapper.deleteComment", commentId);
    }

    public void updatePost(PostDTO post) {
        sqlSessionTemplate.update("boardMapper.updatePost", post);
    }

    public void deletePost(Long postId) {
        sqlSessionTemplate.delete("boardMapper.deletePost", postId);
    }

    public void increaseRecommend(Long postId) {
        sqlSessionTemplate.update("boardMapper.increaseRecommend", postId);
    }

    public void increaseReport(Long postId) {
        sqlSessionTemplate.update("boardMapper.increaseReport", postId);
    }

    public void insertComment(CommentDTO comment) {
        sqlSessionTemplate.insert("boardMapper.insertComment", comment);
    }

    public void increaseCommentRecommend(Long commentId) {
        sqlSessionTemplate.update("boardMapper.increaseCommentRecommend", commentId);
    }

    public void increaseCommentReport(Long commentId) {
        sqlSessionTemplate.update("boardMapper.increaseCommentReport", commentId);
    }

    public int countPostRecommend(String userId, Long postId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("postId", postId);
        return sqlSessionTemplate.selectOne("boardMapper.countPostRecommend", param);
    }

    public int countCommentRecommend(String userId, Long commentId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("commentId", commentId);
        return sqlSessionTemplate.selectOne("boardMapper.countCommentRecommend", param);
    }

    public void insertPostRecommend(String userId, Long postId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("postId", postId);
        sqlSessionTemplate.insert("boardMapper.insertPostRecommend", param);
    }

    public void insertCommentRecommend(String userId, Long commentId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("commentId", commentId);
        sqlSessionTemplate.insert("boardMapper.insertCommentRecommend", param);
    }

    public int countPostReport(String userId, Long postId) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("postId", postId);
        return sqlSessionTemplate.selectOne("boardMapper.countPostReport", map);
    }

    public int countCommentReport(String userId, Long commentId) {
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("commentId", commentId);
        return sqlSessionTemplate.selectOne("boardMapper.countCommentReport", map);
    }

    public void insertCommentReport(Long commentId, String reason, String reportedBy) {
        Map<String, Object> map = new HashMap<>();
        map.put("commentId", commentId);
        map.put("reason", reason);
        map.put("reportedBy", reportedBy);
        sqlSessionTemplate.insert("boardMapper.insertCommentReport", map);
    }

    public void insertPostReport(Long postId, String reason, String reportedBy) {
        Map<String, Object> map = new HashMap<>();
        map.put("postId", postId);
        map.put("reason", reason);
        map.put("reportedBy", reportedBy);
        sqlSessionTemplate.insert("boardMapper.insertPostReport", map);
    }

    public List<String> findWritersByPostIds(List<Long> postIds) {
        return sqlSessionTemplate.selectList("boardMapper.findWritersByPostIds", postIds);
    }

    public String findWriterByPostId(Long postId) {
        return sqlSessionTemplate.selectOne("boardMapper.findWriterByPostId", postId);
    }

    public void updateUsersToBad(List<String> userIds) {
        sqlSessionTemplate.update("boardMapper.updateUsersToBad", userIds);
    }

    public List<PostDTO> selectReportedPosts(int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSessionTemplate.selectList("boardMapper.selectReportedPosts", param);
    }

    public void deletePostReports(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deletePostReports", postIds);
    }

    public void deleteCommentsByPostIds(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentsByPostIds", postIds);
    }

    public void deletePosts(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deletePosts", postIds);
    }

    public List<Long> getCommentIdsByPostId(Long postId) {
        return sqlSessionTemplate.selectList("boardMapper.selectCommentIdsByPostId", postId);
    }

    public void deleteCommentReportsByPostIds(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentReportsByPostIds", postIds);
    }

    public void deleteCommentReportReportsByPostIds(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentReportReportsByPostIds", postIds);
    }

    public void deleteCommentReportReportsByCommentIds(List<Long> commentIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentReportReportsByCommentIds", commentIds);
    }

    public void deleteCommentRecommendsByPostIds(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentRecommendsByPostIds", postIds);
    }

    public void deletePostRecommends(List<Long> postIds) {
        sqlSessionTemplate.delete("boardMapper.deletePostRecommends", postIds);
    }

    public void deleteCommentRecommendsByCommentIds(List<Long> commentIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentRecommendsByCommentIds", commentIds);
    }

    public void deleteCommentReportsByCommentIds(List<Long> commentIds) {
        sqlSessionTemplate.delete("boardMapper.deleteCommentReportsByCommentIds", commentIds);
    }

    public void deleteComments(List<Long> commentIds) {
        sqlSessionTemplate.delete("boardMapper.deleteComments", commentIds);
    }

    public List<String> findWritersByCommentIds(List<Long> commentIds) {
        return sqlSessionTemplate.selectList("boardMapper.findWritersByCommentIds", commentIds);
    }

    public String findCommentWriterByCommentId(Long commentId) {
        return sqlSessionTemplate.selectOne("boardMapper.findCommentWriterByCommentId", commentId);
    }

    public void updateUserAuthorityToBad(String userId) {
        sqlSessionTemplate.update("boardMapper.updateUserAuthorityToBad", userId);
    }

    public boolean isUserAlreadyBad(String userId) {
        Integer result = sqlSessionTemplate.selectOne("boardMapper.isUserAlreadyBad", userId);
        return result != null && result == 1;
    }

    public void updateUserAuthority(List<String> userIds, int authority) {
        Map<String, Object> param = new HashMap<>();
        param.put("userIds", userIds);
        param.put("authority", authority);
        sqlSessionTemplate.update("boardMapper.updateUserAuthority", param);
    }

    public void updateUserAuthorityByPostId(Long postId) {
        sqlSessionTemplate.update("boardMapper.updateUserAuthorityByPostId", postId);
    }

    public List<Map<String, Object>> selectBadUsers() {
        return sqlSessionTemplate.selectList("boardMapper.selectBadUsers");
    }

    public int countBadUsers() {
        return sqlSessionTemplate.selectOne("boardMapper.countBadUsers");
    }

    public void updatePostReportReason(Long postId, String reportedBy, String reason) {
        Map<String, Object> map = new HashMap<>();
        map.put("postId", postId);
        map.put("reportedBy", reportedBy);
        map.put("reason", reason);
        sqlSessionTemplate.update("boardMapper.updatePostReportReason", map);
    }

    public void updateCommentReportReason(Long commentId, String reportedBy, String reason) {
        Map<String, Object> map = new HashMap<>();
        map.put("commentId", commentId);
        map.put("reportedBy", reportedBy);
        map.put("reason", reason);
        sqlSessionTemplate.update("boardMapper.updateCommentReportReason", map);
    }

    public int getUserAuthority(String userId) {
        return sqlSessionTemplate.selectOne("boardMapper.selectUserAuthority", userId);
    }
}