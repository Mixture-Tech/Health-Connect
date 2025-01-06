// DoctorSchedule Component
import React, { useEffect } from 'react';
import TimeButton from '../../../components/Form/Appointment/TimeButton';
import { useNavigate } from 'react-router-dom';
import { useAppointmentContext } from '../../../contexts/appointmentContext';

export default function DoctorSchedule({
    doctor,
    availableDates,
    selectedDate,
    setSelectedDate
}) {
    const navigate = useNavigate();
    const { updateAppointmentData } = useAppointmentContext();

    // Tìm ngày gần nhất có lịch khám
    useEffect(() => {
        if (!selectedDate && availableDates.length > 0) {
            const today = new Date();
            const closestDate = availableDates
                .filter((date) => {
                    // Lọc các ngày sau hoặc bằng hôm nay
                    const dateObj = new Date(date);
                    return dateObj >= today && doctor.schedules.some(
                        (schedule) => schedule.working_date === date
                    );
                })
                .sort((a, b) => new Date(a) - new Date(b))[0]; // Lấy ngày gần nhất

            if (closestDate) {
                setSelectedDate(closestDate);
            }
        }
    }, [selectedDate, availableDates, doctor.schedules, setSelectedDate]);

    const handleBookAppointment = (schedule) => {
        // Cập nhật thông tin đặt lịch 
        updateAppointmentData({
          doctor: {
            id: doctor.doctor_id,
            name: doctor.doctor_name,
            specialization: doctor.specialization_name
          },
          schedule: {
            workingDate: selectedDate,
            startTime: schedule.start_time,
            endTime: schedule.end_time
          }
        });
    
        // Chuyển hướng đến trang đặt lịch
        navigate('/dat-lich');
      };

    const filteredSchedules = doctor.schedules.filter(
        (schedule) => schedule.working_date === selectedDate
    );

    // Lọc ra những ngày có lịch khám cho bác sĩ này
    const availableDaysForDoctor = availableDates.filter((date) =>
        doctor.schedules.some((schedule) => schedule.working_date === date)
    );

    return (
        <div>
            <h4 className="text-center md:text-left font-semibold mb-2">Lịch khám</h4>

            {/* Dropdown cho ngày */}
            <div className="mb-4 text-center md:text-left">
                <label
                    htmlFor={`date-select-${doctor.doctor_name}`}
                    className="block mb-2 text-gray-700"
                >
                    Chọn ngày khám:
                </label>
                <select
                    id={`date-select-${doctor.doctor_name}`}
                    value={selectedDate}
                    onChange={(e) => setSelectedDate(e.target.value)}
                    className="border border-gray-300 rounded px-4 py-2 w-auto"
                >

                    {availableDaysForDoctor.map((date, i) => (
                        <option key={i} value={date}>
                            {new Intl.DateTimeFormat('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }).format(new Date(date))}
                        </option>
                    ))}
                </select>
            </div>

            {/* Hiển thị lịch làm việc nếu có ngày được chọn */}
            {selectedDate && filteredSchedules.length > 0 ? (
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4 mb-2">
                    {filteredSchedules.map((schedule, i) => (
                        <TimeButton
                            key={i}
                            onClick={() => {
                                console.log(`Đặt lịch vào ${selectedDate} lúc ${schedule.start_time}`);
                                handleBookAppointment(schedule);
                            }}
                            className={`flex justify-center items-center w-26 h-12 rounded md:w-20 md:h-8 bg-primary-500 text-white hover:bg-primary-600`}
                        >
                            <span>{`${schedule.start_time.slice(0, 5)} - ${schedule.end_time.slice(0, 5)}`}</span>
                        </TimeButton>
                    ))}
                </div>
            ) : (
                <p>Không có lịch khám cho ngày này</p>
            )}
        </div>
    );
}