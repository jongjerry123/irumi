package com.project.irumi.user.controller;

//import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
//import com.google.api.client.auth.oauth2.TokenResponse;
//import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
//import com.google.api.client.http.javanet.NetHttpTransport;
//import com.google.api.client.json.jackson2.JacksonFactory;
import com.project.irumi.user.model.dto.User;
import com.project.irumi.user.service.NaverMailService;
import com.project.irumi.user.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/* 삭제된 Gmail 관련 import
import java.io.ByteArrayOutputStream;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.services.gmail.Gmail;
import com.google.api.services.gmail.model.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
*/

@Controller
public class UserController {
	// private static final Logger logger =
	// LoggerFactory.getLogger(UserController.class);
	private static final String RANDOM_PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
	private static final int PASSWORD_LENGTH = 16;
//    private static final String REDIRECT_URI = "http://localhost:8080/irumi/oauth2callback";

	@Value("${google.client.id}")
	private String GOOGLE_CLIENT_ID;
	@Value("${google.client.secret}")
	private String GOOGLE_CLIENT_SECRET;
	@Value("${naver.client.id}")
	private String NAVER_CLIENT_ID;
	@Value("${naver.client.secret}")
	private String NAVER_CLIENT_SECRET;
	@Value("${kakao.client.id}")
	private String KAKAO_CLIENT_ID;
	// 추가: Naver Mail API 인증 정보
	@Value("${naver.mail.sender-email}")
	private String NAVER_MAIL_SENDER_EMAIL;

	@Autowired
	private UserService userservice;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Autowired
	private RestTemplate restTemplate;

	// 추가: Naver Mail Service 의존성 주입
	@Autowired
	private NaverMailService naverMailService;

	// 로그인 페이지로 이동하는 메소드
	@RequestMapping(value = "loginPage.do", method = RequestMethod.GET)
	public String moveToLoginPage() {
//       logger.info("moveToLoginPage: Displaying login page");
		return "user/login";
	}

