package mixture.hutech.backend.service.impl;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.service.EmailService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {
    private final JavaMailSender mailSender;
    private final TemplateEngine templateEngine;

//    @Value("${application.frontend.url}")
    private String frontendUrl = "http://localhost:8080";

    private void sendEmail(String toEmail, String subject, String templateName, Context thymeleafContext) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(toEmail);
        mimeMessageHelper.setSubject(subject);

        String htmlBody = templateEngine.process(templateName, thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    @Override
    public void sendMailWithTokenRegister(String toEmail, String name, String token) throws MessagingException {
        Context context = new Context();
        context.setVariable("title", "Xác nhận đăng ký tài khoản thành công");
        context.setVariable("message", "Chào bạn, \n\nChúng tôi đã nhận được yêu cầu đăng ký tài khoản của bạn. Để hoàn tất quá trình đăng ký và sử dụng dịch vụ đặt lịch hẹn khám bệnh của chúng tôi, vui lòng xác nhận địa chỉ email của bạn bằng cách nhấp vào liên kết bên dưới.");
        // Thay đổi URL để trỏ đến endpoint mới
        context.setVariable("url", frontendUrl + "/api/auth/direct-verify/" + token);
        context.setVariable("name", name);
        context.setVariable("textBtn", "Kích hoạt tài khoản");

        sendEmail(toEmail, "Đăng ký thành công", "mail-authenticate", context);
    }

    @Override
    public void sendMailWithTokenResetPassword(String toEmail, String name, String token) throws MessagingException {
        Context context = new Context();
        context.setVariable("title", "Quên mật khẩu");
        context.setVariable("message", "Mật khẩu mới của bạn là: " + token);
        context.setVariable("name", name);
        context.setVariable("showBtn", false);

        sendEmail(toEmail, "Quên mật khẩu", "mail-authenticate", context);
    }

    @Override
    public void sendMailAppointmentConfirmation(String toEmail, String name, String doctorName, String appointmentDate, String appointmentTime) throws MessagingException {
        Context context = new Context();
        context.setVariable("title", "Xác nhận đặt lịch hẹn khám bệnh");
        context.setVariable("patientName", name);
        context.setVariable("doctorName", doctorName);
        context.setVariable("appointmentDate", appointmentDate);
        context.setVariable("appointmentTime", appointmentTime);
        context.setVariable("message", "Lịch hẹn khám bệnh của bạn đã được xác nhận thành công. Chi tiết lịch hẹn như sau:");
        context.setVariable("url", frontendUrl + "/appointments");
        context.setVariable("textBtn", "Xem chi tiết lịch hẹn");
        context.setVariable("isConfirmation", true);

        sendEmail(toEmail, "Xác nhận đặt lịch hẹn", "mail-appointment", context);
    }

    @Override
    public void sendMailAppointmentReminder(String toEmail, String patientName, String doctorName, String appointmentDate, String appointmentTime) throws MessagingException {
        Context context = new Context();
        context.setVariable("title", "Nhắc nhở: Cuộc hẹn sắp tới của bạn");
        context.setVariable("patientName", patientName);
        context.setVariable("doctorName", doctorName);
        context.setVariable("appointmentDate", appointmentDate);
        context.setVariable("appointmentTime", appointmentTime);
        context.setVariable("message", "Đây là lời nhắc bạn có một cuộc hẹn sắp tới. Chi tiết cuộc hẹn như sau:");
        context.setVariable("url", frontendUrl + "/appointments");
        context.setVariable("textBtn", "Xem chi tiết lịch hẹn");
        context.setVariable("isReminder", true);

        sendEmail(toEmail, "Nhắc nhở: Cuộc hẹn sắp tới của bạn", "mail-appointment", context);
    }
}