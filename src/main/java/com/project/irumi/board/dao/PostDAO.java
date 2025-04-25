package com.project.irumi.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.stereotype.Repository;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;

import jakarta.annotation.Resource;

@Repository
public class PostDAO {

	@Resource(name = "datasource")
	private DataSource dataSource;

	// postType만으로 조회 (공지사항, QnA 공통)
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

	// 자유게시판 - 정렬 및 검색 필터
	public List<PostDTO> selectFreePosts(String period, String sort, String keyword, int offset, int pageSize) {
		List<PostDTO> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT * FROM TB_POST WHERE POST_TYPE = 'free'");

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

	// 자유게시판 총 게시글 수
	public int countFreePosts(String period, String keyword) {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM TB_POST WHERE POST_TYPE = 'free'");
		if (keyword != null && !keyword.isEmpty()) {
			sql.append(" AND POST_TITLE LIKE ?");
		}

		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			if (keyword != null && !keyword.isEmpty()) {
				ps.setString(1, "%" + keyword + "%");
			}

			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	// 자유게시판 - 정렬 및 검색 (페이징 없는 버전)
	public List<PostDTO> selectFreePosts(String period, String sort, String keyword) {
		return selectFreePosts(period, sort, keyword, 0, Integer.MAX_VALUE);
	}

	// 공통 페이징 조회 (QnA, notice)
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

	// postType에 따른 전체 개수 (QnA, notice)
	public int countPostsByType(String postType) {
		String sql = "SELECT COUNT(*) FROM TB_POST WHERE POST_TYPE = ?";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, postType);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return 0;
	}

	// 게시글 등록
	public void insertPost(PostDTO post) {
		String sql = "INSERT INTO TB_POST (POST_WRITER, POST_TYPE, POST_TITLE, POST_CONTENT, POST_TIME, POST_VIEWCOUNT, POST_RECOMMEND) "
				+ "VALUES (?, ?, ?, ?, SYSDATE, 0, 0)";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, post.getPostWriter());
			ps.setString(2, post.getPostType());
			ps.setString(3, post.getPostTitle());
			ps.setString(4, post.getPostContent());

			ps.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public List<PostDTO> selectQnaPostsWithAnswerFlag(String loginUserId, int offset, int pageSize) {
		// TODO: SQL 작성 및 ResultSet 처리
		return new ArrayList<>();
	}

	public int countQnaPostsWithAnswerFlag(String loginUserId) {
		// TODO: SQL 작성 및 카운트 반환
		return 0;
	}

	// QnA - 내 질문만 보기
	public List<PostDTO> selectMyQnaPosts(String loginUserId, int offset, int pageSize) {
		// TODO: SQL 작성 및 ResultSet 처리
		return new ArrayList<>();
	}

	public int countMyQnaPosts(String loginUserId) {
		// TODO: SQL 작성 및 카운트 반환
		return 0;
	}

	// 신고된 게시글 총 개수 조회
	public int countReportedPosts() {
		String sql = "SELECT COUNT(*) FROM TB_POST WHERE POST_REPORT_COUNT > 0";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);

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

	// 신고된 댓글 총 개수 조회
	public int countReportedComments() {
		String sql = "SELECT COUNT(DISTINCT TARGET_ID) FROM TB_COM_REPORT";

		try (Connection conn = dataSource.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1);

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return 0;
	}
}