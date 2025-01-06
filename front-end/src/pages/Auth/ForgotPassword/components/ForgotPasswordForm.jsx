import React, { useState } from "react";
import { MdEmail } from "react-icons/md";
import Button from "../../../../components/Form/Button/index";
import { toast } from "react-toastify"; // Thư viện thông báo
import { forgotPassword } from "../../../../services/apis/auth"; // API service cho forgot password
import { useNavigate } from "react-router-dom"; // Để chuyển hướng

export default function ForgotPasswordForm() {
    const [email, setEmail] = useState(""); // State để lưu email người dùng nhập
    const [error, setError] = useState(""); // State để lưu thông báo lỗi nếu có
    const [formErrors, setFormErrors] = useState("");
    const [isLoading, setIsLoading] = useState(false); // State để theo dõi trạng thái loading
    const navigate = useNavigate(); // Khởi tạo useNavigate để chuyển hướng

    // Hàm gọi API khi người dùng nhấn nút "Quên mật khẩu"
    const handleForgotPassword = async (e) => {
        e.preventDefault();

        setFormErrors("");
        setIsLoading(true); // Bắt đầu loading khi bắt đầu xử lý

        if (!email) {
            setFormErrors("Vui lòng nhập email.");
            setIsLoading(false); // Dừng loading nếu có lỗi
            return;
        }

        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email)) {
            setFormErrors("Email không hợp lệ.");
            setIsLoading(false); // Dừng loading nếu có lỗi
            return false;
        }

        const forgotPasswordRequest = { email };

        try {
            const response = await forgotPassword(forgotPasswordRequest); // Gọi API cho forgot password
            if (response.error_code === "OK") {
                toast.success("Mật khẩu mới đã được gửi đến email của bạn. Vui lòng kiểm tra.");
                setTimeout(() => {
                    navigate("/dang-nhap"); // Điều hướng về trang đăng nhập sau khi thông báo thành công
                }, 2000);
            } else {
                toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
            }
        } catch (err) {
            toast.error("Email chưa tồn tại trong hệ thống.");
        } finally {
            setIsLoading(false); // Kết thúc loading
        }
    };

    return (
        <form onSubmit={handleForgotPassword}>
            {/* Email Input */}
            <div className="mb-4">
                <div className="flex items-center border rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-blue-500">
                    <MdEmail className="text-gray-500 mr-3" />
                    <input
                        type="email"
                        placeholder="Nhập email"
                        className="w-full focus:outline-none"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)} // Cập nhật state email khi người dùng nhập
                    />
                </div>
                <div className="mt-1 text-center">
                    {formErrors && formErrors.startsWith("Vui lòng nhập email") && (
                        <p className="text-red-500 text-sm">{formErrors}</p>
                    )}
                    {formErrors && formErrors.startsWith("Email không hợp lệ") && (
                        <p className="text-red-500 text-sm">{formErrors}</p>
                    )}
                </div>
            </div>

            {/* Hiển thị thông báo lỗi nếu có */}
            {error && <p className="text-red-500 text-center mb-4">{error}</p>}

            {/* Submit Button */}
            <div className="flex justify-center">
                <Button className="forgot-password-button" type="submit" disabled={isLoading}>
                    {isLoading ? (
                        <span>Đang xử lý...</span> // Hiển thị "Đang xử lý..." khi đang loading
                    ) : (
                        <span>Quên mật khẩu</span>
                    )}
                </Button>
            </div>
        </form>
    );
}
