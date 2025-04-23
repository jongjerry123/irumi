package com.project.irumi.board.service;

import com.project.irumi.board.dao.PostDAO;
import com.project.irumi.board.dto.PostDTO;
import org.springframework.stereotype.Service;
import jakarta.annotation.Resource;
import java.util.List;

@Service
public class PostService {

    @Resource
    private PostDAO postDAO;

    // 
    public List<PostDTO> getPostsByType(String postType) {
        return postDAO.selectByType(postType);
    }

    //  새로 추가한 메서드 - 지금 컨트롤러에서 필요한 기능!
    public List<PostDTO> getPosts(String period, String sort, String keyword) {
        // 지금은 조건 안 걸고 전체 게시글 반환 (나중에 확장 가능)
        return postDAO.selectByType("free"); // 자유게시판만 보여주도록 고정
    }
}