import React, { useState } from "react";
import { MdEmail } from "react-icons/md";
import { RiLockPasswordFill } from "react-icons/ri";
import { AiFillEye, AiFillEyeInvisible } from "react-icons/ai";
import { authenticate } from "../../../../services/apis/auth"; // Đường dẫn phù hợp đến file auth.js
import Button from "../../../../components/Form/Button/index";
import InputField from "../../../../components/Form/Auth/AuthTextField";
import { toast } from 'react-toastify'; // Import toast
import { useNavigate } from "react-router-dom"; // Import useNavigate

export default function LoginForm() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [showPassword, setShowPassword] = useState(false); // State để điều khiển việc hiển thị mật khẩu
    const [formErrors, setFormErrors] = useState(""); // Lưu trữ lỗi chung cho form
    const navigate = useNavigate(); // Khởi tạo useNavigate để chuyển hướng
    const handleForgotPasswordRedirect = () => {
        navigate("/quen-mat-khau");
    };

    const validateForm = () => {
        // Xóa lỗi trước đó
        setFormErrors("");

        // Kiểm tra email
        if (!email) {
            setFormErrors("Vui lòng nhập email.");
            return false;
        }

        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email)) {
            setFormErrors("Email không hợp lệ.");
            return false;
        }

        // Kiểm tra mật khẩu
        if (!password) {
            setFormErrors("Vui lòng nhập mật khẩu.");
            return false;
        }

        return true; // Nếu không có lỗi
    };

    const handleLogin = async (e) => {
        e.preventDefault();

        if (!validateForm()) return; // Nếu validate không thành công, dừng hàm

        try {
            // Gửi request authenticate
            const response = await authenticate({ email, password });

            // Hiển thị thông báo thành công
            toast.success("Đăng nhập thành công!", {
                onClose: () => {
                    navigate("/"); // Chuyển hướng sau khi thông báo đóng
                },
                autoClose: 1000,
            });

        } catch (err) {
            if(err.message === "Tài khoản chưa được kích hoạt")
                toast.error(err.message, { autoClose: 1000 });
            else
            // Hiển thị thông báo lỗi
                toast.error(err.response?.data?.msg || "Sai email hoặc mật khẩu!", {
                    autoClose: 1000,
                });
        }
    };

    return (
        <form onSubmit={handleLogin}>
            {/* Email Input */}
            <div className="mb-4">
                <InputField
                    label="Email"
                    type="text"
                    placeholder="Nhập email"
                    icon={MdEmail}
                    value={email} // Truyền giá trị email từ state
                    onChange={(e) => setEmail(e.target.value)} // Cập nhật state email khi input thay đổi
                />
                {/* Hiển thị lỗi cho email nếu có */}
                {formErrors && formErrors.startsWith("Vui lòng nhập email") && (
                    <p className="text-red-500 text-sm">{formErrors}</p>
                )}
                {formErrors && formErrors.startsWith("Email không hợp lệ") && (
                    <p className="text-red-500 text-sm">{formErrors}</p>
                )}
            </div>

            {/* Mật khẩu Input */}
            <div className="mb-4">
                <div className="relative">
                    {/* Trường Mật khẩu */}
                    <InputField
                        label="Mật khẩu"
                        type={showPassword ? "text" : "password"} // Thay đổi type dựa trên showPassword
                        placeholder="Nhập mật khẩu"
                        icon={RiLockPasswordFill}
                        value={password} // Truyền giá trị password từ state
                        onChange={(e) => setPassword(e.target.value)} // Cập nhật state password khi input thay đổi
                    />

                    {/* Chỉ hiển thị icon mắt khi có mật khẩu */}
                    {password && (
                        <div
                            className="absolute right-3 top-2/3 transform -translate-y-1/2 cursor-pointer text-gray-500"
                            onClick={() => setShowPassword((prev) => !prev)} // Lật trạng thái showPassword
                        >
                            {showPassword ? <AiFillEyeInvisible size={24}/> : <AiFillEye size={24}/>}
                        </div>
                    )}
                </div>

                {/* Hiển thị lỗi cho mật khẩu nếu có */}
                {formErrors && formErrors.startsWith("Vui lòng nhập mật khẩu") && (
                    <p className="text-red-500 text-sm">{formErrors}</p>
                )}
            </div>

            {/* Forgot Password */}
            <div className="flex justify-end mb-6">
                <button
                    onClick={handleForgotPasswordRedirect}
                    className="text-sm text-gray-600 hover:underline">
                    Quên mật khẩu?
                </button>
            </div>

            {/* Hiển thị lỗi chung */}
            {error && <p className="text-red-500 text-center mb-4">{error}</p>}

            {/* Submit Button */}
            <div className="flex justify-center">
                <Button className="login-button" type="submit">
                    Đăng nhập
                </Button>
            </div>
        </form>
    );
}
