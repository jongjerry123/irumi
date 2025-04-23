package com.project.irumi.board.dao;

import com.project.irumi.board.dto.PostDTO;
import org.springframework.stereotype.Repository;

import jakarta.annotation.Resource;
import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PostDAO {

    @Resource(name = "datasource")
    private DataSource dataSource;

    public List<PostDTO> selectByType(String postType) {
        List<PostDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM TB_POST WHERE POST_TYPE = ? ORDER BY POST_TIME DESC";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
                list.add(post);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}