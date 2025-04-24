package com.project.irumi.board.controller;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.board.service.PostService;
import com.project.irumi.user.model.dto.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class BoardController {

    @Autowired
    private PostService postService;

    // 자유게시판 with 정렬 + 검색 + 페이징
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

    // 글쓰기 화면
    @RequestMapping(value = "board/writePost.do", method = RequestMethod.GET)
    public String showWritePostForm() {
        return "board/writePost";
    }

    // 글 등록 처리 (자유/질문 공통)
    @RequestMapping(value = "board/insertPost.do", method = RequestMethod.POST)
    public String insertPost(@ModelAttribute PostDTO post, HttpSession session) {
        String writer = (String) session.getAttribute("loginUser");
        post.setPostWriter(writer);

        postService.insertPost(post);

        return "redirect:" + ("qna".equals(post.getPostType()) ? "qnaList.do" : "freeBoard.do");
    }

    // 공지사항 글 등록 처리 (관리자 전용)
    @PostMapping("board/insertNoticePost.do")
    public String insertNoticePost(@RequestParam("postTitle") String title,
                                   @RequestParam("postContent") String content,
                                   HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(String.valueOf(loginUser.getUserLoginType()))) {
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

    // 신고된 게시글 탭
    @GetMapping("reportedPosts.do")
    public String showReportedPosts(HttpSession session, Model model,
                                    @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:loginPage.do";
        }

        model.addAttribute("reportedPostList", List.of());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);

        return "board/reportedPosts";
    }

    // ✅ 신고된 댓글 탭 (최종 버전)
    @GetMapping("reportedComments.do")
    public String showReportedComments(HttpSession session, Model model,
                                       @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:loginPage.do";
        }

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        model.addAttribute("reportedCommentList", postService.getReportedComments(offset, pageSize));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) postService.countReportedComments() / pageSize));

        return "board/reportedComments";
    }

    // 불량 이용자 목록 탭
    @GetMapping("badUserList.do")
    public String showBadUserList(HttpSession session, Model model,
                                  @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:loginPage.do";
        }

        model.addAttribute("badUserList", List.of());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);

        return "board/badUserList";
    }
}