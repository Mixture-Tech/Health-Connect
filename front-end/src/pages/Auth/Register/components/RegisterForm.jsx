import React, { useState } from "react";
import { FaUserMd } from "react-icons/fa";
import { MdEmail, MdPhone } from "react-icons/md";
import { RiLockPasswordFill } from "react-icons/ri";
import { AiFillEye, AiFillEyeInvisible } from "react-icons/ai";
import { toast } from "react-toastify"; // Import toast
import { useNavigate } from "react-router-dom"; // Import useNavigate
import Button from "../../../../components/Form/Button/index";
import InputField from "../../../../components/Form/Auth/AuthTextField";
import { register } from "../../../../services/apis/auth"; // Đường dẫn phù hợp tới API

export default function RegisterForm() {
    const [username, setUsername] = useState("");
    const [phone, setPhone] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");
    const [showPassword, setShowPassword] = useState(false);
    const [formErrors, setFormErrors] = useState("");
    const [isLoading, setIsLoading] = useState(false); // Thêm state để theo dõi trạng thái loading
    const navigate = useNavigate();

    const validateForm = () => {
        setFormErrors("");
        if (!username) {
            setFormErrors("Vui lòng nhập họ và tên.");
            return false;
        }
        const phoneRegex = /^\d{10}$/;
        if (!phone) {
            setFormErrors("Vui lòng nhập số điện thoại.");
            return false;
        } else if (!phoneRegex.test(phone)) {
            setFormErrors("Số điện thoại phải có đúng 10 số.");
            return false;
        }
        if (!email) {
            setFormErrors("Vui lòng nhập email.");
            return false;
        }
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email)) {
            setFormErrors("Email không hợp lệ.");
            return false;
        }
        const passwordRegex = /^(?=.*[A-Z])(?=.*\d).+$/;
        if (!password) {
            setFormErrors("Vui lòng nhập mật khẩu.");
            return false;
        } else if (!passwordRegex.test(password)) {
            setFormErrors("Mật khẩu phải có ít nhất 1 ký tự viết hoa và 1 chữ số.");
            return false;
        }
        return true;
    };

    const handleRegister = async (e) => {
        e.preventDefault();

        if (!validateForm()) return;

        setIsLoading(true); // Bắt đầu trạng thái loading

        try {
            const response = await register({ username, phone, email, password });

            if (response.error_code === "OK") {
                toast.success("Đăng ký thành công! Vui lòng xác nhận email", {
                    onClose: () => navigate("/dang-nhap"),
                    autoClose: 1000,
                });
            }
        } catch (err) {
            if (err.response) {
                if (err.response.status === 409) {
                    if (err.response.data && err.response.data.error_code) {
                        if (err.response.data.error_code === "PHONE_ALREADY_EXISTS") {
                            toast.error("Số điện thoại đã được sử dụng. Vui lòng thử số khác.", { autoClose: 1000 });
                        } else if (err.response.data.error_code === "EMAIL_ALREADY_EXISTS") {
                            toast.error("Email đã được sử dụng. Vui lòng thử email khác.", { autoClose: 1000 });
                        } else {
                            toast.error(err.response.data.message || "Đăng ký thất bại. Vui lòng thử lại.");
                        }
                    }
                } else {
                    toast.error("Đăng ký thất bại. Vui lòng thử lại.", { autoClose: 1000 });
                }
            } else {
                toast.error("Đăng ký thất bại. Vui lòng thử lại.", { autoClose: 1000 });
            }
        } finally {
            setIsLoading(false); // Kết thúc trạng thái loading
        }
    };

    return (
        <form onSubmit={handleRegister}>
            <InputField
                label="Họ và tên"
                type="text"
                placeholder="Nhập họ và tên"
                icon={FaUserMd}
                value={username}
                onChange={(e) => setUsername(e.target.value)}
            />
            {formErrors && formErrors.startsWith("Vui lòng nhập họ và tên.") && (
                <p className="text-red-500 text-sm">{formErrors}</p>
            )}

            <InputField
                label="Số điện thoại"
                type="text"
                placeholder="Nhập số điện thoại"
                icon={MdPhone}
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
            />
            {formErrors && formErrors.startsWith("Vui lòng nhập số điện thoại.") && (
                <p className="text-red-500 text-sm">{formErrors}</p>
            )}
            {formErrors && formErrors.startsWith("Số điện thoại phải có đúng 10 số.") && (
                <p className="text-red-500 text-sm">{formErrors}</p>
            )}

            <InputField
                label="Email"
                type="email"
                placeholder="Nhập email"
                icon={MdEmail}
                value={email}
                onChange={(e) => setEmail(e.target.value)}
            />
            {formErrors && formErrors.startsWith("Vui lòng nhập email") && (
                <p className="text-red-500 text-sm">{formErrors}</p>
            )}
            {formErrors && formErrors.startsWith("Email không hợp lệ") && (
                <p className="text-red-500 text-sm">{formErrors}</p>
            )}

            <div className="mb-4">
                <div className="relative">
                    <InputField
                        label="Mật khẩu"
                        type={showPassword ? "text" : "password"}
                        placeholder="Nhập mật khẩu"
                        icon={RiLockPasswordFill}
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                    />
                    {password && (
                        <div
                            className="absolute right-3 top-2/3 transform -translate-y-1/2 cursor-pointer text-gray-500"
                            onClick={() => setShowPassword((prev) => !prev)}
                        >
                            {showPassword ? <AiFillEyeInvisible size={24}/> : <AiFillEye size={24}/>}
                        </div>
                    )}
                </div>
                {formErrors && formErrors.startsWith("Vui lòng nhập mật khẩu.") && (
                    <p className="text-red-500 text-sm">{formErrors}</p>
                )}
                {formErrors && formErrors.startsWith("Mật khẩu phải có ít nhất 1 ký tự viết hoa và 1 chữ số.") && (
                    <p className="text-red-500 text-sm">{formErrors}</p>
                )}
            </div>

            {error && <p className="text-red-500 text-center mb-4">{error}</p>}

            <div className="flex justify-center">
                <Button className="register-button" type="submit" disabled={isLoading}>
                    {isLoading ? "Đang xử lý..." : "Đăng ký"}
                </Button>
            </div>
        </form>
    );
}
