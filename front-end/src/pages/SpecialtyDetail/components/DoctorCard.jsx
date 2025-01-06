import React from 'react';
import DoctorSchedule from './DoctorSchedule';

export default function DoctorCard({
    doctor,
    availableDates,
    selectedDate,
    setSelectedDate,
}) {
    return (
        <div className="border border-gray-200 shadow-sm rounded-lg p-6 bg-white md:p-4">
            <div className="mb-4 flex flex-col md:flex-row items-center gap-4">
                <img
                    src={doctor.doctor_image}
                    alt={doctor.doctor_name}
                    className="w-16 h-16 rounded-full object-cover md:w-12 md:h-12"
                />
                <div className="flex-1">
                    <h3 className="text-xl font-semibold text-primary-600">{doctor.doctor_name}</h3>
                    <p
                        className="text-gray-700 text-sm line-clamp-4 min-h-[5.5rem] max-h-[5.5rem]"
                        title={doctor.doctor_description} // Tooltip hiển thị toàn bộ nội dung
                    >
                        {doctor.doctor_description}
                    </p>
                </div>
            </div>
            <DoctorSchedule
                doctor={doctor}
                availableDates={availableDates}
                selectedDate={selectedDate}  // Ngày riêng cho bác sĩ này
                setSelectedDate={(date) => setSelectedDate(date)}  // Hàm cập nhật ngày cho bác sĩ
            />
        </div>
    );
}