package com.project.irumi.user.controller;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.SecureRandom;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.gmail.Gmail;
import com.google.api.services.gmail.model.Message;
import com.project.irumi.user.model.dto.User;
import com.project.irumi.user.service.UserService;

import jakarta.mail.Message.RecipientType;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
//	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	private static final String APPLICATION_NAME = "irumi";
	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
	private static final String CREDENTIALS_FILE_PATH = "/credentials.json";
	private static final String FROM_EMAIL = "irumi@gmail.com";
	private static final String RANDOM_PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
	private static final int PASSWORD_LENGTH = 16;

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

	@Autowired
	private UserService userservice;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Autowired
	private RestTemplate restTemplate;

	private Gmail gmailService;

	public UserController() {
		try {
			final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
			gmailService = new Gmail.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
					.setApplicationName(APPLICATION_NAME).build();
//			logger.info("GmailService initialized successfully");
		} catch (Exception e) {
//			logger.error("Failed to initialize GmailService", e);
		}
	}

	private Credential getCredentials(final NetHttpTransport HTTP_TRANSPORT) throws Exception {
		InputStream in = UserController.class.getResourceAsStream(CREDENTIALS_FILE_PATH);
		if (in == null) {
			throw new IllegalStateException("Credentials file not found at: " + CREDENTIALS_FILE_PATH);
		}
		try (InputStreamReader reader = new InputStreamReader(in)) {
			GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, reader);
			GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(HTTP_TRANSPORT, JSON_FACTORY,
					clientSecrets, Collections.singletonList("https://www.googleapis.com/auth/gmail.send"))
					.setDataStoreFactory(new FileDataStoreFactory(new java.io.File("tokens"))).setAccessType("offline")
					.build();
			LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8888).build();
			return new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");
		}
	}

	private MimeMessage createEmail(String to, String from, String subject, String bodyText) throws Exception {
		if (!to.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
			throw new IllegalArgumentException("Invalid recipient email: " + to);
		}
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		MimeMessage email = new MimeMessage(session);
		email.setFrom(new InternetAddress(from));
		email.addRecipient(RecipientType.TO, new InternetAddress(to));
		email.setSubject(subject);
		email.setText(bodyText);
		return email;
	}
	//소셜 로그인 임시 이메일 생성
	private Message createMessageWithEmail(MimeMessage emailContent) throws Exception {
		java.io.ByteArrayOutputStream buffer = new java.io.ByteArrayOutputStream();
		emailContent.writeTo(buffer);
		byte[] bytes = buffer.toByteArray();
		String encodedEmail = java.util.Base64.getUrlEncoder().encodeToString(bytes);
		Message message = new Message();
		message.setRaw(encodedEmail);
		return message;
	}
	//소셜 로그인 임시 비밀번호 생성
	private String generateRandomPassword() {
		SecureRandom random = new SecureRandom();
		StringBuilder password = new StringBuilder(PASSWORD_LENGTH);
		for (int i = 0; i < PASSWORD_LENGTH; i++) {
			password.append(RANDOM_PASSWORD_CHARS.charAt(random.nextInt(RANDOM_PASSWORD_CHARS.length())));
		}
		return password.toString();
	}
	
	@RequestMapping("/")
	public String home() {
//		logger.info("home: Redirecting to main page");
		return "common/main";
	}

	@RequestMapping(value = "loginPage.do", method = RequestMethod.GET)
	public String moveToLoginPage() {
//		logger.info("moveToLoginPage: Displaying login page");
		return "user/login";
	}

	@RequestMapping(value = "login.do", method = RequestMethod.POST)
	public String loginMethod(User user, HttpSession session, Model model) {
//		logger.info("login.do: Received user = {}", user);
		try {
			if (user.getUserId() == null || user.getUserId().trim().isEmpty()) {
//				logger.warn("login.do: User ID is empty");
				model.addAttribute("message", "아이디를 입력하세요.");
				return "user/login";
			}
			if (user.getUserPwd() == null || user.getUserPwd().trim().isEmpty()) {
//				logger.warn("login.do: Password is empty");
				model.addAttribute("message", "비밀번호를 입력하세요.");
				return "user/login";
			}
			User loginUser = userservice.selectUser(user);
//			logger.info("login.do: Selected user = {}", loginUser);
			if (loginUser == null) {
//				logger.warn("login.do: No user found for userId = {}", user.getUserId());
				model.addAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
				return "user/login";
			}
			if("3".equals(loginUser.getUserAuthority())) {
				return "user/cantLoginPage";
			}
			if("4".equals(loginUser.getUserAuthority())) {
				return "user/blockLogin";
			}
			
			if (bcryptPasswordEncoder.matches(user.getUserPwd(), loginUser.getUserPwd())) {
//				logger.info("login.do: Login successful for userId = {}", user.getUserId());
				session.setAttribute("loginUser", loginUser);

				// 소셜 로그인 사용자는 비밀번호 변경 제외
				if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//					logger.info("login.do: Social login user (type={}), skipping password change check",
//							loginUser.getUserLoginType());
					return "common/main";
				}

				// CH_PWD 확인
				Date chPwd = loginUser.getChPWD();
				if (chPwd != null) {
					LocalDate pwdChangeDate = chPwd.toLocalDate();
					LocalDate currentDate = LocalDate.now();
					long daysSinceChange = ChronoUnit.DAYS.between(pwdChangeDate, currentDate);
					if (daysSinceChange >= 180) {
//						logger.info("login.do: Password change required for userId = {}, days since change = {}",
//								user.getUserId(), daysSinceChange);
						return "redirect:/6MChangPwd.do";
					}
				} else {
//					logger.info("login.do: CH_PWD is null for userId = {}, redirecting to change password",
//							user.getUserId());
					return "redirect:/6MChangPwd.do";
				}

				return "common/main";
			} else {
//				logger.warn("login.do: Password mismatch for userId = {}", user.getUserId());
				model.addAttribute("message", "아이디 또는 비밀번호가 올바르지 않습니다.");
				return "user/login";
			}
		} catch (Exception e) {
//			logger.error("login.do: Error during login for userId = {}", user.getUserId(), e);
			model.addAttribute("message", "로그인 중 오류가 발생했습니다.");
			return "user/login";
		}
	}
	//비밀번호 변경권유 페이지
	@RequestMapping(value = "6MChangPwd.do", method = RequestMethod.GET)
	public String changePasswordPage(HttpSession session, Model model) {
//		logger.info("6MChangPwd.do: Displaying password change page");
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
//			logger.warn("6MChangPwd.do: No user in session, redirecting to login");
			model.addAttribute("message", "로그인이 필요합니다.");
			return "redirect:/loginPage.do";
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//			logger.warn("6MChangPwd.do: Social login user (type={}), redirecting to main",
//					loginUser.getUserLoginType());
			return "user/main";
		}
		return "user/6MChangPwd";
	}
	//약관페이지로 이동
	@RequestMapping("resister.do")
	public String moveResisterPage() {
//		logger.info("moveResisterPage: Displaying registration page");
		return "user/resister";
	}
	//약관 페이지-> 회원가입페이지
	@RequestMapping("resisterId.do")
	public String goToNext() {
//		logger.info("goToNext: Displaying resisterId page");
		return "user/resisterId";
	}
	//로그아웃
	@RequestMapping(value = "logout.do", method = RequestMethod.POST)
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}

	@PostMapping("idchk.do")
	@ResponseBody
	public Map<String, Object> checkId(@RequestParam(name = "userId") String userId) {
//		logger.info("idchk.do: Checking userId = {}", userId);
		boolean available = userservice.checkIdAvailability(userId);
		Map<String, Object> response = new HashMap<>();
		response.put("available", available);
		response.put("message", available ? "사용 가능한 아이디입니다." : "이미 사용중인 아이디입니다.");
		return response;
	}

	@PostMapping("checkEmail.do")
	@ResponseBody
	public Map<String, Object> checkEmail(@RequestParam(name = "email") String email) {
//		logger.info("checkEmail.do: Checking email = {}", email);
		boolean available = userservice.checkEmailAvailability(email);
		Map<String, Object> response = new HashMap<>();
		response.put("available", available);
		response.put("message", available ? "사용 가능한 이메일입니다." : "이미 가입되어 있는 유저입니다.");
		return response;
	}

	@PostMapping("sendVerification.do")
	@ResponseBody
	public Map<String, Object> sendVerification(@RequestParam("email") String email, HttpSession session) {
//		logger.info("sendVerification.do: Received email = {}", email);
		Map<String, Object> response = new HashMap<>();
		try {
			if (gmailService == null) {
				throw new IllegalStateException("Gmail service is not initialized");
			}
			String code = String.valueOf((int) (Math.random() * 900000) + 100000);
			long currentTime = System.currentTimeMillis();
			Date expiry = new Date(currentTime + 5 * 60 * 1000);

			String subject = "이메일 인증번호";
			String body = "인증번호: " + code + "\n이 코드는 5분 동안 유효합니다.";
//			logger.info("sendVerification.do: Sending email to = {}, subject = {}", email, subject);

			MimeMessage emailMessage = createEmail(email, FROM_EMAIL, subject, body);
			Message message = createMessageWithEmail(emailMessage);
			gmailService.users().messages().send("me", message).execute();

			session.setAttribute("verificationCode", code);
			session.setAttribute("verificationEmail", email);
			session.setAttribute("emailTokenExpiry", expiry);
//			logger.info("sendVerification.do: Verification code sent to email = {}", email);

			response.put("success", true);
			response.put("message", "인증번호가 전송되었습니다.");
		} catch (Exception e) {
//			logger.error("sendVerification.do: Error sending verification email = {}", email, e);
			response.put("success", false);
			response.put("message", "인증번호 전송 실패: " + e.getMessage());
		}
		return response;
	}

	@GetMapping("verifyCode.do")
	public String handleGetVerifyCode() {
//		logger.warn("verifyCode.do: GET method not supported, redirecting to registration page");
		return "redirect:/resister.do";
	}

	@PostMapping("verifyCode.do")
	@ResponseBody
	public Map<String, Object> verifyCode(@RequestParam(name = "code") String code, HttpSession session) {
//		logger.info("verifyCode.do: Received code = {}", code);
		Map<String, Object> response = new HashMap<>();
		try {
			if (code == null || code.trim().isEmpty()) {
				throw new IllegalArgumentException("인증번호를 입력하세요.");
			}
			String storedCode = (String) session.getAttribute("verificationCode");
			String email = (String) session.getAttribute("verificationEmail");
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
//			logger.error("verifyCode.do: Error verifying code", e);
			response.put("success", false);
			response.put("message", "인증 실패: " + e.getMessage());
		}
		return response;
	}

	@PostMapping("registerUser.do")
	@ResponseBody
	public Map<String, Object> register(@RequestBody User user, HttpSession session) {
//		logger.info("registerUser.do: Received user = {}", user);
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
//			logger.info("registerUser.do: User registered successfully, userId = {}", user.getUserId());
			response.put("success", true);
			response.put("message", "회원가입이 완료되었습니다.");
			session.removeAttribute("emailVerified");
			session.removeAttribute("verificationCode");
			session.removeAttribute("verificationEmail");
			session.removeAttribute("emailTokenExpiry");
		} catch (Exception e) {
//			logger.error("registerUser.do: Registration error for userId = {}", user.getUserId(), e);
			response.put("success", false);
			response.put("message", "회원가입 실패: " + e.getMessage());
		}
		return response;
	}

	@RequestMapping("findId.do")
	public String goToFindId() {
//		logger.info("goToFindId: Displaying findId page");
		return "user/findId";
	}

	@RequestMapping("showId.do")
	public String goToShowId() {
//		logger.info("goToShowId: Displaying showId page");
		return "user/showId";
	}

	@GetMapping("showId.do")
	public String showId(@RequestParam(name = "email") String email, Model model) {
//		logger.info("showId.do: Finding userId for email = {}", email);
		String userId = userservice.findIdByEmail(email);
		model.addAttribute("userId", userId);
		return "user/showId";
	}

	@RequestMapping("findPassword.do")
	public String goTofindPassword() {
//		logger.info("goTofindPassword: Displaying findPassword page");
		return "user/findPassword";
	}

	@PostMapping("checkUser.do")
	@ResponseBody
	public Map<String, Object> checkMaUser(@RequestBody Map<String, String> data) {
		String userId = data.get("userId");
		String email = data.get("email");
//		logger.info("checkMaUser.do: Checking userId = {}, email = {}", userId, email);
		boolean matched = userservice.checkUserMatch(userId, email);
		Map<String, Object> response = new HashMap<>();
		response.put("matched", matched);
		response.put("message", matched ? "아이디와 이메일이 일치합니다." : "아이디와 이메일이 일치하지 않습니다.");
		return response;
	}

	@GetMapping("resetPassword.do")
	public String resetPassword(@RequestParam(name = "userId") String userId, HttpSession session, Model model) {
//		logger.info("resetPassword.do: Processing for userId = {}", userId);
		Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
		if (emailVerified != null && emailVerified) {
			model.addAttribute("userId", userId);
			return "user/resetPassword";
		} else {
//			logger.warn("resetPassword.do: Email not verified for userId = {}", userId);
			return "redirect:/findPassword.do";
		}
	}
	//
	@RequestMapping(value = "updatePassword.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatePassword(@RequestParam(name = "userId") String userId,
			@RequestParam(name = "newPassword") String newPassword, HttpSession session) {
//		logger.info("updatePassword.do: Updating password for userId = {}", userId);
		Map<String, Object> response = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !loginUser.getUserId().equals(userId)) {
//			logger.warn("updatePassword.do: Invalid session or userId mismatch for userId = {}", userId);
			response.put("success", false);
			response.put("message", "로그인 정보가 유효하지 않습니다.");
			return response;
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//			logger.info("updatePassword.do: Social login user (type={}) cannot change password",
//					loginUser.getUserLoginType());
			response.put("success", false);
			response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
			return response;
		}
		try {
			String encodedPassword = bcryptPasswordEncoder.encode(newPassword);
			userservice.updatePassword(userId, encodedPassword); // CH_PWD는 매퍼에서 sysdate로 자동 업데이트
//			logger.info("updatePassword.do: Password and CH_PWD updated for userId = {}", userId);
			response.put("success", true);
			response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
		} catch (Exception e) {
//			logger.error("updatePassword.do: Error updating password for userId = {}", userId, e);
			response.put("success", false);
			response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
		}
		return response;
	}
	//6개월 변경안한 유저 비밀번호 변경 메소드
	@RequestMapping(value = "deferPasswordChange.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deferPasswordChange(@RequestParam(name = "userId") String userId, HttpSession session) {
//		logger.info("deferPasswordChange.do: Deferring password change for userId = {}", userId);
		Map<String, Object> response = new HashMap<>();
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !loginUser.getUserId().equals(userId)) {
//			logger.warn("deferPasswordChange.do: Invalid session or userId mismatch for userId = {}", userId);
			response.put("success", false);
			response.put("message", "로그인 정보가 유효하지 않습니다.");
			return response;
		}
		if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//			logger.info("deferPasswordChange.do: Social login user (type={}) cannot defer password change",
