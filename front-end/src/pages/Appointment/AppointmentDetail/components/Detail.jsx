import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Button from '../../../../components/Form/Button';
import { AppointmentService } from '../../../../services/apis/appointment';
import { StorageKeys } from "../../../../services/key/keys";
import { ToastContainer, toast } from 'react-toastify';  // Import toastify
import 'react-toastify/dist/ReactToastify.css';  // Import CSS của toastify

export default function AppointmentDetail() {
    const { appointmentId } = useParams();  // Lấy ID lịch hẹn từ URL
    const [appointmentDetails, setAppointmentDetails] = useState(null);  // Lưu trữ thông tin lịch hẹn
    const [loading, setLoading] = useState(true);  // Quản lý trạng thái loading
    const [error, setError] = useState(null);  // Quản lý lỗi khi gọi API

    useEffect(() => {
        const fetchAppointmentDetails = async () => {
            console.log("Fetching appointment details for appointmentId:", appointmentId);

            try {
                const response = await AppointmentService.listAppointments();
                console.log('Full API Response:', response);

                if (response && Array.isArray(response)) {
                    const selectedAppointment = response.find(
                        (item) => item.appointment_id === appointmentId
                    );

                    if (selectedAppointment) {
                        setAppointmentDetails(selectedAppointment);
                    } else {
                        setError('Lịch hẹn không tồn tại');
                    }
                } else {
                    setError('Không nhận được dữ liệu từ API');
                }
            } catch (error) {
                console.error('Error fetching appointment details:', error);
                setError('Có lỗi xảy ra khi lấy thông tin lịch hẹn');
            } finally {
                setLoading(false);
            }
        };

        fetchAppointmentDetails();
    }, [appointmentId]);

    const handleCancelClick = async () => {
        const userEmail = localStorage.getItem(StorageKeys.USER_EMAIL);
        console.log('Lấy email từ localStorage:', userEmail); // Log để kiểm tra email

        if (!userEmail || userEmail.trim() === "") {
            console.error('Email người dùng không tồn tại trong localStorage hoặc là chuỗi rỗng');
            toast.error('Không thể hủy lịch hẹn vì email không tồn tại.');  // Hiển thị thông báo lỗi
            return;
        }

        try {
            console.log('Bắt đầu hủy lịch hẹn với ID:', appointmentId);
            const response = await AppointmentService.cancelAppointment(appointmentId, userEmail); // Gọi API hủy lịch hẹn
            console.log('Phản hồi từ API hủy lịch hẹn:', response); // Log kết quả trả về từ API

            // Kiểm tra nếu trạng thái trong phản hồi là "CANCELLED"
            if (response && response.status === 'CANCELLED') {
                console.log('Lịch hẹn đã được hủy thành công:', response);
                toast.success('Lịch hẹn đã bị hủy thành công.');  // Thông báo thành công

                // Cập nhật lại thông tin lịch hẹn sau khi hủy
                setAppointmentDetails((prevDetails) => ({
                    ...prevDetails,
                    status: 'CANCELLED',
                }));
            } else {
                console.log('Không thể hủy lịch hẹn, phản hồi không hợp lệ:', response);
                toast.error('Không thể hủy lịch hẹn.');  // Thông báo lỗi khi không thể hủy
            }
        } catch (error) {
            console.error('Có lỗi xảy ra khi hủy lịch hẹn:', error); // Log lỗi nếu có khi hủy lịch
            toast.error('Có lỗi xảy ra khi hủy lịch hẹn.');  // Thông báo lỗi khi có sự cố
        }
    };

    if (loading) {
        return <div>Đang tải...</div>;
    }

    if (error) {
        return <div>{error}</div>;
    }

    return (
        <>
            {/* Phần tiêu đề */}
            <div className="text-lg font-bold mb-4 bg-gray-200 p-4 rounded-md text-center">
                Chi tiết lịch hẹn
            </div>

            {/* Phần chi tiết lịch hẹn */}
            <div className="space-y-4 text-base text-gray-600">
                <div className="flex items-start">
                    <span className="font-semibold w-32">Bác sĩ:</span>
                    <span className="text-gray-800">{appointmentDetails.doctor_name}</span>
                </div>
                <div className="flex items-start">
                    <span className="font-semibold w-32">Thời gian:</span>
                    <span className="text-gray-800">{appointmentDetails.start_time} - {appointmentDetails.end_time}</span>
                </div>
                <div className="flex items-start">
                    <span className="font-semibold w-32">Ngày đặt lịch:</span>
                    <span className="text-gray-800">{appointmentDetails.taken_date}</span>
                </div>
                <div className="flex items-start">
                    <span className="font-semibold w-32">Ngày tạo:</span>
                    <span className="text-gray-800">{appointmentDetails.created_at}</span>
                </div>
                <div className="flex items-start">
                    <span className="font-semibold w-32">Trạng thái:</span>
                    <span
                        className={`font-semibold ${appointmentDetails.status === 'CANCELLED' ? 'text-red-600' : 'text-green-600'}`}
                    >
                        {appointmentDetails.status === 'CONFIRMED'
                            ? 'Đặt lịch thành công'
                            : appointmentDetails.status === 'CANCELLED'
                                ? 'Đã hủy lịch'
                                : 'Chưa xác nhận'}
                    </span>
                </div>

            </div>

            {/* Chỉ hiển thị phần hủy lịch nếu trạng thái là "CONFIRMED" */}
            {appointmentDetails.status === 'CONFIRMED' && (
                <div className="bg-red-50 border border-red-300 text-red-600 rounded-lg p-6 mt-8 mx-auto max-w-xl mt-6 mb-12">
                    <div className="flex items-center justify-center mb-4">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            strokeWidth="2"
                            stroke="currentColor"
                            className="w-8 h-8 text-red-500"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                d="M12 9v3m0 4h.01m-6.938 4h13.856C19.745 20 21 18.745 21 17.304V6.697C21 5.255 19.745 4 18.304 4H5.697C4.255 4 3 5.255 3 6.697v10.607C3 18.745 4.255 20 5.697 20z"
                            />
                        </svg>
                        <span className="ml-3 text-lg font-bold">Bạn có chắc chắn muốn hủy lịch hẹn?</span>
                    </div>
                    <p className="text-center text-sm text-gray-600 mb-6">
                        Nếu bạn hủy lịch, bạn sẽ không nhận được thông báo từ hệ thống và có thể ảnh hưởng đến lịch khám của bác sĩ.
                    </p>
                    <div className="flex justify-center">
                        <Button
                            onClick={handleCancelClick}
                            className="bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-lg shadow-lg transition-all duration-200"
                        >
                            Hủy lịch hẹn
                        </Button>
                    </div>
                </div>
            )}

            {/* Thêm ToastContainer vào cuối JSX để render thông báo */}
            <ToastContainer />
        </>
    );
}
