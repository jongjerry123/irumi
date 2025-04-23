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

    // 자유게시판 데이터 처리용
    @RequestMapping("freeBoard.do")
    public String showFreeBoard(
            @RequestParam(value = "period", required = false, defaultValue = "전체") String period,
            @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model) {

        List<PostDTO> posts = postService.getPosts(period, sort, keyword);

        model.addAttribute("postList", posts);
        model.addAttribute("selectedPeriod", period);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("keyword", keyword);

        return "board/boardListView";  // boardListView.jsp
    }

    // QnA 게시판 이동용 (뷰만 보여줌)
    @RequestMapping("qnaList.do")
    public String forwardQnaBoard() {
        return "board/qnaList";
    }

    // 공지사항 게시판 이동용 (뷰만 보여줌)
    @RequestMapping("noticeList.do")
    public String forwardNoticeBoard() {
        return "board/noticeList";
    }
}