//					loginUser.getUserLoginType());
			response.put("success", false);
			response.put("message", "소셜 로그인 사용자는 비밀번호 변경 연기를 할 수 없습니다.");
			return response;
		}
		try {
			// CH_PWD를 현재 날짜에서 120일 전으로 설정
			long pastChPwdMillis = System.currentTimeMillis() - (120L * 24 * 60 * 60 * 1000);
			userservice.updateChPwd(userId, new Date(pastChPwdMillis));
//			logger.info("deferPasswordChange.do: CH_PWD set to 120 days ago for userId = {}", userId);
			response.put("success", true);
			response.put("message", "비밀번호 변경 주기가 120일 전으로 설정되었습니다.");
		} catch (Exception e) {
//			logger.error("deferPasswordChange.do: Error deferring password change for userId = {}", userId, e);
			response.put("success", false);
			response.put("message", "연기 처리 중 오류가 발생했습니다.");
		}
		return response;
	}
	// 구글 로그인 api 호출
	@GetMapping("/googleLogin.do")
	public String googleLogin(HttpServletRequest request) {
//		logger.info("googleLogin.do: Initiating Google OAuth flow");
		String state = String.valueOf((int) (Math.random() * 900000) + 100000);
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ "/irumi/socialCallback.do?provider=google";
		String authUrl = String.format(
				"https://accounts.google.com/o/oauth2/v2/auth?response_type=code&client_id=%s&redirect_uri=%s&scope=email%%20profile&state=%s",
				GOOGLE_CLIENT_ID, redirectUri, state);
//		logger.info("googleLogin.do: Redirecting to auth URL: {}", authUrl);
		return "redirect:" + authUrl;
	}
	//네이버 로그인 api 호출
	@GetMapping("/naverLogin.do")
	public String naverLogin(HttpServletRequest request) {
//		logger.info("naverLogin.do: Initiating Naver OAuth flow");
		String state = String.valueOf((int) (Math.random() * 900000) + 100000);
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/socialCallback.do?provider=naver";
		String authUrl = String.format(
				"https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=%s&redirect_uri=%s&state=%s",
				NAVER_CLIENT_ID, redirectUri, state);
//		logger.info("naverLogin.do: Redirecting to auth URL: {}", authUrl);
		return "redirect:" + authUrl;
	}
	//카카오 로그인 api 호출
	@GetMapping("/kakaoLogin.do")
	public String kakaoLogin(HttpServletRequest request) {
//		logger.info("kakaoLogin.do: Initiating Kakao OAuth flow");
		String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/socialCallback.do?provider=kakao";
		String authUrl = String.format(
				"https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s",
				KAKAO_CLIENT_ID, redirectUri);
//		logger.info("kakaoLogin.do: Redirecting to auth URL: {}", authUrl);
		return "redirect:" + authUrl;
	}
	//소셜 통합 콜벡 
	@GetMapping("/socialCallback.do")
	public String socialCallback(@RequestParam("code") String code,
			@RequestParam(value = "provider", defaultValue = "google") String provider, HttpSession session,
			Model model, HttpServletRequest request) {
//		logger.info("socialCallback.do: Received request for provider: {}, code: {}, contextPath: {}", provider, code,
//				request.getContextPath());
		try {
			int loginType;
			String socialId, email, name;
			String redirectUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
					+ request.getContextPath() + "/socialCallback.do?provider=" + provider;
//			logger.debug("socialCallback.do: Using redirectUri: {}", redirectUri);

			if ("google".equalsIgnoreCase(provider)) {
				loginType = 3;
				// Google 토큰 요청
				String tokenUrl = String.format(
						"https://oauth2.googleapis.com/token?grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
						GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, redirectUri, code);
				ResponseEntity<String> tokenResponse = restTemplate.postForEntity(tokenUrl, null, String.class);
//				logger.debug("socialCallback.do: Google token response: {}", tokenResponse.getBody());
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

				// Google 사용자 정보 요청
				HttpHeaders headers = new HttpHeaders();
				headers.setBearerAuth(accessToken);
				HttpEntity<?> entity = new HttpEntity<>(headers);
				ResponseEntity<String> userResponse = restTemplate.exchange(
						"https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, entity, String.class);
//				logger.debug("socialCallback.do: Google user response: {}", userResponse.getBody());
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
					;
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
//				logger.debug("socialCallback.do: Naver token response: {}", tokenResponse.getBody());
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
//				logger.debug("socialCallback.do: Naver user response: {}", userResponse.getBody());
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
//				logger.info("socialCallback.do: Existing {} user found, userId = {}", provider,
//						existingUser.getUserId());
				String authority = userservice.selectUserAuthority(socialId);
	            if ("3".equals(authority)) {
	                return "user/cantLoginPage";
	            }
	            if("4".equals(authority)) {
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
//			logger.info("socialCallback.do: New {} user, redirecting to register page", provider);
			return "user/registerSocialUser";
		} catch (Exception e) {
//			logger.error("socialCallback.do: Error processing {} callback", provider, e);
			model.addAttribute("message", provider + " 로그인 중 오류가 발생했습니다: " + e.getMessage());
			return "user/login";
		}
	}
	//소셜 회원가입
	@PostMapping("/registerSocialUser.do")
	public String registerSocialUser(@RequestParam(name = "userName") String userName, HttpSession session,
			Model model) {
//		logger.info("registerSocialUser.do: Registering new social user, userName = {}", userName);
		try {
			String socialId = (String) session.getAttribute("socialId");
			String email = (String) session.getAttribute("socialEmail");
			String defaultName = (String) session.getAttribute("socialName");
			Integer loginType = (Integer) session.getAttribute("socialLoginType");

			if (socialId == null || email == null || loginType == null) {
//				logger.warn("registerSocialUser.do: Missing social user data in session");
				model.addAttribute("message", "소셜 사용자 정보가 유효하지 않습니다.");
				return "user/login";
			}

			User newUser = new User();
			String prefix = loginType == 3 ? "google_" : loginType == 4 ? "naver_" : "kakao_";
			String baseId = prefix + socialId.substring(0, Math.min(10, socialId.length()));
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

			// 랜덤 비밀번호 생성 및 암호화
			String randomPassword = generateRandomPassword();
			newUser.setUserPwd(bcryptPasswordEncoder.encode(randomPassword));
//			logger.debug("registerSocialUser.do: Generated random password for userId = {}", userId);

			userservice.registerUser(newUser);
//			logger.info("registerSocialUser.do: New social user registered, userId = {}", newUser.getUserId());

			session.setAttribute("loginUser", newUser);

			session.removeAttribute("socialId");
			session.removeAttribute("socialEmail");
			session.removeAttribute("socialName");
			session.removeAttribute("socialLoginType");

			return "redirect:/main.do";
		} catch (Exception e) {
//			logger.error("registerSocialUser.do: Error registering social user", e);
			model.addAttribute("message", "회원가입 중 오류가 발생했습니다: " + e.getMessage());
			return "user/registerSocialUser";
		}
	}
	//마이페이지 비밀번호 확인
	//실시간 비밀번호 확인 method
	@RequestMapping(value = "checkPassword.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkPassword(@RequestBody Map<String, String> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null) {
//				logger.warn("checkPassword.do: No user in session");
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return response;
			}

			if (Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//				logger.info("checkPassword.do: Social login user (type={}) cannot change password",
//						loginUser.getUserLoginType());
				response.put("success", false);
				response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
				return response;
			}

			String currentPassword = loginUser.getUserPwd();
			if (currentPassword == null || !currentPassword.startsWith("$2a$")) {
//				logger.error("checkPassword.do: Invalid or missing password hash for userId={}", loginUser.getUserId());
				response.put("success", false);
				response.put("message", "현재 비밀번호 정보가 유효하지 않습니다.");
				return response;
			}

			String newPassword = data.get("password");
//			logger.debug("checkPassword.do: Checking password for userId={}, input length={}", loginUser.getUserId(),
//					newPassword != null ? newPassword.length() : 0);

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
//			logger.debug("checkPassword.do: Password comparison result: isSame={}", isSame);
		} catch (Exception e) {
//			logger.error("checkPassword.do: Error checking password", e);
			response.put("success", false);
			response.put("message", "비밀번호 확인 중 오류: " + e.getMessage());
		}
		return response;
	}
	//마이페이지 내용 수정
	@RequestMapping(value = "updateUserProfile.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateUserProfile(@RequestBody Map<String, Object> userData, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null) {
//				logger.warn("updateUserProfile.do: No user in session");
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return response;
			}

			if (userData.get("password") != null && !userData.get("password").toString().isEmpty()
					&& Arrays.asList(3, 4, 5).contains(loginUser.getUserLoginType())) {
//				logger.info("updateUserProfile.do: Social login user (type={}) cannot change password",
//						loginUser.getUserLoginType());
				response.put("success", false);
				response.put("message", "소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.");
				return response;
			}

			if (userData.get("password") != null && !userData.get("password").toString().isEmpty()) {
				String currentPassword = loginUser.getUserPwd();
				if (currentPassword == null || !currentPassword.startsWith("$2a$")) {
//					logger.error("updateUserProfile.do: Invalid or missing password hash for userId={}",
//							loginUser.getUserId());
					response.put("success", false);
					response.put("message", "현재 비밀번호 정보가 유효하지 않습니다.");
					return response;
				}

				if (bcryptPasswordEncoder.matches(userData.get("password").toString(), currentPassword)) {
//					logger.debug("updateUserProfile.do: New password matches current password for userId={}",
//							loginUser.getUserId());
					response.put("success", false);
					response.put("message", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
					return response;
				}
				userData.put("password", bcryptPasswordEncoder.encode(userData.get("password").toString()));
//				logger.debug("updateUserProfile.do: Password encrypted for userId={}", loginUser.getUserId());
			}

			userData.put("userId", loginUser.getUserId());
//			logger.debug("updateUserProfile.do: Updating profile for userId={}, data={}", loginUser.getUserId(),
//					userData);

			userservice.updateUserProfile(userData);

			User updatedUser = userservice.selectUser(loginUser);
			session.setAttribute("loginUser", updatedUser);
//			logger.info("updateUserProfile.do: Profile updated successfully for userId={}", loginUser.getUserId());

			response.put("success", true);
			response.put("message", "업데이트 성공");
		} catch (Exception e) {
//			logger.error("updateUserProfile.do: Error updating profile", e);
			response.put("success", false);
			response.put("message", "업데이트 실패: " + e.getMessage());
		}
		return response;
	}
	//마이페이지 이동
	@RequestMapping("myPage.do")
	public String moveMyPage() {
//		logger.info("moveMyPage: Displaying myPage");
		return "user/myPage";
	}
	//매니저 관리 페이지 이동
	@RequestMapping("changeManage.do")
	public String changeManage(HttpSession session) {
//		logger.info("changeManage: Displaying changeManage page");
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
//			logger.warn("changeManage: Unauthorized access attempt by userId={}",
//					loginUser != null ? loginUser.getUserId() : "null");
			return "redirect:/loginPage.do";
		}
		return "user/changeManage";
	}
	//유저 찾기
	@RequestMapping(value = "checkMaUser.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkMaUser(@RequestBody Map<String, String> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
//				logger.warn("checkMaUser.do: Unauthorized access attempt by userId={}",
//						loginUser != null ? loginUser.getUserId() : "null");
				response.put("success", false);
				response.put("message", "관리자 권한이 필요합니다.");
				return response;
			}

			String userId = data.get("userId");
