import React from 'react';
import { Link } from 'react-router-dom';
import Button from '../../../components/Form/Button';
import { FaClock, FaHeadset, FaHouseUser } from "react-icons/fa";

export default function InfoPage() {
    return (
        <section className="relative h-100 transform -translate-y-1/4">
            <div className="container mx-auto px-4">
                <div className="flex flex-col lg:flex-row">
                    <div className="lg:w-1/3 flex items-stretch">
                        <div className="bg-primary shadow-lg p-8 rounded-lg">
                            <h3 className="text-3xl font-semibold mb-4">Tại sao chọn chúng tôi?</h3>
                            <p className="text-gray-700 mb-6">
                                Chúng tôi cam kết cung cấp dịch vụ chất lượng cao, đáng tin cậy và luôn sẵn sàng đáp ứng nhu cầu của bạn. 
                                Đội ngũ chuyên gia giàu kinh nghiệm, tận tâm phục vụ và đảm bảo mang lại sự hài lòng cho khách hàng.
                            </p>
                            <div className="text-center">
                                <Link to="/">
                                    <Button className="learn-more-button border border-white" variant="secondary" onClick={() => console.log('Learnmore button clicked')}>
                                        Tìm hiểu thêm
                                    </Button>
                                </Link>
                            </div>
                        </div>
                    </div>
                    <div className="lg:w-2/3 flex items-stretch mt-8 lg:mt-0">
                        <div className="flex justify-center space-y-6">
                            <div className="flex flex-wrap">
                                <div className="w-full xl:w-1/3 px-4">
                                    <div className="bg-white shadow-lg p-6 rounded-lg flex flex-col items-center text-center h-full">
                                        <FaHouseUser className="text-primary text-4xl mb-4"/>
                                        <h4 className="text-xl font-semibold mb-2">Đặt Lịch Hẹn</h4>
                                        <small className="text-gray-500 mb-2">Dịch vụ 24/7</small>
                                        <p className="text-gray-600">Chúng tôi cung cấp dịch vụ đặt lịch nhanh chóng và tiện lợi, đảm bảo sự thoải mái và thuận tiện cho bạn.</p>
                                    </div>
                                </div>
                                <div className="w-full xl:w-1/3 px-4 mt-6 xl:mt-0">
                                    <div className="bg-white shadow-lg p-6 rounded-lg flex flex-col items-center text-center h-full">
                                        <FaHeadset className="text-primary text-4xl mb-4"/>
                                        <h4 className="text-xl font-semibold mb-2">Trường Hợp Khẩn Cấp</h4>
                                        <h6 className="text-gray-500 mb-2">+84xxxxxxxxx</h6>
                                        <p className="text-gray-600">Chúng tôi luôn sẵn sàng hỗ trợ trong các tình huống khẩn cấp. Đội ngũ tư vấn luôn sẵn sàng phục vụ 24/7.</p>
                                    </div>
                                </div>
                                <div className="w-full xl:w-1/3 px-4 mt-6 xl:mt-0">
                                    <div className="bg-white shadow-lg p-6 rounded-lg flex flex-col items-center text-center h-full">
                                        <FaClock className="text-primary text-4xl mb-4"/>
                                        <h4 className="text-xl font-semibold mb-2">Giờ Làm Việc</h4>
                                        <small className="text-gray-500 mb-4">Lịch trình làm việc</small>
                                        <ul className="w-full text-gray-600">
                                            <li className="flex justify-between mb-2"><span>Thứ 2 - Thứ 4:</span> <span> 8:00 - 17:00</span></li>
                                            <li className="flex justify-between mb-2"><span>Thứ 5 - Thứ 6:</span> <span> 9:00 - 17:00</span></li>
                                            <li className="flex justify-between"><span>Thứ 7 - CN:</span> <span> 10:00 - 17:00</span></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
}
