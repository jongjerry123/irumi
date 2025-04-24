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
public class BoardController {

    @Autowired
    private PostService postService;

    // ✅ 자유게시판 with 정렬 + 검색 + 페이징
    @RequestMapping("freeBoard.do")
    public String showFreeBoard(
            @RequestParam(value = "period", required = false, defaultValue = "전체") String period,
            @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            Model model) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> posts = postService.getFreePosts(period, sort, keyword, offset, pageSize);
        int totalCount = postService.countFreePosts(period, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("postList", posts);
        model.addAttribute("selectedPeriod", period);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);

        return "board/boardListView";
    }

    // 공지사항
    @RequestMapping("noticeList.do")
    public String showNoticeList(Model model) {
        List<PostDTO> notices = postService.getPostsByType("notice");
        model.addAttribute("postList", notices);
        return "board/noticeList";
    }

    // 자유게시판 글쓰기 화면
    @RequestMapping(value = "board/writePost.do", method = RequestMethod.GET)
    public String showWritePostForm() {
        return "board/writePost";
    }

    // 자유게시판 글 등록 처리
    @RequestMapping(value = "board/insertPost.do", method = RequestMethod.POST)
    public String insertPost(@ModelAttribute PostDTO post, HttpSession session) {
        String writer = (String) session.getAttribute("loginUser");
        post.setPostWriter(writer);
        post.setPostType("free");
        postService.insertPost(post);
        return "redirect:freeBoard.do";
    }

    // 공지사항 글 등록 처리 (관리자 전용)
    @PostMapping("board/insertNoticePost.do")
    public String insertNoticePost(@RequestParam("postTitle") String title,
                                   @RequestParam("postContent") String content,
                                   HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"admin".equals(loginUser.getUserLoginType())) {
            return "redirect:main.do";
        }

        PostDTO post = new PostDTO();
        post.setPostTitle(title);
        post.setPostContent(content);
        post.setPostWriter(loginUser.getUserId());
        post.setPostType("notice");

        postService.insertPost(post);
        return "redirect:noticeList.do";
    }

}
