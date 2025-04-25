package com.project.irumi.board.dao;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PostDAO {

    @Resource(name = "datasource")
    private DataSource dataSource;

    public Long insertPostAndReturnId(PostDTO post) {
        String sql = "INSERT INTO TB_POST (POST_ID, POST_WRITER, POST_TYPE, POST_TITLE, POST_CONTENT, POST_TIME, POST_VIEWCOUNT, POST_RECOMMEND) " +
                     "VALUES (SEQ_TB_POST_POST_ID.NEXTVAL, ?, ?, ?, ?, SYSDATE, 0, 0)";
        String getIdSql = "SELECT SEQ_TB_POST_POST_ID.CURRVAL FROM DUAL";
        Long generatedId = null;

        try (Connection conn = dataSource.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, post.getPostWriter());
                ps.setString(2, post.getPostType());
                ps.setString(3, post.getPostTitle());
                ps.setString(4, post.getPostContent());
                ps.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(getIdSql)) {
                ResultSet rs = ps2.executeQuery();
                if (rs.next()) {
                    generatedId = rs.getLong(1);
                }
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedId;
    }

    public PostDTO getPostById(Long postId) {
        String sql = "SELECT * FROM TB_POST WHERE POST_ID = ?";
        PostDTO post = null;

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, postId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                post = new PostDTO();
                post.setPostId(rs.getLong("POST_ID"));
                post.setPostWriter(rs.getString("POST_WRITER"));
                post.setPostType(rs.getString("POST_TYPE"));
                post.setPostTitle(rs.getString("POST_TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setPostTime(rs.getTimestamp("POST_TIME").toLocalDateTime());
                post.setPostViewCount(rs.getInt("POST_VIEWCOUNT"));
                post.setPostRecommend(rs.getInt("POST_RECOMMEND"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return post;
    }

    public List<CommentDTO> getCommentsByPostId(Long postId) {
        List<CommentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM TB_COMMENT WHERE POST_ID = ? ORDER BY COM_TIME ASC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, postId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CommentDTO dto = new CommentDTO();
                dto.setComId(rs.getLong("COM_ID"));
                dto.setComWrId(rs.getString("COM_WR_ID"));
                dto.setPostId(rs.getLong("POST_ID"));
                dto.setComParentId(rs.getLong("COM_PARENT_ID"));
                dto.setComContent(rs.getString("COM_CONTENT"));
                dto.setComTime(rs.getTimestamp("COM_TIME").toLocalDateTime());
                dto.setComRecommend(rs.getInt("COM_RECOMMEND"));
                dto.setComReportCount(rs.getInt("COM_REPORT_COUNT"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertPost(PostDTO post) {
        String sql = "INSERT INTO TB_POST (POST_WRITER, POST_TYPE, POST_TITLE, POST_CONTENT, POST_TIME, POST_VIEWCOUNT, POST_RECOMMEND) " +
                     "VALUES (?, ?, ?, ?, SYSDATE, 0, 0)";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, post.getPostWriter());
            ps.setString(2, post.getPostType());
            ps.setString(3, post.getPostTitle());
            ps.setString(4, post.getPostContent());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<PostDTO> selectFreePosts(String period, String sort, String keyword, int offset, int pageSize) {
        List<PostDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM TB_POST WHERE POST_TYPE = '일반'");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND POST_TITLE LIKE ?");
        }

        switch (sort) {
            case "hit" -> sql.append(" ORDER BY POST_VIEWCOUNT DESC");
            case "like" -> sql.append(" ORDER BY POST_RECOMMEND DESC");
            default -> sql.append(" ORDER BY POST_TIME DESC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getLong("POST_ID"));
                post.setPostWriter(rs.getString("POST_WRITER"));
                post.setPostType(rs.getString("POST_TYPE"));
                post.setPostTitle(rs.getString("POST_TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setPostTime(rs.getTimestamp("POST_TIME").toLocalDateTime());
                post.setPostViewCount(rs.getInt("POST_VIEWCOUNT"));
                post.setPostRecommend(rs.getInt("POST_RECOMMEND"));
                list.add(post);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countFreePosts(String period, String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM TB_POST WHERE POST_TYPE = '일반'");
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND POST_TITLE LIKE ?");
        }

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<PostDTO> selectByType(String postType) {
        List<PostDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM TB_POST WHERE POST_TYPE = ? ORDER BY POST_TIME DESC";

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, postType);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getLong("POST_ID"));
                post.setPostWriter(rs.getString("POST_WRITER"));
                post.setPostType(rs.getString("POST_TYPE"));
                post.setPostTitle(rs.getString("POST_TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setPostTime(rs.getTimestamp("POST_TIME").toLocalDateTime());
                post.setPostViewCount(rs.getInt("POST_VIEWCOUNT"));
                post.setPostRecommend(rs.getInt("POST_RECOMMEND"));
                list.add(post);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<PostDTO> selectByTypeWithPaging(String postType, int offset, int pageSize) {
        List<PostDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM TB_POST WHERE POST_TYPE = ? ORDER BY POST_TIME DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, postType);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PostDTO post = new PostDTO();
                post.setPostId(rs.getLong("POST_ID"));
                post.setPostWriter(rs.getString("POST_WRITER"));
                post.setPostType(rs.getString("POST_TYPE"));
                post.setPostTitle(rs.getString("POST_TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setPostTime(rs.getTimestamp("POST_TIME").toLocalDateTime());
                post.setPostViewCount(rs.getInt("POST_VIEWCOUNT"));
                post.setPostRecommend(rs.getInt("POST_RECOMMEND"));
                list.add(post);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countPostsByType(String postType) {
        String sql = "SELECT COUNT(*) FROM TB_POST WHERE POST_TYPE = ?";

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, postType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<PostDTO> selectQnaPostsWithAnswerFlag(String loginUserId, int offset, int pageSize) {
        return new ArrayList<>();
    }

    public int countQnaPostsWithAnswerFlag(String loginUserId) {
        return 0;
    }

    public List<PostDTO> selectMyQnaPosts(String loginUserId, int offset, int pageSize) {
        return new ArrayList<>();
    }

    public int countMyQnaPosts(String loginUserId) {
        return 0;
    }

    public int countReportedPosts() {
        String sql = "SELECT COUNT(*) FROM TB_POST WHERE POST_REPORT_COUNT > 0";

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<CommentDTO> selectReportedComments(int offset, int pageSize) {
        List<CommentDTO> list = new ArrayList<>();
        String sql = """
            SELECT C.COM_ID, C.COM_WR_ID, C.POST_ID, C.COM_CONTENT, COUNT(R.REPORT_ID) AS REPORT_COUNT
            FROM TB_COMMENT C
            JOIN TB_COM_REPORT R ON C.COM_ID = R.TARGET_ID
            WHERE C.COM_REPORT_COUNT > 0
            GROUP BY C.COM_ID, C.COM_WR_ID, C.POST_ID, C.COM_CONTENT
            ORDER BY REPORT_COUNT DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CommentDTO dto = new CommentDTO();
                dto.setComId(rs.getLong("COM_ID"));
                dto.setComWrId(rs.getString("COM_WR_ID"));
                dto.setPostId(rs.getLong("POST_ID"));
                dto.setComContent(rs.getString("COM_CONTENT"));
                dto.setComReportCount(rs.getInt("REPORT_COUNT"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countReportedComments() {
        String sql = "SELECT COUNT(DISTINCT TARGET_ID) FROM TB_COM_REPORT";

        try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}