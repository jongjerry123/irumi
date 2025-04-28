package com.project.irumi.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.board.service.PostService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {

    @Autowired
    private PostService postService;

    // 자유게시판
    @GetMapping("/freeBoard.do")
    public String showFreeBoard(@RequestParam(value = "period", required = false, defaultValue = "전체") String period,
                                @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
                                @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                                @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                Model model) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> posts = postService.getFilteredPosts("일반", period, sort, keyword, offset, pageSize);
        int totalCount = postService.countFilteredPosts("일반", period, keyword);
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
    @GetMapping("/noticeList.do")
    public String showNoticeList(Model model) {
        List<PostDTO> notices = postService.getPostsByType("공지");
        model.addAttribute("postList", notices);
        return "board/noticeList";
    }

    // Q&A 목록
    @GetMapping("/qnaList.do")
    public String showQnaList(@RequestParam(value = "period", required = false, defaultValue = "전체") String period,
                              @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
                              @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                              @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                              Model model, HttpSession session) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> posts = postService.getFilteredPosts("질문", period, sort, keyword, offset, pageSize);

        // 답변 유무 세팅
        for (PostDTO post : posts) {
            boolean hasAnswer = postService.hasAnswer(post.getPostId());
            post.setHasAnswer(hasAnswer);
        }

        int totalCount = postService.countFilteredPosts("질문", period, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("postList", posts);
        model.addAttribute("selectedPeriod", period);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("isMyQna", false);

        return "board/qnaList";
    }

    // 내 질문만 보기
    @GetMapping("/myQna.do")
    public String showMyQnaPosts(HttpSession session, Model model,
                                 @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> posts = postService.getMyQnaPosts(loginUser.getUserId(), offset, pageSize);
        int totalCount = postService.countMyQnaPosts(loginUser.getUserId());
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("postList", posts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("isMyQna", true);

        return "board/qnaList";
    }

    // 글쓰기 화면
    @GetMapping("/writePost.do")
    public String showWritePostForm(@RequestParam("type") String type, Model model) {
        model.addAttribute("postType", type);
        return "board/writePost";
    }

    // 글 등록
    @PostMapping("/insertPost.do")
    public String insertPost(@ModelAttribute PostDTO post, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }

        post.setPostWriter(loginUser.getUserId());
        postService.insertPost(post);

        String redirect;
        switch (post.getPostType()) {
            case "질문" -> redirect = "/qnaList.do";
            case "공지" -> redirect = "/noticeList.do";
            default -> redirect = "/freeBoard.do";
        }
        return "redirect:" + redirect;
    }

    // 게시글 상세보기
    @GetMapping("/postDetail.do")
    public String showPostDetail(@RequestParam("postId") Long postId, Model model) {
        postService.increasePostViewCount(postId);
        PostDTO post = postService.getPostById(postId);
        List<CommentDTO> commentList = postService.getCommentsByPostId(postId);

        model.addAttribute("post", post);
        model.addAttribute("commentList", commentList);
        return "board/postDetailView";
    }

    // 공지사항 상세보기
    @GetMapping("/detailPost.do")
    public String showDetailPostFromNotice(@RequestParam("id") Long postId, Model model) {
        PostDTO post = postService.getPostById(postId);
        model.addAttribute("post", post);
        return "board/postDetailView";
    }

    // 게시글 수정 화면 이동
    @GetMapping("/editPost.do")
    public String editPostForm(@RequestParam("postId") Long postId, Model model) {
        PostDTO post = postService.getPostById(postId);
        model.addAttribute("post", post);
        return "board/editPost";
    }

    // 게시글 수정 처리
    @PostMapping("/updatePost.do")
    public String updatePost(@ModelAttribute PostDTO post) {
        postService.updatePost(post);
        return "redirect:/postDetail.do?postId=" + post.getPostId();
    }

    // 게시글 삭제
    @PostMapping("/deletePost.do")
    public String deletePost(@RequestParam("postId") Long postId) {
        postService.deletePost(postId);
        return "redirect:/freeBoard.do";
    }

    // 게시글 추천
    @PostMapping("/recommendPost.do")
    public String recommendPost(@RequestParam("postId") Long postId) {
        postService.recommendPost(postId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 게시글 신고
    @PostMapping("/reportPost.do")
    public String reportPost(@RequestParam("postId") Long postId) {
        postService.reportPost(postId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 댓글 등록
    @PostMapping("/addComment.do")
    public String addComment(@RequestParam("postId") Long postId,
                              @RequestParam("commentContent") String commentContent,
                              HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/loginPage.do";
        }

        postService.addComment(postId, commentContent, loginUser.getUserId());
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 신고된 게시글 목록
    @GetMapping("/reportedPosts.do")
    public String showReportedPosts(HttpSession session, Model model,
                                    @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:/loginPage.do";
        }
        model.addAttribute("reportedPostList", List.of());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);
        return "board/reportedPosts";
    }

    // 신고된 댓글 목록
    @GetMapping("/reportedComments.do")
    public String showReportedComments(HttpSession session, Model model,
                                       @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:/loginPage.do";
        }

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        model.addAttribute("reportedCommentList", postService.getReportedComments(offset, pageSize));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) postService.countReportedComments() / pageSize));
        return "board/reportedComments";
    }

    // 불량 이용자 목록
    @GetMapping("/badUserList.do")
    public String showBadUserList(HttpSession session, Model model,
                                  @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:/loginPage.do";
        }
        model.addAttribute("badUserList", List.of());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 1);
        return "board/badUserList";
    }

    // 신고 댓글 삭제
    @PostMapping("/deleteSelectedComments.do")
    @ResponseBody
    public String deleteSelectedComments(@RequestBody List<Long> commentIds) {
        postService.deleteCommentsByIds(commentIds);
        return "success";
    }
}