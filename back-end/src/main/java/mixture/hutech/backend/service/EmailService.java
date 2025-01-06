package mixture.hutech.backend.service;

import jakarta.mail.MessagingException;

public interface EmailService {
    void sendMailWithTokenRegister(String toEmail, String name, String token) throws MessagingException;
    void sendMailWithTokenResetPassword(String toEmail, String name, String token) throws MessagingException;
    void sendMailAppointmentConfirmation(String toEmail, String name, String doctorName, String appointmentDate, String appointmentTime) throws MessagingException;
    void sendMailAppointmentReminder(String toEmail, String patientName, String doctorName, String appointmentDate, String appointmentTime) throws MessagingException;
}
