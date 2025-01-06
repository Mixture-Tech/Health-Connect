import React from 'react';
import { FaClock, FaCalendarAlt } from 'react-icons/fa';
import { useAppointmentContext } from '../../../../contexts/appointmentContext';
import doctorImage from '../../../../assets/images/doctors/dang-van-ha.png'

export default function DoctorReferral() {
    const { appointmentData } = useAppointmentContext(); // Lấy thông tin từ context
    console.log("appointmentData:", appointmentData);
    return (
        <div className="w-full bg-[#F5F5F5] py-4 px-5 flex justify-center border border-gray-300">
            <div className="flex items-center max-w-screen-lg">
                <img
                    // src={appointmentData.doctor?.image || 'default-image.jpg'}
                    src={doctorImage}
                    alt={appointmentData.doctor?.name || 'Bác sĩ'}
                    className="w-28 h-28 rounded-full mr-4"
                />
                <div>
                    <h2 className="text-xl text-secondary">ĐẶT LỊCH KHÁM</h2>
                    <h3 className="text-lg font-semibold text-primary-700">BS. {appointmentData.doctor?.name}</h3>
                    <p className="my-1 text-[#ff9900] flex items-center">
                        <FaClock className="mr-2" />
                        {appointmentData.schedule?.startTime} - {appointmentData.schedule?.endTime}
                    </p>
                    <p className="my-1 text-[#ff9900] flex items-center">
                        <FaCalendarAlt className="mr-2" />
                        {appointmentData.schedule?.workingDate 
                            ? new Intl.DateTimeFormat('vi-VN').format(new Date(appointmentData.schedule.workingDate)) 
                            : 'Chưa chọn ngày'}
                    </p>
                </div>
            </div>
        </div>
    );
}
