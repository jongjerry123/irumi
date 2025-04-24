package com.project.irumi.user.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.irumi.user.model.dto.User;
import com.project.irumi.user.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userservice;

    @Autowired
    private BCryptPasswordEncoder bcryptPasswordEncoder;

    @RequestMapping("/")
    public String home() {
        logger.info("home: Redirecting to main page");
        return "common/main";
    }

    @RequestMapping(value = "loginPage.do", method = RequestMethod.GET)
    public String moveToLoginPage() {
        logger.info("moveToLoginPage: Displaying login page");
        return "user/login";
    }

    @RequestMapping(value = "login.do", method = RequestMethod.POST)
    public String loginMethod(User user, HttpSession session, Model model) {
        logger.info("login.do: Received user = {}", user);
        try {
            if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
                logger.warn("login.do: User ID is empty");
                model.addAttribute("message", "아이디를 입력하세요.");
                return "user/login";
            }
            if (user.getUserPwd() == null || user.getUserPwd().trim().isEmpty()) {
                logger.warn("login.do: Password is empty");
                model.addAttribute("message", "비밀번호를 입력하세요.");
                return "user/login";
            }
            User loginUser = userservice.selectUser(user);
            logger.info("login.do: Selected user = {}", loginUser);
            if (loginUser == null) {
                logger.warn("login.do: No user found for userId = {}", user.getUserId());
                model.addAttribute("message", "아이디가 존재하지 않습니다.");
                return "user/login";
            }
            if (bcryptPasswordEncoder.matches(user.getUserPwd(), loginUser.getUserPwd())) {
                logger.info("login.do: Login successful for userId = {}", user.getUserId());
                session.setAttribute("loginUser", loginUser);
                return "common/main";
            } else {
                logger.warn("login.do: Password mismatch for userId = {}", user.getUserId());
                model.addAttribute("message", "비밀번호가 올바르지 않습니다.");
                return "user/login";
            }
        } catch (Exception e) {
            logger.error("login.do: Error during login for userId = {}", user.getUserId(), e);
            model.addAttribute("message", "로그인 중 오류가 발생했습니다.");
            return "user/login";
        }
    }

    @RequestMapping("resister.do")
    public String moveResisterPage() {
        logger.info("moveResisterPage: Displaying registration page");
        return "user/resister";
    }

    @RequestMapping("resisterId.do")
    public String goToNext() {
        logger.info("goToNext: Displaying resisterId page");
        return "user/resisterId";
    }
    @RequestMapping(value = "logout.do", method = RequestMethod.POST)
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 무효화
        return "redirect:/";  // 리다이렉트
    }

    @PostMapping("idchk.do")
    @ResponseBody
    public Map<String, Object> checkId(@RequestParam(name = "userId") String userId) {
        logger.info("idchk.do: Checking userId = {}", userId);
        boolean available = userservice.checkIdAvailability(userId);
        Map<String, Object> response = new HashMap<>();
        response.put("available", available);
        response.put("message", available ? "사용 가능한 아이디입니다." : "이미 사용중인 아이디입니다.");
        return response;
    }

    @PostMapping("registerUser.do")
    @ResponseBody
    public Map<String, Object> register(@RequestBody User user) {
        logger.info("registerUser.do: Received user = {}", user);
        Map<String, Object> response = new HashMap<>();
        try {
            if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
                throw new IllegalArgumentException("아이디가 필요합니다.");
            }
            if (user.getUserEmail() == null || user.getUserEmail().trim().isEmpty()) {
                throw new IllegalArgumentException("이메일이 필요합니다.");
            }
            if (user.getUserPwd() == null || user.getUserPwd().trim().isEmpty()) {
                throw new IllegalArgumentException("비밀번호가 필요합니다.");
            }
            userservice.registerUser(user);
            logger.info("registerUser.do: User registered successfully, userId = {}", user.getUserId());
            response.put("success", true);
            response.put("message", "회원가입이 완료되었습니다.");
        } catch (Exception e) {
            logger.error("registerUser.do: Registration error for userId = {}", user.getUserId(), e);
            response.put("success", false);
            response.put("message", "회원가입 실패: " + e.getMessage());
        }
        return response;
    }
}