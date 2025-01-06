import React from 'react';
<<<<<<< HEAD
import Button from '../../Form/Button/index';

export default function Banner() {
  return (
    <div className="relative h-screen">
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: `url(${require('../../../assets/images/background.jpg')})` }}
      />
      <div className="relative z-10 h-full flex flex-col items-start justify-center text-primary-1000 px-12">
        <h1 className="text-lg font-semibold mb-4">GIẢI PHÁP CHĂM SÓC SỨC KHỎE TOÀN DIỆN</h1>
        <h2 className="text-5xl font-semibold mb-2" style={{ lineHeight: '1.2' }}>NGƯỜI BẠN ĐỒNG HÀNH <br/>ĐÁNG TIN CẬY NHẤT VỀ SỨC KHOẺ</h2>
        <p className="text-sm text-lg mb-8 ">
        Chúng tôi mang đến nền tảng kết nối người dùng với các chuyên gia y tế hàng đầu, giúp bạn quản lý sức khỏe
        hiệu quả và tiện lợi hơn bao giờ hết. <br/> Đặt lịch hẹn, nhận tư vấn và theo dõi sức khỏe chỉ với vài cú click chuột.
        </p>
        <Button variant="secondary" onClick={() => console.log('Secondary button clicked')}>
          MAKE AN APPOINTMENT
        </Button>
      </div>
    </div>
  );
=======
import Button from '@mui/material/Button'
import BackgroundImage from '../../../assets/images/background.png';

export default function Header() {
    return (
            <div>
                <img src={BackgroundImage} alt="Background" className="absolute top-0 left-0 w-full h-full object-cover" />
                <div className="absolute top-0 left-0 w-full h-full bg-gray-800 opacity-50"></div>
                <div className="absolute inset-0 flex flex-col justify-center items-center text-white text-center">
                    <h1 className="text-5xl font-bold mb-4">Avoid Hassles & Delays.</h1>
                    <p className="mb-4">Don't worry. Find your doctor online. Book as you wish with eDoc.</p>
                    <p className="mb-6">We offer you a free doctor channeling service. Make your appointment now.</p>
                    <Button className="!bg-blue-500 !text-white !px-6 !py-3 rounded">Make Appointment</Button>
                </div>
            </div>
    );
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d
}
