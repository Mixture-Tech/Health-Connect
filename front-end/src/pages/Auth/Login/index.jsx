import React from "react";
import LoginForm from "./components/LoginForm";
import Logo from "../../../components/Form/Auth/Logo";
import { ToastContainer } from "react-toastify"; // Import ToastContainer
import "react-toastify/dist/ReactToastify.css";
import {useNavigate} from "react-router-dom"; // Import CSS của react-toastify

export default function Login() {
    const navigate = useNavigate();
    const handleRegisterRedirect = () => {
        navigate("/dang-ky");
    };
  return (
      <div className="flex justify-center items-center min-h-screen bg-gradient-to-r from-primary-50 to-primary-200">
        <div className="w-full max-w-md bg-white rounded-lg shadow-lg p-8">
          <Logo />
          <h2 className="text-3xl font-bold text-center mb-6">Đăng nhập</h2>
          <LoginForm />
          <div className="text-center my-4 flex justify-center text-gray-600 text-sm">
            <p>Chưa có tài khoản?</p>
            <button
                onClick={handleRegisterRedirect}
                className="ms-1 hover:underline font-semibold">
              Đăng ký ngay
            </button>
          </div>
        </div>
        <ToastContainer />
      </div>
  );
}
