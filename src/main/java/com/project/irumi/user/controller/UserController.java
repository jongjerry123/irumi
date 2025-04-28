package com.project.irumi.user.controller;

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
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.Message.RecipientType;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Date;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Controller
public class UserController {
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);
    private static final String APPLICATION_NAME = "Your Application Name";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final String CREDENTIALS_FILE_PATH = "/credentials.json";
    private static final String FROM_EMAIL = "yourapp@gmail.com"; // 실제 Gmail 계정으로 변경

    @Autowired
    private UserService userservice;

    @Autowired
    private BCryptPasswordEncoder bcryptPasswordEncoder;

    private Gmail gmailService;

    public UserController() {
        try {
            final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            gmailService = new Gmail.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
                    .setApplicationName(APPLICATION_NAME)
                    .build();
            logger.info("GmailService initialized successfully");
        } catch (Exception e) {
            logger.error("Failed to initialize GmailService", e);
        }
    }

    private Credential getCredentials(final NetHttpTransport HTTP_TRANSPORT) throws Exception {
        InputStream in = UserController.class.getResourceAsStream(CREDENTIALS_FILE_PATH);
        if (in == null) {
            throw new IllegalStateException("Credentials file not found at: " + CREDENTIALS_FILE_PATH);
        }
        try (InputStreamReader reader = new InputStreamReader(in)) {
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, reader);
            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, Collections.singletonList("https://www.googleapis.com/auth/gmail.send"))
                    .setDataStoreFactory(new FileDataStoreFactory(new java.io.File("tokens")))
                    .setAccessType("offline")
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

    private Message createMessageWithEmail(MimeMessage emailContent) throws Exception {
        java.io.ByteArrayOutputStream buffer = new java.io.ByteArrayOutputStream();
        emailContent.writeTo(buffer);
        byte[] bytes = buffer.toByteArray();
        String encodedEmail = java.util.Base64.getUrlEncoder().encodeToString(bytes);
        Message message = new Message();
        message.setRaw(encodedEmail);
        return message;
    }

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
        session.invalidate();
        return "redirect:/";
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

    @PostMapping("checkEmail.do")
    @ResponseBody
    public Map<String, Object> checkEmail(@RequestParam(name = "email") String email) {
        logger.info("checkEmail.do: Checking email = {}", email);
        boolean available = userservice.checkEmailAvailability(email);
        Map<String, Object> response = new HashMap<>();
        response.put("available", available);
        response.put("message", available ? "사용 가능한 이메일입니다." : "이미 가입되어 있는 유저입니다.");
        return response;
    }

    @PostMapping("sendVerification.do")
    @ResponseBody
    public Map<String, Object> sendVerification(@RequestParam("email") String email, HttpSession session) {
        logger.info("sendVerification.do: Received email = {}", email);
        Map<String, Object> response = new HashMap<>();
        try {
            if (gmailService == null) {
                throw new IllegalStateException("Gmail service is not initialized");
            }
            String code = String.valueOf((int)(Math.random() * 900000) + 100000);
            long currentTime = System.currentTimeMillis();
            Date expiry = new Date(currentTime + 5 * 60 * 1000);

            String subject = "이메일 인증번호";
            String body = "인증번호: " + code + "\n이 코드는 5분 동안 유효합니다.";
            logger.info("sendVerification.do: Sending email to = {}, subject = {}", email, subject);

            MimeMessage emailMessage = createEmail(email, FROM_EMAIL, subject, body);
            Message message = createMessageWithEmail(emailMessage);
            gmailService.users().messages().send("me", message).execute();

            session.setAttribute("verificationCode", code);
            session.setAttribute("verificationEmail", email);
            session.setAttribute("emailTokenExpiry", expiry);
            logger.info("sendVerification.do: Verification code sent to email = {}", email);

            response.put("success", true);
            response.put("message", "인증번호가 전송되었습니다.");
        } catch (Exception e) {
            logger.error("sendVerification.do: Error sending verification email = {}", email, e);
            response.put("success", false);
            response.put("message", "인증번호 전송 실패: " + e.getMessage());
        }
        return response;
    }

    @GetMapping("verifyCode.do")
    public String handleGetVerifyCode() {
        logger.warn("verifyCode.do: GET method not supported, redirecting to registration page");
        return "redirect:/resister.do";
    }

    @PostMapping("verifyCode.do")
    @ResponseBody
    public Map<String, Object> verifyCode(@RequestParam(name = "code") String code, HttpSession session) {
        logger.info("verifyCode.do: Received code = {}", code);
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
            logger.error("verifyCode.do: Error verifying code", e);
            response.put("success", false);
            response.put("message", "인증 실패: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("registerUser.do")
    @ResponseBody
    public Map<String, Object> register(@RequestBody User user, HttpSession session) {
        logger.info("registerUser.do: Received user = {}", user);
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
            logger.info("registerUser.do: User registered successfully, userId = {}", user.getUserId());
            response.put("success", true);
            response.put("message", "회원가입이 완료되었습니다.");
            session.removeAttribute("emailVerified");
            session.removeAttribute("verificationCode");
            session.removeAttribute("verificationEmail");
            session.removeAttribute("emailTokenExpiry");
        } catch (Exception e) {
            logger.error("registerUser.do: Registration error for userId = {}", user.getUserId(), e);
            response.put("success", false);
            response.put("message", "회원가입 실패: " + e.getMessage());
        }
        return response;
    }
    
    @RequestMapping("findId.do")
    public String goToFindId() {
        logger.info("goToFindId: Displaying findId page");
        return "user/findId";
    }
    @RequestMapping("showId.do")
    public String goToShowId() {
        logger.info("goToFindId: Displaying findId page");
        return "user/findId";
    }
 // showId.do에서 이메일로 아이디 조회 후 showId.jsp로 전달
    @GetMapping("showId.do")
    public String showId(@RequestParam(name = "email") String email, Model model) {
        logger.info("showId.do: Finding userId for email = {}", email);
        String userId = userservice.findIdByEmail(email);
        model.addAttribute("userId", userId);
        return "user/showId";
    }
    @RequestMapping("findPassword.do")
    public String goTofindPassword() {
        logger.info("goTofindPassword: Displaying findPassword page");
        return "user/findPassword";
    }
 // 추가: 아이디와 이메일 일치 확인
    @PostMapping("checkUser.do")
    @ResponseBody
    public Map<String, Object> checkUser(
            @RequestParam(name = "userId") String userId,
            @RequestParam(name = "email") String email) {
        logger.info("checkUser.do: Checking userId = {}, email = {}", userId, email);
        boolean matched = userservice.checkUserMatch(userId, email);
        Map<String, Object> response = new HashMap<>();
        response.put("matched", matched);
        response.put("message", matched ? "아이디와 이메일이 일치합니다." : "아이디와 이메일이 일 고맙습니다.");
        return response;
    }

    // 추가: 비밀번호 재설정 페이지 이동
    @GetMapping("resetPassword.do")
    public String resetPassword(
            @RequestParam(name = "userId") String userId,
            HttpSession session,
            Model model) {
        logger.info("resetPassword.do: Processing for userId = {}", userId);
        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
        if (emailVerified != null && emailVerified) {
            model.addAttribute("userId", userId);
            return "user/resetPassword"; // resetPassword.jsp로 이동
        } else {
            logger.warn("resetPassword.do: Email not verified for userId = {}", userId);
            return "redirect:/findPassword.do";
        }
    }
    @PostMapping("updatePassword.do")
    public String updatePassword(
            @RequestParam(name = "userId") String userId,
            @RequestParam(name = "newPassword") String newPassword,
            HttpSession session,
            Model model) {
        logger.info("updatePassword.do: Updating password for userId = {}", userId);
        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
        if (emailVerified != null && emailVerified) {
            try {
                userservice.updatePassword(userId, bcryptPasswordEncoder.encode(newPassword));
                session.removeAttribute("emailVerified");
                session.removeAttribute("verificationCode");
                session.removeAttribute("verificationEmail");
                session.removeAttribute("emailTokenExpiry");
                model.addAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
                return "user/login";
            } catch (Exception e) {
                logger.error("updatePassword.do: Error updating password for userId = {}", userId, e);
                model.addAttribute("message", "비밀번호 변경 중 오류가 발생했습니다.");
                return "user/resetPassword";
            }
        } else {
            logger.warn("updatePassword.do: Email not verified for userId = {}", userId);
            return "redirect:/findPassword.do";
        }
    }
}