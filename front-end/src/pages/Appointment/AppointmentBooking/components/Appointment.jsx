import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Button from "../../../../components/Form/Button";
import MultipleSelect from "../../../../components/Form/Appointment/MultipleSelect";
import RadioButton from "../../../../components/Form/Appointment/RadioButton";
import AppointmentTextField from '../../../../components/Form/Appointment/AppointmentTextField';
import { RiAccountCircleLine, RiPhoneLine, RiMailLine, RiCalendarLine, RiMapPinLine } from "react-icons/ri";
import { AppointmentService } from '../../../../services/apis/appointment';
import { useAppointmentContext } from '../../../../contexts/appointmentContext';
import { userDetail } from '../../../../services/apis/user';
import { toast, ToastContainer } from 'react-toastify';
import  useLocationData from '../../../../hooks/useLocationData';
// import { clearAppointmentData } from '../../../../contxts/appointmentContext';

export default function AppointmentDetails() {
    const navigate = useNavigate();
    // State for user data
    const [userData, setUserData] = useState(null);
    const [selectedGender, setSelectedGender] = useState("Nam");
    const [selectedPatientType, setSelectedPatientType] = useState("Đặt cho mình");

    // State for patient information
    const [patientName, setPatientName] = useState("");
    const [patientPhone, setPatientPhone] = useState("");
    const [patientEmail, setPatientEmail] = useState("");
    const [dateOfBirth, setDateOfBirth] = useState("");

    // Sử dụng custom hook cho địa điểm
    const {
        provinces,
        districts,
        wards,
        selectedProvince,
        selectedDistrict,
        selectedWard,
        setSelectedProvince,
        setSelectedDistrict,
        setSelectedWard,
        setLocationFromAddress
    } = useLocationData();

    // State for loading status
    const [isLoadingUser, setIsLoadingUser] = useState(false);

    // Appointment context
    const { appointmentData } = useAppointmentContext();

    // User data context
    const fetchUserData = async (email) => {
        setIsLoadingUser(true);
        try{
            const response = await userDetail(email);
            if(response){
                setUserData(response);
                // Set patient information if booking for self
                if (selectedPatientType === "Đặt cho mình") {
                    setPatientName(response.username);
                    setPatientPhone(response.phone);
                    setPatientEmail(response.email);
                    setSelectedGender(response.gender || "Nam");
                    setDateOfBirth(response.dateOfBirth || "");
                    
                    if (response.address) {
                        setLocationFromAddress(response.address);
                    }
                }
            }
        } catch (error) {
            console.error("Error loading user data:", error);
        } finally {
            setIsLoadingUser(false);
        }
    };

    useEffect(() => {
        const userEmail = localStorage.getItem("USER_EMAIL");
        fetchUserData(userEmail);
    }, []);

    const handleSubmitAppointment = async () => {
        // Kiểm tra thông tin bắt buộc
        if (!patientName || !patientPhone) {
            toast.error("Vui lòng điền đầy đủ thông tin bệnh nhân");
            return;
        }
    
        // Kiểm tra xem đã chọn đủ địa điểm chưa
        if (!selectedProvince.name || !selectedDistrict.name || !selectedWard.name) {
            toast.error("Vui lòng chọn đầy đủ địa điểm");
            return;
        }
    
        // Kiểm tra thông tin lịch khám từ context
        if (!appointmentData?.doctor || !appointmentData?.schedule) {
            toast.error("Vui lòng chọn bác sĩ và thời gian khám");
            return;
        }
    
        const appointmentSubmitData = {
            doctor: appointmentData.doctor,
            patientType: selectedPatientType,
            patientName,
            patientPhone,
            patientEmail,
            gender: selectedGender,
            dateOfBirth,
            province: selectedProvince.name,
            district: selectedDistrict.name,
            ward: selectedWard.name,
            appointmentDate: appointmentData.schedule.workingDate,
            startTime: appointmentData.schedule.startTime,
            endTime: appointmentData.schedule.endTime
        };
    
        try {
            const result = await AppointmentService.createAppointment(
                appointmentData.doctor.id, 
                appointmentSubmitData
            );
            if (result) {
                toast.success("Đặt lịch khám thành công!");
                // navigate("/dat-lich-thanh-cong");
            } else {
                toast.error("Đặt lịch khám thất bại");
            }
        } catch (error) {
            console.error("Error creating appointment:", error);
            toast.error("Đặt lịch khám thất bại");
        }
    };

    useEffect(() => {
        if (userData?.address) {
          setLocationFromAddress(userData.address);
        }
      }, [userData, provinces, districts, wards]);

    // Giữ nguyên useEffect ban đầu để fetch dữ liệu
    useEffect(() => {
        const userEmail = localStorage.getItem("USER_EMAIL");
        fetchUserData(userEmail);
    }, []);

    // Thêm một useEffect để xử lý việc điền thông tin
    useEffect(() => {
        if (userData && selectedPatientType === "Đặt cho mình") {
            setPatientName(userData.username || "");
            setPatientPhone(userData.phone || "");
            setPatientEmail(userData.email || "");
            setSelectedGender(userData.gender || "Nam");
            setDateOfBirth(userData.dateOfBirth || "");
        }
    }, [userData, selectedPatientType]);

    

    return (
        <div className="w-full max-w-3xl mx-auto p-5 bg-white border border-gray-300 rounded-lg shadow-md font-sans mt-2 mb-4">
            <div className="max-w-lg mx-auto p-5 font-sans">
                {/* Price Section */}
                {/* <div className="mb-5">
                <label className="flex items-center">
                    <input type="radio" name="price" defaultChecked className="mr-2" />
                    Giá khám 180.000đ
                </label>
            </div> */}

                <div className="flex flex-col items-center">
                    <h3 className="text-lg font-semibold mb-3">Lựa chọn đối tượng</h3>
                    <div className="mb-4 flex gap-5">
                        <RadioButton
                            label="Đặt cho mình"
                            isChecked={selectedPatientType === "Đặt cho mình"}
                            onToggle={() => {
                                setSelectedPatientType("Đặt cho mình");
                                // Tự động điền thông tin nếu đã có dữ liệu người dùng
                                if (userData) {
                                    setPatientName(userData.username || "NGU NHU CHÓ");
                                    setPatientPhone(userData.phone);
                                    setPatientEmail(userData.email);
                                    setSelectedGender(userData.gender || "Nam");
                                    setDateOfBirth(userData.dateOfBirth || "");
                                }
                            }}
                        />
                        <RadioButton
                            label="Đặt cho người thân"
                            isChecked={selectedPatientType === "Đặt cho người thân"}
                            onToggle={() => {
                                setSelectedPatientType("Đặt cho người thân");
                                // Reset các trường khi chuyển sang đặt cho người thân
                                setPatientName("");
                                setPatientPhone("");
                                setPatientEmail("");
                                setLocationFromAddress("");
                            }}
                        />
                    </div>
                </div>


                <form className="space-y-2">
                    {/* Additional Fields for Family Member */}
                    {selectedPatientType === "Đặt cho người thân" && (
                        <>
                            <h3 className="text-lg font-bold text-teal-600">Thông tin người đặt lịch</h3>
                            <AppointmentTextField 
                                icon={RiAccountCircleLine} 
                                type="text" 
                                placeholder="Họ tên người đặt lịch" 
                                value={userData?.username || ""}
                                readOnly
                                className="mb-2" 
                            />
                            <AppointmentTextField 
                                icon={RiPhoneLine} 
                                type="text" 
                                placeholder="Số điện thoại" 
                                value={userData?.phone || ""}
                                readOnly
                                className="mb-2" 
                            />
                            <AppointmentTextField 
                                icon={RiMailLine} 
                                type="text" 
                                placeholder="Địa chỉ email" 
                                value={userData?.email || ""}
                                readOnly
                                className="mb-2" 
                            />
                        </>
                    )}

                    {/* Common Fields */}
                    <h3 className="text-lg font-bold text-teal-600">Thông tin bệnh nhân</h3>

                    <AppointmentTextField 
                        icon={RiAccountCircleLine} 
                        type="text" 
                        placeholder="Họ tên bệnh nhân" 
                        value={patientName}
                        onChange={(e) => setPatientName(e.target.value)}
                        className="mb-2" 
                    />
                    <p className="text-sm mb-4 text-gray-500">Hãy ghi rõ Họ Và Tên, viết hoa những chữ cái đầu tiên, ví dụ: Nguyễn Văn A</p>
                    <AppointmentTextField 
                        icon={RiPhoneLine} 
                        type="text" 
                        placeholder="Số điện thoại liên hệ (bắt buộc)" 
                        value={patientPhone}
                        onChange={(e) => setPatientPhone(e.target.value)}
                        className="mb-2" 
                    />

                    {/* Gender Selection */}
                    <div>
                        <h3 className="text-md font-semibold mb-2">Giới tính</h3>
                        <div className="flex gap-5">
                            <RadioButton
                                label="Nam"
                                isChecked={selectedGender === "Nam"}
                                onToggle={() => setSelectedGender("Nam")}
                            />
                            <RadioButton
                                label="Nữ"
                                isChecked={selectedGender === "Nữ"}
                                onToggle={() => setSelectedGender("Nữ")}
                            />
                        </div>
                    </div>

                    <AppointmentTextField 
                        icon={RiMailLine} 
                        type="text" 
                        placeholder="Địa chỉ email" 
                        value={patientEmail || userData?.email || ''}
                        onChange={(e) => setPatientEmail(e.target.value)}
                        className="mb-2" 
                    />
                    <AppointmentTextField 
                        icon={RiCalendarLine} 
                        type="date" 
                        placeholder="Chọn ngày sinh" 
                        value={dateOfBirth || userData?.dateOfBirth || ''}
                        onChange={(e) => setDateOfBirth(e.target.value)}
                        className="mb-2" 
                    />
                    {/* Using MultipleSelect for City Selection */}
                    <MultipleSelect
                        options={provinces.map(p => p.name)}
                        value={selectedProvince?.name || ''}
                        onChange={(value) => {
                            const selectedProvinceObj = provinces.find(p => p.name === value);
                            setSelectedProvince(selectedProvinceObj);
                        }}
                        placeholder="    Chọn tỉnh thành"
                        className="mb-4"
                        icon={RiMapPinLine}
                    />

                    {/* District Selection */}
                    <MultipleSelect
                        options={districts.map(d => d.name)}
                        value={selectedDistrict?.name || ''}
                        onChange={(value) => {
                            const selectedDistrictObj = districts.find(d => d.name === value);
                            setSelectedDistrict(selectedDistrictObj);
                        }}
                        placeholder="Chọn Quận/Huyện"
                        className="mb-4"
                        icon={RiMapPinLine}
                        disabled={!selectedProvince}
                    />

                    {/* Ward Selection */}
                    <MultipleSelect
                        options={wards.map(w => w.name)}
                        value={selectedWard?.name || ''}
                        onChange={(value) => {
                            const selectedWardObj = wards.find(w => w.name === value);
                            setSelectedWard(selectedWardObj);
                        }}
                        placeholder="Chọn Phường/Xã"
                        className="mb-4"
                        icon={RiMapPinLine}
                        disabled={!selectedDistrict}
                    />

                    {/* Payment Method Section */}
                    <div>
                        <h3 className="text-lg font-semibold">Hình thức thanh toán</h3>
                        <label className="flex items-center">
                            <input type="radio" name="paymentMethod" defaultChecked className="mr-2" />
                            Thanh toán sau tại cơ sở y tế
                        </label>
                    </div>

                    {/* Pricing Details */}
                    <div className="bg-gray-100 p-4 rounded-lg text-sm">
                        <div className="flex justify-between">
                            <span>Giá khám</span>
                            <span className="font-bold">180.000đ</span>
                        </div>
                        <div className="flex justify-between text-gray-500">
                            <span>Phí đặt lịch</span>
                            <span>Miễn phí</span>
                        </div>
                        <div className="flex justify-between font-bold text-red-600 mt-2">
                            <span>Tổng cộng</span>
                            <span>180.000đ</span>
                        </div>
                    </div>

                    {/* Reminder Section */}
                    <div className="bg-teal-50 p-4 rounded-lg text-sm text-teal-600">
                        <strong>LƯU Ý</strong>
                        <p>Thông tin anh/chị cung cấp sẽ được sử dụng làm hồ sơ khám bệnh:</p>
                        <ul className="list-disc pl-5">
                            <li>Ghi rõ họ và tên, viết hoa những chữ cái đầu tiên</li>
                            <li>Điền đầy đủ, đúng và vui lòng kiểm tra lại thông tin trước khi ấn "Đặt lịch khám"</li>
                        </ul>
                    </div>

                    {/* Terms and Conditions */}
                    <p className="text-sm text-gray-500 text-center">
                        Bằng việc xác nhận đặt khám, bạn đã hoàn toàn đồng ý với
                        <a href="#" className="text-teal-600 underline ml-1">Điều khoản sử dụng</a>.
                    </p>
                    {/* Căn giữa nút */}
                    <Button 
                        className="mx-auto block"
                        onClick={handleSubmitAppointment}
                    >
                        Đặt Lịch Khám
                    </Button>
                </form>
            </div>
        </div >
    );
}
