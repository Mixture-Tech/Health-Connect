import React from 'react';

export default function Header({ specialityName }) {
    return (
        <section className="mb-8">
            <h1 className="text-4xl font-semibold text-primary-600">{specialityName || 'Chuyên khoa'}</h1>
            <h2 className="text-2xl font-semibold mt-4">Bác sĩ {specialityName || 'Chuyên khoa'} giỏi</h2>
            <h3 className="mt-4 space-y-2 text-gray-700">
                Danh sách các bác sĩ uy tín đầu ngành {specialityName || 'chuyên khoa'} tại Việt Nam:
            </h3>
            <ul className="list-disc list-inside mt-4 space-y-2 text-gray-700 ">
                <li>Các chuyên gia có quá trình đào tạo bài bản, nhiều kinh nghiệm</li>
                <li>Các giáo sư, phó giáo sư đang nghiên cứu và giảng dạy tại Đại học Y khoa Hà Nội</li>
                <li>
                    Các bác sĩ đã, đang công tác tại các bệnh viện hàng đầu như Bệnh viện Bạch Mai, Việt Đức, E
                </li>
                <li>Là thành viên hoặc lãnh đạo các tổ chức chuyên môn</li>
                <li>Được nhà nước công nhận danh hiệu Thầy thuốc Nhân dân, Thầy thuốc Ưu tú,...</li>
            </ul>
        </section>
    );
}
