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
import org.springframework.web.bind.support.SessionStatus;

import com.project.irumi.user.model.dto.User;
import com.project.irumi.user.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);

	@Autowired
	private UserService userservice;
	
	// 회원가입 페이지 내보내기용

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	
	@RequestMapping("/")
    public String home() {
        return "common/main";
    }
	
	@RequestMapping(value="login.do", method=RequestMethod.POST)
	public String loginMethod(User user, HttpSession session, SessionStatus status, Model model) {
		logger.info("login.do : " + user);
		
		
		User loginUser = userservice.selectUser(user);
		
		//if (loginUser != null && this.bcryptPasswordEncoder.matches(user.getUserPwd(), loginUser.getUserPwd())) {
		if (loginUser != null && loginUser.getUserPwd() == loginUser.getUserPwd()) {
			session.setAttribute("loginUser", loginUser);
			status.setComplete(); // 로그인 성공 결과를 보냄 (HttpStatus 200 코드 보냄)
			return "common/main";
		} else {
			model.addAttribute("message", "로그인 실패! 아이디나 암호를 다시 확인하세요. 또는 로그인 제한 회원입니다. 관리자에게 문의하세요.");
			return "common/error";
		}
	}
	@PostMapping("logout.do")
    public String logout(HttpSession session, SessionStatus status) {
        logger.info("logout.do called");
        session.invalidate();
        status.setComplete();
        return "redirect:/";
    }
	//회원 가입
	@RequestMapping("resister.do")
	public String moveResisterPage() {
		return "user/resister";
	}
	
	@RequestMapping("resisterId.do")
	public String goToNext() {
		return "user/resisterId";
	}
	
	@PostMapping("idchk.do")
    @ResponseBody
    public Map<String, Object> checkId(@RequestParam(name = "userId") String userId) {
        logger.info("idchk.do : " + userId);
        boolean available = userservice.checkIdAvailability(userId);
        Map<String, Object> response = new HashMap<>();
        response.put("available", available);
        response.put("message", available ? "사용 가능한 아이디입니다." : "이미 사용중인 아이디입니다.");
        return response;
    }

    @PostMapping("registerUser.do")
    @ResponseBody
    public Map<String, Object> register(@RequestBody User user) {
        logger.info("register : " + user);
        Map<String, Object> response = new HashMap<>();
        try {
            userservice.registerUser(user);
            response.put("success", true);
            response.put("message", "회원가입 성공");
        } catch (Exception e) {
            logger.error("Registration error: ", e);
            response.put("success", false);
            response.put("message", "회원가입 실패: " + e.getMessage());
        }
        return response;
    }

}
