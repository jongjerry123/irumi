package com.project.irumi.board.controller;

import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.board.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class BoardController {

    @Autowired
    private PostService postService;

    @RequestMapping("/viewPost.do")
    public String viewPost(@RequestParam(name = "type", defaultValue = "qna") String type, Model model) {
        List<PostDTO> posts = postService.getPostsByType(type);
        model.addAttribute("postList", posts);
        model.addAttribute("selectedType", type);
        return "board/postlist";
    }
}