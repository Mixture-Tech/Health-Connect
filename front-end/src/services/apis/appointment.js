import axiosClient from './axiosClient';

export const AppointmentService = {
    createAppointment: async (doctorId, appointmentData) => {
        try {
            // Xác định loại đặt lịch (SELF_BOOKING hoặc OTHER_BOOKING)
            const bookingType = appointmentData.patientType === 'Đặt cho mình'
                ? 'SELF_BOOKING'
                : 'OTHER_BOOKING';

            // Chuẩn bị dữ liệu request phù hợp với cấu trúc backend
            const requestData = {
                // Ngày khám
                appointmentTakenDate: appointmentData.appointmentDate,

                // Thời gian bắt đầu và kết thúc
                startTime: appointmentData.startTime,
                endTime: appointmentData.endTime,

                // Loại đặt lịch
                bookingType: bookingType,

                // Thông tin bệnh nhân
                patientName: appointmentData.patientName,
                patientPhone: appointmentData.patientPhone,

                // Địa chỉ được ghép từ các trường ward, district, province
                patientAddress: `${appointmentData.ward}, ${appointmentData.district}, ${appointmentData.province}`,

                patientDateOfBirth: appointmentData.dateOfBirth,
                patientGender: appointmentData.gender,
                patientEmail: appointmentData.email
            };

            console.log('Dữ liệu request đặt lịch:', requestData);

            // Gọi API đặt lịch với doctorId và dữ liệu request
            const response = await axiosClient.post(`/appointments/${doctorId}`, requestData);

            // Trả về dữ liệu phản hồi từ server
            return response.data;
        } catch (error) {
            // Xử lý lỗi và log chi tiết
            console.error('Lỗi khi đặt lịch:', error);
            throw error;
        }
    },

    // Phương thức lấy danh sách lịch hẹn
    listAppointments: async () => {
        try {
            const response = await axiosClient.get('/appointments');
            return response.data;
        } catch (error) {
            console.error('Lỗi khi lấy danh sách lịch hẹn:', error);
            throw error;
        }
    },

    cancelAppointment: async (appointmentId, userEmail) => {
        try {
            const response = await axiosClient.post(`/appointments/${appointmentId}/cancel`, {
                email: userEmail,
            });
            return response.data; // Trả về dữ liệu từ API
        } catch (error) {
            throw error; // Xử lý lỗi nếu có
        }
    },

};
