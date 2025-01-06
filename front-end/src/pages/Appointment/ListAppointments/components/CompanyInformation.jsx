import React from 'react';
import { FaMapMarkerAlt, FaPhoneAlt, FaEnvelope } from 'react-icons/fa';

export default function CompanyInformation() {
    return (
        <div className="flex justify-between p-5 bg-gray-100 text-sm">
            {/* Left Section - Company Information */}
            <div className="w-[45%]">
                <h3 className="font-bold text-lg">Công ty Cổ phần Công nghệ BookingCare</h3>
                <div className="flex items-center mb-2">
                    <FaMapMarkerAlt className="mr-2 text-teal-500" />
                    10/80c Song Hành Xa Lộ Hà Nội, Phường Tân Phú, Quận 9, Hồ Chí Minh
                </div>
                <div className="flex items-center mb-2">
                    <FaMapMarkerAlt className="mr-2 text-teal-500" />
                    ĐKKD số: 0106790291. Sở KHĐT TP.Hồ Chí Minh cấp ngày 16/03/2024
                </div>
                <div className="flex items-center mb-2">
                    <FaPhoneAlt className="mr-2 text-teal-500" />
                    024-7301-2468 (7h - 16h)
                </div>
                <div className="flex items-center mb-2">
                    <FaEnvelope className="mr-2 text-teal-500" />
                    HealthConnect@gmail.vn (7h - 16h)
                </div>
                <h4 className="font-bold mt-5">Văn phòng tại TP Hồ Chí Minh</h4>
                <div className="flex items-center mb-2">
                    <FaMapMarkerAlt className="mr-2 text-teal-500" />
                    Tòa nhà H3, 384 Hoàng Diệu, Phường 6, Quận 4, TP.HCM
                </div>
                <div className="flex items-center mt-5">
                    <span>Tải ứng dụng HealthConnect cho điện thoại hoặc máy tính bảng:</span>
                    <a href="#" className="text-teal-500 ml-2 hover:underline">Android</a> -
                    <a href="#" className="text-teal-500 ml-2 hover:underline">iPhone/iPad</a> -
                    <a href="#" className="text-teal-500 ml-2 hover:underline">Khác</a>
                </div>
            </div>

            {/* Middle Section - Support Links */}
            <div className="w-[20%]">
                <h4 className="font-bold">Hỗ trợ</h4>
                <ul className="list-none p-0 leading-relaxed">
                    <li><a href="#" className="text-teal-500 hover:underline">Liên hệ hợp tác</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Chuyển đổi số</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Chính sách bảo mật</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Quy chế hoạt động</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Tuyển dụng</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Điều khoản sử dụng</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Câu hỏi thường gặp</a></li>
                    <li><a href="#" className="text-teal-500 hover:underline">Sức khỏe doanh nghiệp</a></li>
                </ul>
            </div>

            {/* Right Section - Partners */}
            <div className="w-[30%]">
                <h4 className="font-bold">Đối tác bảo trợ nội dung</h4>
                <div className="mb-2">
                    <strong>Hello Doctor</strong><br />
                    Bảo trợ chuyên mục nội dung "sức khỏe tinh thần"
                </div>
                <div className="mb-2">
                    <strong>Hệ thống y khoa chuyên sâu quốc tế Bernard</strong><br />
                    Bảo trợ chuyên mục nội dung "y khoa chuyên sâu"
                </div>
                <div className="mb-2">
                    <strong>Doctor Check - Tầm Soát Bệnh Để Sống Thọ Hơn</strong><br />
                    Bảo trợ chuyên mục nội dung "sức khỏe tổng quát"
                </div>
            </div>
        </div>
    );
}
