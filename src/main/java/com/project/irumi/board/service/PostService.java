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

    public List<PostDTO> getPostsByType(String postType) {
        return postDAO.selectByType(postType);
    }
}