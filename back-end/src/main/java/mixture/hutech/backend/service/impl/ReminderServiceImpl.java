package mixture.hutech.backend.service.impl;

import jakarta.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import mixture.hutech.backend.entity.Appointment;
import mixture.hutech.backend.enums.AppointmentStatusEnum;
import mixture.hutech.backend.repository.AppointmentRepository;
import mixture.hutech.backend.service.EmailService;
import mixture.hutech.backend.service.ReminderService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReminderServiceImpl implements ReminderService {

    private final AppointmentRepository appointmentRepository;
    private final EmailService emailService;

    @Override
    @Scheduled(fixedRate = 3600000)
    public void sendAppointmentReminder() {
        LocalTime now = LocalTime.now();
        LocalTime reminderTime = LocalTime.from(now.plusHours(12));

        List<Appointment> upcomingAppointments = appointmentRepository.findUpcomingAppointments(
                now,
                reminderTime,
                AppointmentStatusEnum.CONFIRMED
        );

        for (Appointment appointment : upcomingAppointments) {
            try{
                sendReminderEmail(appointment);
                appointment.setReminderSent(true);
                appointmentRepository.save(appointment);
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void sendReminderEmail(Appointment appointment) throws MessagingException {
        String recipientEmail = appointment.getUser().getEmail();
        String patientName = appointment.getUser().getUsername();
        String doctorName = appointment.getDoctorSchedule().getUser().getUsername();
        String appointmentDate = appointment.getAppointmentTakenDate().toString();
        String appointmentTime = appointment.getProbableStartTime().toString() + appointment.getActualEndTime().toString();

        emailService.sendMailAppointmentReminder(
                recipientEmail,
                patientName,
                doctorName,
                appointmentDate,
                appointmentTime
        );
    }
}
