import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function AppointmentSuccessfully() {
    const navigate = useNavigate(); // Khởi tạo hook useNavigate

    const handleButtonClick = () => {
        navigate('/chi-tiet-lich-hen'); // Chuyển hướng đến đường dẫn
    };

    return (
        <div className="flex flex-col items-center justify-center min-h-[calc(100vh-100px)] bg-white p-10 text-center">
            <div className="text-5xl text-green-500 mb-5">
                ✔ {/* Dùng dấu check hoặc có thể thay thế bằng icon nếu cần */}
            </div>
            <h2 className="text-green-500 text-2xl font-bold">Đặt khám thành công!</h2>
            <p className="text-sm text-gray-700 mt-4">
                Lưu ý: Lịch hẹn của quý khách đã chuyển sang cơ sở y tế. Vui lòng không đặt lịch qua kênh khác để tránh trùng lịch.
            </p>
            <button
                onClick={handleButtonClick} // Gắn sự kiện click vào nút
                className="bg-yellow-500 text-white py-2 px-5 mt-6 text-lg rounded hover:bg-yellow-600 focus:outline-none"
            >
                Xem chi tiết lịch hẹn tại đây
            </button>
        </div>
    );
}