//			logger.info("checkMaUser.do: Checking userId={}", userId);
			if (userId == null || userId.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "유저 ID를 입력해주세요.");
				return response;
			}

			User user = userservice.selectUserById(userId.trim());
			if (user != null) {
				response.put("success", true);
				response.put("exists", true);
				response.put("message", "존재하는 유저입니다.");
				response.put("userId", user.getUserId());
				response.put("currentAuthority", user.getUserAuthority());
//				logger.debug("checkMaUser.do: User found, userId={}, authority={}", user.getUserId(),
//						user.getUserAuthority());
			} else {
				response.put("success", true);
				response.put("exists", false);
				response.put("message", "존재하지 않는 유저입니다.");
//				logger.debug("checkMaUser.do: User not found, userId={}", userId);
			}
		} catch (Exception e) {
//			logger.error("checkMaUser.do: Error checking user", e);
			response.put("success", false);
			response.put("message", "유저 확인 중 오류: " + e.getMessage());
		}
		return response;
	}
	//권한변경 (1, 유저 / 2, 관리자 / 3, 불량유저 / 4, 탈퇴유저)
	@RequestMapping(value = "updateAuthority.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateAuthority(@RequestBody Map<String, Object> data, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		try {
			User loginUser = (User) session.getAttribute("loginUser");
			if (loginUser == null || !"2".equals(loginUser.getUserAuthority())) {
//				logger.warn("updateAuthority.do: Unauthorized access attempt by userId={}",
//						loginUser != null ? loginUser.getUserId() : "null");
				response.put("success", false);
				response.put("message", "관리자 권한이 필요합니다.");
				return response;
			}

			String userId = (String) data.get("userId");
			String authority = data.get("authority").toString();
//			logger.info("updateAuthority.do: Updating userId={}, authority={}", userId, authority);
			if (userId == null || userId.trim().isEmpty() || authority == null
					|| (!"1".equals(authority) && !"2".equals(authority))) {
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
//			logger.info("updateAuthority.do: Authority updated for userId={}, newAuthority={}", userId, authority);
			response.put("success", true);
			response.put("message", "권한이 성공적으로 변경되었습니다.");
		} catch (Exception e) {
//			logger.error("updateAuthority.do: Error updating authority", e);
			response.put("success", false);
			response.put("message", "권한 변경 중 오류: " + e.getMessage());
		}
		return response;
	}
	//탈퇴하기
	@RequestMapping(value = "exit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> exit(@RequestBody Map<String, Object> data, HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    User loginUser = (User) session.getAttribute("loginUser");

	    if (loginUser != null) {
	        String userId = loginUser.getUserId();
	        String authority = data.get("authority").toString();

	        userservice.updateUserAuthority(userId, authority);

	        session.invalidate(); // 세션 종료
	        response.put("status", "success");
	        response.put("message", "탈퇴 처리 완료");
	    } else {
	        response.put("status", "error");
	        response.put("message", "로그인 정보 없음");
	    }

	    return response;
	}
}