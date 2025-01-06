import axiosClient from "./axiosClient";
import { setToken } from "../auth/authUtils";

export const register = (registerRequest) => {
    const urlRegister="/auth/register"
    return axiosClient.post(urlRegister, registerRequest);
};

export const authenticate = async (authenticateRequest) => {
    const urlAuthenticate = "/auth/authenticate";

    try {
        const response = await axiosClient.post(urlAuthenticate, authenticateRequest);

        // Giải nén trực tiếp từ response (không phải response.data)
        const { access_token, name, email, role } = response; // Truy cập trực tiếp vào response, không cần .data

        // Lưu token vào cookie hoặc storage
        setToken(access_token, name, email, role);

        return response;
    } catch (error) {
        console.error("Authenticate Error:", error);
        throw error;
    }
};


// export const verifyEmail = (verifyRequest) => {
//     const url = urlAuth + "confirm-email";
//     return axiosClient.post(url, verifyRequest);
// };

export const forgotPassword = (forgotPasswordRequest) => {
    const urlForgotPassword = "/auth/forgot-password";
    return axiosClient.post(urlForgotPassword, forgotPasswordRequest);
}

export const changePassword = (changePasswordRequest) => {
    const urlChangePassword = "/auth/change-password";
    return axiosClient.post(urlChangePassword, changePasswordRequest);
}