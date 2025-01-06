package mixture.hutech.backend.service;

import mixture.hutech.backend.dto.request.AppointmentRequest;
import mixture.hutech.backend.dto.response.AppointmentResponse;
import mixture.hutech.backend.entity.Appointment;

import java.util.List;

public interface AppointmentService {
    AppointmentResponse createAppointment(AppointmentRequest request, String userEmail);
    AppointmentResponse cancelAppointment(String appointmentId, String userEmail);
    List<AppointmentResponse> listAppointmentByUser(String userEmail);
}