	// 비밀번호 변경권유 페이지
	@RequestMapping(value = "6MChangPwd.do", method = RequestMethod.GET)
	public String changePasswordPage(HttpSession session, Model model) {
//       logger.info("6MChangPwd.do: Displaying password change page");
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
//          logger.warn("6MChangPwd.do: No user in session, redirecting to login");
			model.addAttribute("message", "로그인이 필요합니다.");
			return "redirect:/loginPage.do";
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//          logger.warn("6MChangPwd.do: Social login user (type={}), redirecting to main",
//                loginUser.getUserLoginType());
			return "user/main";
		}
		return "user/6MChangPwd";
	}

	// 로그아웃
	@RequestMapping(value = "logout.do", method = RequestMethod.POST)
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/main.do";
	}

	// 약관페이지로 이동
	@RequestMapping("resister.do")
	public String moveResisterPage() {
//       logger.info("moveResisterPage: Displaying registration page");
		return "user/resister";
	}

	// 약관 페이지-> 회원가입페이지
	@RequestMapping("resisterId.do")
	public String goToNext() {
//       logger.info("goToNext: Displaying resisterId page");
		return "user/resisterId";
	}

	// 아이디 찾기 페이지 이동
	@RequestMapping("findId.do")
	public String goToFindId() {
//       logger.info("goToFindId: Displaying findId page");
		return "user/findId";
	}

	// 이메일 정보 전송 및 아이디 찾기 처리
	@PostMapping("findId.do")
	public String processFindId(@RequestParam(name = "email") String email, HttpSession session) {
//        logger.info("processFindId: Processing email for findId");
		session.setAttribute("findIdEmail", email);
		return "redirect:/showId.do";
	}

	// 아이디 알려주는 페이지 이동 및 결과 표시
	@GetMapping("showId.do")
	public String showId(HttpSession session, Model model) {
//        logger.info("showId: Displaying showId page");
		String email = (String) session.getAttribute("findIdEmail");
		if (email != null && email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
			String userId = userservice.findIdByEmail(email);
			model.addAttribute("userId", userId);
			session.removeAttribute("findIdEmail");
		} else {
			model.addAttribute("userId", null);
		}
		return "user/showId";
	}

	// 비밀번호 찾기 페이지 이동
	@RequestMapping("findPassword.do")
	public String goTofindPassword() {
//       logger.info("goTofindPassword: Displaying findPassword page");
		return "user/findPassword";
	}

	// 마이페이지 이동
	@RequestMapping("myPage.do")
	public String moveMyPage() {
//       logger.info("moveMyPage: Displaying myPage");
		return "user/myPage";
	}

	// 관리자 기능 페이지 이동
	@RequestMapping("changeManage.do")
	public String changeManage(HttpSession session) {
//       logger.info("changeManage: Displaying changeManage page");
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
//          logger.warn("changeManage: Unauthorized access attempt by userId={}",
//                loginUser != null ? loginUser.getUserId() : "null");
			return "redirect:/loginPage.do";
		}
		return "user/changeManage";
	}

	// 랜덤 비밀번호 생성기
	private String generateRandomPassword() {
		SecureRandom random = new SecureRandom();
		StringBuilder password = new StringBuilder(PASSWORD_LENGTH);
		for (int i = 0; i < PASSWORD_LENGTH; i++) {
			password.append(RANDOM_PASSWORD_CHARS.charAt(random.nextInt(RANDOM_PASSWORD_CHARS.length())));
		}
		return password.toString();
	}

	// Naver Mail API를 사용한 인증번호 전송
	@PostMapping("sendVerification.do")
	@ResponseBody
	public Map<String, Object> sendVerification(@RequestParam("email") String email, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			// 1. 이메일 형식 유효성 검사
			if (email == null || !email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
				response.put("success", false);
				response.put("message", "올바른 이메일 형식이 아닙니다.");
				return response;
			}

			// 2. 보안 강화된 인증번호 생성
			SecureRandom random = new SecureRandom();
			String code = String.format("%06d", random.nextInt(1000000)); // 6자리 숫자
			long currentTime = System.currentTimeMillis();
			Date expiry = new Date(currentTime + 5 * 60 * 1000);

			// 3. 이메일 전송 (Naver Mail API 호출)
			String subject = "이메일 인증번호";
			String body = "인증번호: " + code + "\n이 코드는 5분 동안 유효합니다.";
			naverMailService.sendEmail(email, subject, body);

			// 4. 인증 정보 세션에 저장
			session.setAttribute("verificationCode", code);
			session.setAttribute("verificationEmail", email);
			session.setAttribute("emailTokenExpiry", expiry);

			response.put("success", true);
			response.put("message", "인증번호가 전송되었습니다.");

		} catch (IllegalArgumentException e) {
			response.put("success", false);
			response.put("message", e.getMessage());
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "인증번호 전송에 실패했습니다. 다시 시도해 주세요.");
			// logger.error("Naver Mail API 오류: ", e);
		}

		return response;
	}

	@RequestMapping(value = "login.do", method = RequestMethod.POST)
	public String loginMethod(User user, HttpSession session, Model model) {
		try {
			if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
				model.addAttribute("message", "아이디를 입력하세요.");
				return "user/login";
			}
			if (user.getUserPwd() == null || user.getUserPwd().trim().isEmpty()) {
				model.addAttribute("message", "비밀번호를 입력하세요.");
				return "user/login";
			}
			User loginUser = userservice.selectUser(user);
			if (loginUser == null) {
				model.addAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
				return "user/login";
			}
			if ("3".equals(loginUser.getUserAuthority())) {
				return "user/cantLoginPage";
			}
			if ("4".equals(loginUser.getUserAuthority())) {
				return "user/blockLogin";
			}

			if (bcryptPasswordEncoder.matches(user.getUserPwd(), loginUser.getUserPwd())) {
				session.setAttribute("loginUser", loginUser);

				if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
					return "common/main";
				}

				Date chPwd = loginUser.getChPWD();
				if (chPwd != null) {
					LocalDate pwdChangeDate = chPwd.toLocalDate();
					LocalDate currentDate = LocalDate.now();
					long daysSinceChange = ChronoUnit.DAYS.between(pwdChangeDate, currentDate);
					if (daysSinceChange >= 180) {
						return "redirect:/6MChangPwd.do";
					}
				} else {
					return "redirect:/6MChangPwd.do";
				}

				return "common/main";
			} else {
				model.addAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
				return "user/login";
			}
		} catch (Exception e) {
			model.addAttribute("message", "로그인 중 오류가 발생했습니다.");
			return "user/login";
		}
	}

	@RequestMapping(value = "updatePassword.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatePassword(@RequestParam(name = "userId") String userId,
			@RequestParam(name = "newPassword") String newPassword, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !loginUser.getUserId().equals(userId)) {
			response.put("success", false);
			response.put("message", "로그인 정보가 유효하지 않습니다.");
			return response;
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
			response.put("success", false);
			response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
			return response;
		}
		try {
			String encodedPassword = bcryptPasswordEncoder.encode(newPassword);
			userservice.updatePassword(userId, encodedPassword);
			response.put("success", true);
			response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
		}
		return response;
	}

	@RequestMapping(value = "checkPassword.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkPassword(@RequestBody Map<String, String> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return response;
			}

			if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
				response.put("success", false);
				response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
				return response;
			}

			String currentPassword = loginUser.getUserPwd();
			if (currentPassword == null || !currentPassword.startsWith("$2a$")) {
				response.put("success", false);
				response.put("message", "현재 비밀번호 정보가 유효하지 않습니다.");
				return response;
			}

			String newPassword = data.get("password");
			if (newPassword == null || newPassword.isEmpty()) {
				response.put("success", true);
				response.put("isSame", false);
				response.put("message", "");
				return response;
			}

			boolean isSame = bcryptPasswordEncoder.matches(newPassword, currentPassword);
			response.put("success", true);
			response.put("isSame", isSame);
			response.put("message", isSame ? "새 비밀번호는 현재 비밀번호와 달라야 합니다." : "");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "비밀번호 확인 중 오류: " + e.getMessage());
		}
		return response;
	}

	@RequestMapping(value = "deferPasswordChange.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deferPasswordChange(@RequestParam(name = "userId") String userId, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !loginUser.getUserId().equals(userId)) {
			response.put("success", false);
			response.put("message", "로그인 정보가 유효하지 않습니다.");
			return response;
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
			response.put("success", false);
			response.put("message", "소셜 로그인 사용자는 비밀번호 변경 연기를 할 수 없습니다.");
			return response;
		}
		try {
			long pastChPwdMillis = System.currentTimeMillis() - (120L * 24 * 60 * 60 * 1000);
			userservice.updateChPwd(userId, new Date(pastChPwdMillis));
			response.put("success", true);
			response.put("message", "비밀번호 변경 주기가 120일 전으로 설정되었습니다.");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "연기 처리 중 오류가 발생했습니다.");
		}
		return response;
	}

	@RequestMapping(value = "updateUserProfile.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateUserProfile(@RequestBody Map<String, Object> userData, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return response;
			}

			if (userData.get("password") != null && !userData.get("password").toString().isEmpty()
					&& Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
				response.put("success", false);
				response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
				return response;
			}

			if (userData.get("password") != null && !userData.get("password").toString().isEmpty()) {
				String currentPassword = loginUser.getUserPwd();
				if (currentPassword == null || !currentPassword.startsWith("$2a$")) {
					response.put("success", false);
					response.put("message", "현재 비밀번호 정보가 유효하지 않습니다.");
					return response;
				}

				if (bcryptPasswordEncoder.matches(userData.get("password").toString(), currentPassword)) {
					response.put("success", false);
					response.put("message", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
					return response;
				}
				userData.put("password", bcryptPasswordEncoder.encode(userData.get("password").toString()));
			}

			userData.put("userId", loginUser.getUserId());
			userservice.updateUserProfile(userData);

			User updatedUser = userservice.selectUser(loginUser);
			session.setAttribute("loginUser", updatedUser);

			response.put("success", true);
			response.put("message", "업데이트 성공");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "업데이트 실패: " + e.getMessage());
		}
		return response;
	}

	@PostMapping("idchk.do")
	@ResponseBody
	public Map<String, Object> checkId(@RequestParam(name = "userId") String userId) {
		boolean available = userservice.checkIdAvailability(userId);
		Map<String, Object> response = new HashMap<>();
		
		response.put("available", available);
		response.put("message", available ? "사용 가능한 아이디입니다." : "이미 사용중인 아이디입니다.");
		return response;
	}

	@PostMapping("checkEmail.do")
	@ResponseBody
	public Map<String, Object> checkEmail(@RequestParam(name = "email") String email) {
		boolean available = userservice.checkEmailAvailability(email);
		Map<String, Object> response = new HashMap<>();
		response.put("available", available);
		response.put("message", available ? "사용 가능한 이메일입니다." : "이미 가입되어 있는 유저입니다.");
		return response;
	}

	@GetMapping("verifyCode.do")
	public String handleGetVerifyCode() {
		return "redirect:/resister.do";
	}

	@PostMapping("verifyCode.do")
	@ResponseBody
	public Map<String, Object> verifyCode(@RequestParam(name = "code") String code, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			if (code == null || code.trim().isEmpty()) {
				throw new IllegalArgumentException("인증번호를 입력하세요.");
			}
			String storedCode = (String) session.getAttribute("verificationCode");
//            String email = (String) session.getAttribute("verificationEmail");
			Date expiry = (Date) session.getAttribute("emailTokenExpiry");
			if (expiry != null && System.currentTimeMillis() > expiry.getTime()) {
				response.put("success", false);
				response.put("message", "인증번호가 만료되었습니다.");
				session.removeAttribute("verificationCode");
				session.removeAttribute("verificationEmail");
				session.removeAttribute("emailTokenExpiry");
				return response;
			}
			if (storedCode != null && storedCode.equals(code)) {
				session.setAttribute("emailVerified", true);
				response.put("success", true);
				response.put("message", "이메일 인증이 완료되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "인증번호가 일치하지 않습니다.");
			}
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "인증 실패: " + e.getMessage());
		}
		return response;
	}

	@PostMapping("registerUser.do")
	@ResponseBody
	public Map<String, Object> register(@RequestBody User user, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
			String verificationEmail = (String) session.getAttribute("verificationEmail");
			if (emailVerified == null || !emailVerified || !user.getUserEmail().equals(verificationEmail)) {
				throw new IllegalStateException("이메일 인증이 필요합니다.");
			}
			if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
				throw new IllegalArgumentException("아이디가 필요합니다.");
			}
			if (user.getUserEmail() == null || user.getUserEmail().trim().isEmpty()) {
				throw new IllegalArgumentException("이메일이 필요합니다.");
			}
			if (user.getUserPwd() == null || user.getUserPwd().trim().isEmpty()) {
				throw new IllegalArgumentException("비밀번호가 필요합니다.");
			}
			if (user.getUserAuthority() == null || user.getUserAuthority().trim().isEmpty()) {
				user.setUserAuthority("1");
			}
			user.setEmailVerification("Y");
			user.setEmailVerificationToken((String) session.getAttribute("verificationCode"));
			user.setEmailTokenExpiry((Date) session.getAttribute("emailTokenExpiry"));
			userservice.registerUser(user);
			response.put("success", true);
			response.put("message", "회원가입이 완료되었습니다.");
			session.removeAttribute("emailVerified");
			session.removeAttribute("verificationCode");
			session.removeAttribute("verificationEmail");
			session.removeAttribute("emailTokenExpiry");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "회원가입 실패: " + e.getMessage());
		}
		return response;
	}

	// 아이디 찾기에서 아이디주인과 이메일이 일치한지
	@PostMapping("checkUser.do")
	@ResponseBody
	public Map<String, Object> checkUser(@RequestParam("userId") String userId, @RequestParam("email") String email) {
		Map<String, Object> response = new HashMap<>();
		try {
			boolean matched = userservice.checkUserMatch(userId, email);
			response.put("matched", matched);
			response.put("message", matched ? "아이디와 이메일이 일치합니다." : "아이디와 이메일이 일치하지 않습니다.");
		} catch (Exception e) {
			response.put("matched", false);
			response.put("message", "사용자 확인 중 오류가 발생했습니다.");
			// logger.error("Error in checkUser: ", e);
		}
		return response;
	}

	// 임시 비밀번호 생성 및 전송
	@GetMapping("resetPassword.do")
	@ResponseBody
	public Map<String, Object> resetPassword(@RequestParam(name = "userId") String userId,
			@RequestParam(name = "email") String email, HttpSession session) {
		// logger.info("resetPassword.do: Processing for userId = {}, email = {}",
		// userId, email);
		Map<String, Object> response = new HashMap<>();

		Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
		if (emailVerified == null || !emailVerified) {
			response.put("success", false);
			response.put("message", "이메일 인증이 필요합니다.");
			response.put("redirectUrl", "findPassword.do");
			return response;
		}

		try {
			// 사용자 조회
			User user = userservice.selectUserById(userId);
			if (user == null) {
				response.put("success", false);
				response.put("message", "사용자를 찾을 수 없습니다.");
				// logger.warn("resetPassword.do: User not found for userId = {}", userId);
				return response;
			}

			// 이메일 유효성 검사
			if (email == null || email.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "이메일 주소가 입력되지 않았습니다.");
				// logger.warn("resetPassword.do: Email is null or empty for userId = {}",
				// userId);
				return response;
			}

			// 입력된 이메일과 DB 이메일 일치 여부 확인
			boolean match = userservice.checkUserMatch(userId, email);
			if (!match) {
				response.put("success", false);
				response.put("message", "입력한 이메일이 사용자 정보와 일치하지 않습니다.");
				// logger.warn("resetPassword.do: Email mismatch for userId = {}, input email =
				// {}인 유저가 없습니다.",
				// userId, email, user.getUserEmail());
				return response;
			}

			// 소셜 로그인 사용자 여부 확인
			if (Arrays.asList(3, 4, 5).contains(user.getUserLoginType())) {
				response.put("success", false);
				response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
				// logger.warn("resetPassword.do: Social login user cannot reset password,
				// userId = {}", userId);
				return response;
			}

			// 임시 비밀번호 생성
			String tempPassword = generateRandomPassword();
			String encodedPassword = bcryptPasswordEncoder.encode(tempPassword);

			// 비밀번호 업데이트
			userservice.updatePassword(userId, encodedPassword);

			// 이메일 전송
			String subject = "임시 비밀번호";
			String body = "귀하의 임시 비밀번호는 다음과 같습니다: " + tempPassword + "\n로그인 후 비밀번호를 변경해 주세요.";
			naverMailService.sendEmail(email, subject, body);

			// 인증 정보 초기화
			user.setEmailVerification("N");
			user.setEmailVerificationToken(null);
			user.setEmailTokenExpiry(null);
			userservice.updateUserVerification(user);

			// 세션 인증 상태 초기화
			session.removeAttribute("emailVerified");

			response.put("success", true);
			response.put("message", "임시 비밀번호가 이메일로 전송되었습니다.");
			response.put("redirectUrl", "loginPage.do");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "비밀번호 변경 중 오류가 발생했습니다: " + e.getMessage());
			// logger.error("Error in resetPassword: ", e);
		}
		return response;
	}

	// 구글 로그인 요청
	@GetMapping("/googleLogin.do")
	public String googleLogin(HttpServletRequest request) {
		String state = String.valueOf((int) (Math.random() * 900000) + 100000);
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ "/irumi/socialCallback.do?provider=google";
		String authUrl = String.format(
				"https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=%s&redirect_uri=%s&scope=email%%20profile&state=%s",
				GOOGLE_CLIENT_ID, redirectUri, state);
		return "redirect:" + authUrl;
	}

	// 네이버 로그인 요청
	@GetMapping("/naverLogin.do")
	public String naverLogin(HttpServletRequest request) {
		String state = String.valueOf((int) (Math.random() * 900000) + 100000);
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/socialCallback.do?provider=naver";
		String authUrl = String.format(
				"https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=%s&redirect_uri=%s&state=%s",
				NAVER_CLIENT_ID, redirectUri, state);
		return "redirect:" + authUrl;
	}

	// 카카오 로그인 요청
	@GetMapping("/kakaoLogin.do")
	public String kakaoLogin(HttpServletRequest request) {
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/socialCallback.do?provider=kakao";
		String authUrl = String.format(
				"https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s",
				KAKAO_CLIENT_ID, redirectUri);
		return "redirect:" + authUrl;
	}

	// 소셜 로그인 토합 콜백
	@GetMapping("/socialCallback.do")
	public String socialCallback(@RequestParam("code") String code,
			@RequestParam(value = "provider", defaultValue = "google") String provider, HttpSession session,
			Model model, HttpServletRequest request) {
		try {
			int loginType;
			String socialId, email, name;
			String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
					+ request.getContextPath() + "/socialCallback.do?provider=" + provider;

			if ("google".equalsIgnoreCase(provider)) {
				loginType = 3;
				String tokenUrl = String.format(
						"https://oauth2.googleapis.com/token?grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
						GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, redirectUri, code);
				ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);
				if (tokenResponse.getStatusCode() != HttpStatus.OK) {
					throw new IllegalStateException("Google token request failed: " + tokenResponse.getBody());
				}
				ObjectMapper mapper = new ObjectMapper();
				JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());
				if (tokenJson.has("error")) {
					throw new IllegalStateException(
							"Google token error: " + tokenJson.get("error_description").asText());
				}
				JsonNode accessTokenNode = tokenJson.get("access_token");
				if (accessTokenNode == null) {
					throw new IllegalStateException(
							"Google token response missing access_token: " + tokenResponse.getBody());
				}
				String accessToken = accessTokenNode.asText();

				HttpHeaders headers = new HttpHeaders();
				headers.setBearerAuth(accessToken);
				HttpEntity<?> entity = new HttpEntity<>(headers);
				ResponseEntity<String> userResponse = restTemplate.exchange(
						"https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, entity, String.class);
				if (userResponse.getStatusCode() != HttpStatus.OK) {
					throw new IllegalStateException("Google user info request failed: " + userResponse.getBody());
				}
				JsonNode userJson = mapper.readTree(userResponse.getBody());
				JsonNode idNode = userJson.get("id");
				if (idNode == null) {
					throw new IllegalStateException(
							"Google user response missing 'id' field: " + userResponse.getBody());
				}
				socialId = idNode.asText();
				JsonNode emailNode = userJson.get("email");
				email = emailNode != null ? emailNode.asText() : null;
				JsonNode nameNode = userJson.get("name");
				name = nameNode != null ? nameNode.asText() : null;
				if (name == null) {
					name = "Google User";
				}

				if (email != null) {
					int suffix = 100000 + new java.util.Random().nextInt(900000);
					email = socialId + "@gmail.com" + suffix;
					while (!userservice.checkEmailAvailability(email)) {
						suffix++;
						email = socialId + "@gmail.com" + suffix;
					}
				}
			} else if ("naver".equalsIgnoreCase(provider)) {
				loginType = 4;
				String tokenUrl = String.format(
						"https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&client_id=%s&client_secret=%s&code=%s",
						NAVER_CLIENT_ID, NAVER_CLIENT_SECRET, code);
				ResponseEntity<String> tokenResponse = restTemplate.getForEntity(tokenUrl, String.class);
				if (tokenResponse.getStatusCode() != HttpStatus.OK) {
					throw new IllegalStateException("Naver token request failed: " + tokenResponse.getBody());
				}
				ObjectMapper mapper = new ObjectMapper();
				JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());
				if (tokenJson.has("error")) {
					throw new IllegalStateException(
							"Naver token error: " + tokenJson.get("error_description").asText());
				}
				JsonNode accessTokenNode = tokenJson.get("access_token");
				if (accessTokenNode == null) {
					throw new IllegalStateException(
							"Naver token response missing access_token: " + tokenResponse.getBody());
				}
				String accessToken = accessTokenNode.asText();

				HttpHeaders headers = new HttpHeaders();
				headers.setBearerAuth(accessToken);
				HttpEntity<?> entity = new HttpEntity<>(headers);
				ResponseEntity<String> userResponse = restTemplate.exchange("https://openapi.naver.com/v1/nid/me",
						HttpMethod.GET, entity, String.class);
				if (userResponse.getStatusCode() != HttpStatus.OK) {
					throw new IllegalStateException("Naver user info request failed: " + userResponse.getBody());
				}
				JsonNode userJson = mapper.readTree(userResponse.getBody());
				JsonNode responseNode = userJson.get("response");
				if (responseNode == null) {
					throw new IllegalStateException(
							"Naver user response missing 'response' field: " + userResponse.getBody());
				}
				JsonNode idNode = responseNode.get("id");
				if (idNode == null) {
					throw new IllegalStateException(
							"Naver user response missing 'id' field: " + userResponse.getBody());
				}
				socialId = idNode.asText();
				JsonNode emailNode = responseNode.get("email");
				email = emailNode != null ? emailNode.asText() : null;
				JsonNode nicknameNode = responseNode.get("nickname");
				name = nicknameNode != null ? nicknameNode.asText() : null;
				if (name == null) {
					name = "Naver User";
				}
			} else if ("kakao".equalsIgnoreCase(provider)) {
				loginType = 5;
				String tokenUrl = String.format(
						"https://kauth.kakao.com/oauth/token?grant_type=authorization_code&client_id=%s&redirect_uri=%s&code=%s",
						KAKAO_CLIENT_ID, redirectUri, code);
				ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);
				ObjectMapper mapper = new ObjectMapper();
				JsonNode tokenJson = mapper.readTree(tokenResponse.getBody());
				String accessToken = tokenJson.get("access_token").asText();

				HttpHeaders headers = new HttpHeaders();
				headers.setBearerAuth(accessToken);
				HttpEntity<?> entity = new HttpEntity<>(headers);
				ResponseEntity<String> userResponse = restTemplate.exchange("https://kapi.kakao.com/v2/user/me",
						HttpMethod.GET, entity, String.class);
				JsonNode userJson = mapper.readTree(userResponse.getBody());
				socialId = userJson.get("id").asText();
				email = userJson.get("kakao_account").get("email") != null
						? userJson.get("kakao_account").get("email").asText()
						: null;
				name = userJson.get("properties").get("nickname").asText();
				if (name == null) {
					name = "Kakao User";
				}
			} else {
				throw new IllegalArgumentException("Unsupported provider: " + provider);
			}

			if (email == null) {
				email = socialId + "@" + provider.toLowerCase() + ".com";
			}

			User existingUser = userservice.findUserBySocialId(socialId, loginType);
			if (existingUser != null) {
				String authority = userservice.selectUserAuthority(socialId);
				if ("3".equals(authority)) {
					return "user/cantLoginPage";
				}
				if ("4".equals(authority)) {
					return "user/blockLogin";
				}
				session.setAttribute("loginUser", existingUser);
				return "redirect:/main.do";
			}

			session.setAttribute("socialId", socialId);
			session.setAttribute("socialEmail", email);
			session.setAttribute("socialName", name);
			session.setAttribute("socialLoginType", loginType);
			model.addAttribute("socialProvider",
					provider.substring(0, 1).toUpperCase() + provider.substring(1).toLowerCase());
			return "user/registerSocialUser";
		} catch (Exception e) {
			model.addAttribute("message", provider + " 로그인 중 오류가 발생했습니다: " + e.getMessage());
			return "user/login";
		}
	}

	// 소설 로그인 첫 이용자 회원가입용
	@PostMapping("/registerSocialUser.do")
	public String registerSocialUser(@RequestParam(name = "userName") String userName, HttpSession session,
			Model model) {
		try {
			String socialId = (String) session.getAttribute("socialId");
			String email = (String) session.getAttribute("socialEmail");
			String defaultName = (String) session.getAttribute("socialName");
			Integer loginType = (Integer) session.getAttribute("socialLoginType");

			if (socialId == null || email == null || loginType == null) {
				model.addAttribute("message", "소셜 사용자 정보가 유효하지 않습니다.");
				return "user/login";
			}

			User newUser = new User();
			String prefix = loginType == 3 ? "google_" : loginType == 4 ? "naver_" : "kakao_";
			String baseId = prefix + socialId.substring(0, Math.min(6, socialId.length()));
			String userId = baseId;
			int suffix = 1;
			while (!userservice.checkIdAvailability(userId)) {
				userId = baseId + "_" + suffix++;
			}
			newUser.setUserId(userId);
			newUser.setUserEmail(email);
			newUser.setUserName(userName.trim().isEmpty() ? defaultName : userName);
			newUser.setUserLoginType(loginType);
			newUser.setUserSocialId(socialId);
			newUser.setUserAuthority("1");
			newUser.setEmailVerification("Y");

			String randomPassword = generateRandomPassword();
			newUser.setUserPwd(bcryptPasswordEncoder.encode(randomPassword));

			userservice.registerUser(newUser);

			session.setAttribute("loginUser", newUser);

			session.removeAttribute("socialId");
			session.removeAttribute("socialEmail");
			session.removeAttribute("socialName");
			session.removeAttribute("socialLoginType");

			return "redirect:/main.do";
		} catch (Exception e) {
			model.addAttribute("message", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
			return "user/registerSocialUser";
		}
	}
	//유저 총괄 관리에서 유저 조회 
	@RequestMapping(value = "checkMaUser.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkMaUser(@RequestBody Map<String, String> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
				response.put("success", false);
				response.put("message", "관리자 권한이 필요합니다.");
				return response;
			}

			String userId = data.get("userId");
			if (userId == null || userId.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "유저 ID를 입력해주세요.");
				return response;
			}

			User user = userservice.selectUserById(userId.trim());
			String Authority= userservice.selectUserAuthorityByUserId(userId.trim());
			if (user != null) {
				response.put("success", true);
				response.put("exists", true);
				if("1".equals(Authority)) {
					response.put("message", "일반 유저입니다.");
				}else if("2".equals(Authority)) {
					response.put("message", "관리자입니다.");
				}else if("3".equals(Authority)) {
					response.put("message", "불량 유저입니다.");
				}else {
					response.put("message", "탈퇴 유저입니다.");
				}
				response.put("userId", user.getUserId());
				response.put("currentAuthority", Authority);
			} else {
				response.put("success", true);
				response.put("exists", false);
				response.put("message", "존재하지 않는 유저입니다.");
			}
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "유저 확인 중 오류: " + e.getMessage());
		}
		return response;
	}

	@RequestMapping(value = "updateAuthority.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateAuthority(@RequestBody Map<String, Object> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
				response.put("success", false);
				response.put("message", "관리자 권한이 필요합니다.");
				return response;
			}

			String userId = (String) data.get("userId");
			String authority = data.get("authority").toString();
			if (userId == null || userId.trim().isEmpty() || authority == null) {
				response.put("success", false);
				response.put("message", "유효하지 않은 입력입니다.");
				return response;
			}

			User user = userservice.selectUserById(userId.trim());
			if (user == null) {
				response.put("success", false);
				response.put("message", "존재하지 않는 유저입니다.");
				return response;
			}

			userservice.updateUserAuthority(userId, authority);
			response.put("success", true);
			response.put("message", "권한이 성공적으로 변경되었습니다.");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "권한 변경 중 오류: " + e.getMessage());
		}
		return response;
	}

	@RequestMapping(value = "exit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> exit(@RequestBody Map<String, Object> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser != null) {
			String userId = loginUser.getUserId();
			String authority = data.get("authority").toString();

			userservice.updateUserAuthority(userId, authority);

			session.invalidate();
			response.put("status", "success");
			response.put("message", "탈퇴 처리 완료");
		} else {
			response.put("status", "error");
			response.put("message", "로그인 정보 없음");
		}

		return response;
	}
}