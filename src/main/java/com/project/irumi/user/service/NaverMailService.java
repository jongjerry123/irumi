package com.project.irumi.user.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class NaverMailService {
    private static final Logger logger = LoggerFactory.getLogger(NaverMailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${naver.mail.sender-email}")
    private String senderEmail;

    public void sendEmail(String recipientEmail, String subject, String body) throws MessagingException {
        try {
            // MIME 메시지 생성
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            // 이메일 설정
            helper.setFrom(senderEmail);
            helper.setTo(recipientEmail);
            helper.setSubject(subject);
            helper.setText(body, false); // HTML 여부 (false: plain text)

            // 이메일 전송
            mailSender.send(message);
            logger.info("Email sent successfully to {}", recipientEmail);
        } catch (MailException | MessagingException e) {
            logger.error("Failed to send email to {}: {}", recipientEmail, e.getMessage());
            throw new MessagingException("Failed to send email: " + e.getMessage(), e);
        }
    }
}