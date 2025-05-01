package com.project.irumi.board.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.irumi.board.dto.CommentDTO;
import com.project.irumi.board.dto.PostDTO;
import com.project.irumi.board.service.PostService;
import com.project.irumi.user.model.dto.User;

import jakarta.servlet.http.HttpServletResponse;
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
    public String showNoticeList(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                                 Model model) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<PostDTO> notices = postService.getPostsByTypeWithPaging("공지", offset, pageSize);
        int totalCount = postService.countPostsByType("공지");
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("postList", notices);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        return "board/noticeList";
    }

    // QnA 목록
    @GetMapping("/qnaList.do")
    public String showQnaList(@RequestParam(value = "period", required = false, defaultValue = "전체") String period,
                              @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
                              @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                              @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                              Model model, HttpSession session) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        List<PostDTO> posts = postService.getFilteredPosts("질문", period, sort, keyword, offset, pageSize);

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

        return switch (post.getPostType()) {
            case "질문" -> "redirect:/qnaList.do";
            case "공지" -> "redirect:/noticeList.do";
            default -> "redirect:/freeBoard.do";
        };
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

    // 게시글 추천 (중복 방지)
    @PostMapping("/recommendPost.do")
    public String recommendPost(@RequestParam("postId") Long postId, HttpSession session, HttpServletResponse response) throws IOException {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginPage.do";

        String userId = loginUser.getUserId();
        if (postService.hasAlreadyRecommendedPost(userId, postId)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 추천하셨습니다.'); history.back();</script>");
            return null;
        }
        postService.recommendPost(postId, userId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 게시글 신고 (중복 방지)
    @PostMapping("/reportPost.do")
    public String reportPost(@RequestParam("postId") Long postId, HttpSession session, HttpServletResponse response) throws IOException {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginPage.do";

        String userId = loginUser.getUserId();
        if (postService.hasAlreadyReportedPost(userId, postId)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 신고하셨습니다.'); history.back();</script>");
            return null;
        }
        postService.reportPost(postId, userId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 댓글 등록
    @PostMapping("/addComment.do")
    public String addComment(@RequestParam("postId") Long postId,
                             @RequestParam("commentContent") String commentContent,
                             @RequestParam(value = "parentId", required = false) Long parentId,
                             HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginPage.do";

        postService.addComment(postId, commentContent, loginUser.getUserId(), parentId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 댓글 추천 (중복 방지)
    @PostMapping("/recommendComment.do")
    public String recommendComment(@RequestParam("commentId") Long commentId,
                                   @RequestParam("postId") Long postId,
                                   HttpSession session, HttpServletResponse response) throws IOException {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginPage.do";

        String userId = loginUser.getUserId();
        if (postService.hasAlreadyRecommendedComment(userId, commentId)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 추천하셨습니다.'); history.back();</script>");
            return null;
        }
        postService.recommendComment(commentId, userId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 댓글 신고 (중복 방지)
    @PostMapping("/reportComment.do")
    public String reportComment(@RequestParam("commentId") Long commentId,
                                @RequestParam("postId") Long postId,
                                HttpSession session, HttpServletResponse response) throws IOException {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/loginPage.do";

        String userId = loginUser.getUserId();
        if (postService.hasAlreadyReportedComment(userId, commentId)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 신고하셨습니다.'); history.back();</script>");
            return null;
        }
        postService.reportComment(commentId, userId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 댓글 삭제
    @PostMapping("/deleteComment.do")
    public String deleteComment(@RequestParam("commentId") Long commentId,
                                 @RequestParam("postId") Long postId) {
        postService.deleteComment(commentId);
        return "redirect:/postDetail.do?postId=" + postId;
    }

    // 게시글 수정
    @PostMapping("/updatePost.do")
    public String updatePost(PostDTO postDTO) {
        postService.updatePost(postDTO);
        return "redirect:postDetail.do?postId=" + postDTO.getPostId();
    }

    // 게시글 수정 화면
    @GetMapping("/editPost.do")
    public String editPostForm(@RequestParam("postId") Long postId, Model model) {
        PostDTO post = postService.getPostById(postId);
        model.addAttribute("post", post);
        return "board/editPost";
    }

    // 게시글 삭제
    @PostMapping("/deletePost.do")
    public String deletePost(@RequestParam("postId") Long postId) {
        postService.deletePost(postId);
        return "redirect:/freeBoard.do";
    }
    
    // ✅ 신고된 게시글 목록
    @GetMapping("/reportedPosts.do")
    public String showReportedPosts(HttpSession session, Model model,
                                    @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
            return "redirect:/loginPage.do";
        }

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        model.addAttribute("reportedPostList", postService.getReportedPosts(offset, pageSize));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) postService.countReportedPosts() / pageSize));
        return "board/reportedPosts";
    }
    
 // ✅ 게시글 다중 삭제 + 신고기록 삭제
    @PostMapping("/deleteSelectedPosts.do")
    public String deleteSelectedPosts(@RequestParam("selectedPosts") List<Long> postIds) {
        postService.deletePostsAndReports(postIds); // 🔄 게시글과 연결된 신고 기록 먼저 삭제 후 게시글 삭제
        return "redirect:/reportedPosts.do";
    }

    // ✅ 신고된 댓글 목록
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

    // ✅ 신고 댓글 삭제
    @PostMapping("/deleteSelectedComments.do")
    public String deleteSelectedComments(@RequestParam("selectedComments") List<Long> commentIds) {
        postService.deleteReportedCommentsByIds(commentIds);
        return "redirect:/reportedComments.do";
    }
    
    // ✅ 불량 이용자 목록
    @GetMapping("/badUserList.do")
    public String showBadUserList(Model model) {
        List<Map<String, Object>> badUserList = postService.getBadUsers();
        model.addAttribute("badUserList", badUserList);
        return "board/badUserList";
    }

    // 불량 이용자 등록
    @PostMapping("/registerBadUsers.do")
    public String registerBadUsers(@RequestParam("selectedPosts") List<Long> postIds,
                                   @RequestParam("reason") String reason) {
        postService.registerBadUsersFromPosts(postIds, reason);
        return "redirect:/reportedPosts.do";
    }
     
 // ✅ 댓글 작성자 불량 등록
    @PostMapping("/registerBadUsersFromComments.do")
    public String registerBadUsersFromComments(@RequestParam List<Long> selectedComments,
                                               @RequestParam String reason) {
        postService.registerBadUsersFromComments(selectedComments, reason);
        return "redirect:reportedComments.do";
    }
    
    @PostMapping("/restoreBadUsers.do")
    public String restoreBadUsers(@RequestParam("selectedUsers") List<String> userIds) {
        postService.updateUserAuthority(userIds, 1); // 일반 유저로 변경
        return "redirect:badUserList.do";
    }

    @PostMapping("/withdrawBadUsers.do")
    public String withdrawBadUsers(@RequestParam("selectedUsers") List<String> userIds) {
        postService.updateUserAuthority(userIds, 4); // 탈퇴 유저로 변경
        return "redirect:badUserList.do";
    }
    
}

