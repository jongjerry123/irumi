package com.project.irumi.board.dao;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import jakarta.annotation.Resource;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class PostDAO {

    @Resource(name = "sqlSessionTemplate") // ✔ sqlSessionTemplate로 변경
    private SqlSession sqlSession;

    public Long insertPostAndReturnId(PostDTO post) {
        sqlSession.insert("boardMapper.insertPost", post);
        return sqlSession.selectOne("boardMapper.selectLastPostId");
    }

    public void insertPost(PostDTO post) {
        sqlSession.insert("boardMapper.insertPost", post);
    }

    public PostDTO getPostById(Long postId) {
        return sqlSession.selectOne("boardMapper.selectPostById", postId);
    }

    public List<CommentDTO> getCommentsByPostId(Long postId) {
        return sqlSession.selectList("boardMapper.selectCommentsByPostId", postId);
    }

    public List<PostDTO> selectFreePosts(String period, String sort, String keyword, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        param.put("sort", sort);
        return sqlSession.selectList("boardMapper.selectFreePosts", param);
    }

    public int countFreePosts(String period, String keyword) {
        return sqlSession.selectOne("boardMapper.countFreePosts", keyword);
    }

    public List<PostDTO> selectByType(String postType) {
        return sqlSession.selectList("boardMapper.selectByType", postType);
    }

    public List<PostDTO> selectByTypeWithPaging(String postType, int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("postType", postType);
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectByTypeWithPaging", param);
    }

    public int countPostsByType(String postType) {
        return sqlSession.selectOne("boardMapper.countPostsByType", postType);
    }

    public List<PostDTO> selectQnaPostsWithAnswerFlag(String loginUserId, int offset, int pageSize) {
        return sqlSession.selectList("boardMapper.selectQnaPostsWithAnswerFlag", Map.of(
            "loginUserId", loginUserId,
            "offset", offset,
            "pageSize", pageSize
        ));
    }

    public int countQnaPostsWithAnswerFlag(String loginUserId) {
        return sqlSession.selectOne("boardMapper.countQnaPostsWithAnswerFlag", loginUserId);
    }

    public List<PostDTO> selectMyQnaPosts(String loginUserId, int offset, int pageSize) {
        return sqlSession.selectList("boardMapper.selectMyQnaPosts", Map.of(
            "loginUserId", loginUserId,
            "offset", offset,
            "pageSize", pageSize
        ));
    }

    public int countMyQnaPosts(String loginUserId) {
        return sqlSession.selectOne("boardMapper.countMyQnaPosts", loginUserId);
    }

    public int countReportedPosts() {
        return sqlSession.selectOne("boardMapper.countReportedPosts");
    }

    public List<CommentDTO> selectReportedComments(int offset, int pageSize) {
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("pageSize", pageSize);
        return sqlSession.selectList("boardMapper.selectReportedComments", param);
    }

    public int countReportedComments() {
        return sqlSession.selectOne("boardMapper.countReportedComments");
    }
}