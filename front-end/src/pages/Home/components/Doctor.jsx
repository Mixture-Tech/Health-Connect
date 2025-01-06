import React, { useState, useEffect } from 'react';
import { FaArrowLeft, FaArrowRight } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom'; // Thêm useNavigate từ react-router-dom
import axiosClient from '../../../services/apis/axiosClient';

export default function Doctor() {
    const [allDoctors, setAllDoctors] = useState([]);
    const [startIndex, setStartIndex] = useState(0);
    const [isAnimating, setIsAnimating] = useState(false);
    const navigate = useNavigate(); // Khởi tạo navigate

    // Fetch data from API
    useEffect(() => {
        const fetchDoctors = async () => {
            try {
                const response = await axiosClient.get('/doctors');
                setAllDoctors(response.data); // Lấy dữ liệu từ thuộc tính `data`
            } catch (error) {
                console.error("Failed to fetch doctors:", error);
            }
        };

        fetchDoctors();
    }, []);

    const getCurrentDoctors = () => {
        const visibleDoctors = [];
        for (let i = 0; i < 4; i++) {
            const index = (startIndex + i) % allDoctors.length;
            visibleDoctors.push(allDoctors[index]);
        }
        return visibleDoctors;
    };

    const handlePrevClick = () => {
        if (isAnimating) return;
        setIsAnimating(true);
        setStartIndex((prevIndex) => {
            const newIndex = prevIndex - 3;
            return newIndex < 0 ? 0 : newIndex;
        });
        setTimeout(() => setIsAnimating(false), 500);
    };

    const handleNextClick = () => {
        if (isAnimating) return;
        setIsAnimating(true);
        setStartIndex((prevIndex) => {
            const newIndex = prevIndex + 3;
            return newIndex > allDoctors.length - 4 ? allDoctors.length - 4 : newIndex;
        });
        setTimeout(() => setIsAnimating(false), 500);
    };

    const handleDoctorClick = (doctorId) => {
        navigate(`/chi-tiet-bac-si/${doctorId}`); // Điều hướng đến trang chi tiết bác sĩ
    };

    const visibleDoctors = getCurrentDoctors();

    return (
        <section className="mb-20 mt-20" style={{ backgroundImage: `url(${require('../../../assets/images/background-doctor.png')})` }}>
            <div className="container mx-auto px-4">
                <h2 className="text-3xl font-bold text-center mb-10 text-primary-1000">
                    Bác sĩ
                </h2>
                <div className="flex justify-between items-center">
                    <div className="w-8 flex justify-center">
                        {startIndex > 0 && (
                            <button
                                className="transform transition-all duration-300 hover:scale-110"
                                onClick={handlePrevClick}
                                disabled={isAnimating}
                            >
                                <FaArrowLeft className="text-2xl text-primary hover:text-primary-600 transition-colors duration-300" />
                            </button>
                        )}
                    </div>

                    <div className="flex-1 mx-4 overflow-hidden">
                        <div className={`grid grid-cols-4 gap-6 transform transition-all duration-500 ease-in-out ${isAnimating ? 'opacity-50 scale-95' : 'opacity-100 scale-100'}`}>
                            {visibleDoctors.map((item, index) => (
                                item ? (
                                    <div
                                        key={item.doctor_id || index}
                                        className="bg-white shadow-2xl p-6 rounded-lg flex flex-col items-center text-center h-72 transform transition-all duration-300 hover:shadow-lg hover:-translate-y-1 cursor-pointer"
                                        onClick={() => handleDoctorClick(item.doctor_id)} // Thêm sự kiện click
                                    >
                                        <div
                                            className="h-40 w-40 mb-4 overflow-hidden rounded-full flex justify-center items-center">
                                            <img
                                                src={require(`../../../${item.doctor_image}`)} // Đường dẫn ảnh tĩnh từ API
                                                alt={`Bác sĩ ${item.doctor_name}` || "Không rõ bác sĩ"}
                                                className="w-full h-full object-cover rounded-full transition-transform duration-300 hover:scale-110"
                                            />
                                        </div>
                                        <div className="flex-1">
                                            <h4 className="text-xl font-semibold mb-2 transition-colors duration-300 hover:text-primary">
                                                {item.doctor_name}
                                            </h4>
                                            <p className="text-lg text-gray-600 transition-colors duration-300 hover:text-primary">
                                                {item.specialization_name}
                                            </p>
                                        </div>
                                    </div>
                                ) : null
                            ))}
                        </div>
                    </div>

                    <div className="w-8 flex justify-center">
                        {startIndex < allDoctors.length - 4 && (
                            <button
                                className="transform transition-all duration-300 hover:scale-110"
                                onClick={handleNextClick}
                                disabled={isAnimating}
                            >
                                <FaArrowRight className="text-2xl text-primary hover:text-primary-600 transition-colors duration-300" />
                            </button>
                        )}
                    </div>
                </div>
            </div>
        </section>
    );
}
