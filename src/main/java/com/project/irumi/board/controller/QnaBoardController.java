package com.project.irumi.board.controller;

import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.board.service.PostService;
import com.project.irumi.user.model.dto.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
public class QnaBoardController {

    @Autowired
    private PostService postService;

    // ✅ QnA 게시판 조회 (페이징만 적용, 정렬/필터 없음)
    @RequestMapping("qnaList.do")
    public String showQnaList(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                               Model model) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> posts = postService.getPostsByTypeWithPaging("qna", offset, pageSize);
        int totalCount = postService.countPostsByType("qna");
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("postList", posts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);

        return "board/qnaList";
    }

    // QnA 글쓰기 화면 (모든 로그인 유저 접근 가능)
    @GetMapping("board/writeQnaPost.do")
    public String showWriteQnaForm() {
        return "board/writeQnaPost";
    }

    // QnA 글 등록 처리
    @PostMapping("board/insertQnaPost.do")
    public String insertQnaPost(@RequestParam("postTitle") String title,
                                 @RequestParam("postContent") String content,
                                 HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:main.do";
        }

        PostDTO post = new PostDTO();
        post.setPostTitle(title);
        post.setPostContent(content);
        post.setPostWriter(loginUser.getUserId());
        post.setPostType("qna");

        postService.insertPost(post);
        return "redirect:qnaList.do";
    }
}
