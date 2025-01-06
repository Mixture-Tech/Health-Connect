import React, { useState } from "react";
import DoctorInfo from "./components/DoctorInfo";
import ScheduleSelector from "./components/ScheduleSelector";
import TimeSlots from "./components/TimeSlots";
import AddressAndPrice from "./components/AddressAndPrice";

export default function DoctorSchedule() {
  const initialSchedule = [
    { time: "08:30 - 09:00", status: "available" },
    { time: "09:00 - 09:30", status: "unavailable" },
    { time: "09:30 - 10:00", status: "available" },
    { time: "15:30 - 16:00", status: "unavailable" },
    { time: "16:00 - 16:30", status: "available" },
    { time: "16:30 - 17:00", status: "available" },
  ];

  const today = new Date();
  const formatDate = (date) => date.toISOString().split("T")[0];
  const availableDates = Array.from({ length: 7 }, (_, i) =>
      formatDate(new Date(today.setDate(today.getDate() + i)))
  );

  const [selectedDate, setSelectedDate] = useState(availableDates[0]);
  const [schedule, setSchedule] = useState(initialSchedule);

  const doctorInfo = {
    name: "Bác sĩ chuyên khoa II Phan Duy Kiên",
    description: [
      "Hơn 10 năm kinh nghiệm trong lĩnh vực phẫu thuật Lồng ngực - Tim mạch - Mạch máu, điều trị vết thương mạn tính khó lành",
      "Bác sĩ khoa Phẫu thuật mạch máu Bệnh viện Chợ Rẫy",
      "Thành viên Ban Hội đồng cố vấn y khoa, Trung tâm Y khoa Chuyên sâu quốc tế Bernard",
      "Bác sĩ chỉ nhận khám trường hợp ngoại Tim mạch - Lồng ngực",
      "Bác sĩ nhận khám từ 15 tuổi trở lên",
    ],
    location: "Hệ thống Y khoa Chuyên sâu Quốc tế BERNARD (Quận Tân Bình)",
    address: "22 Phan Đình Giót, Quận Tân Bình, TP. HCM",
    price: "500.000đ",
    imageUrl: "https://cdn.bookingcare.vn/fo/w256/2022/02/28/155511-bs-kien.png",
  };

  const handleDateChange = (event) => {
    const date = event.target.value;
    setSelectedDate(date);
    const newSchedule = initialSchedule.map((slot) => ({
      ...slot,
      status: Math.random() > 0.5 ? "available" : "unavailable",
    }));
    setSchedule(newSchedule);
  };

  return (
      <div className="p-4 max-w-4xl mx-auto">
        <DoctorInfo doctorInfo={doctorInfo} />
        <div className="mt-4">
          <h2 className="text-lg font-semibold text-center md:text-left">LỊCH KHÁM</h2>
          <ScheduleSelector
              availableDates={availableDates}
              selectedDate={selectedDate}
              onDateChange={handleDateChange}
          />
          <TimeSlots schedule={schedule} selectedDate={selectedDate} />
        </div>
        <AddressAndPrice doctorInfo={doctorInfo} />
      </div>
  );
}
