import {jwtDecode} from "jwt-decode";
import Cookies from "js-cookie";
import {StorageKeys} from "../key/keys";

export const setToken = (token, name , email, role) => {
    const decodedToken = jwtDecode(token);
    const expirationTime = decodedToken.exp * 1000;

    Cookies.set(StorageKeys.ACCESS_TOKEN, token, { expires: new Date(expirationTime) });
    localStorage.setItem(StorageKeys.USER_NAME, name);
    localStorage.setItem(StorageKeys.USER_EMAIL, email);
    localStorage.setItem(StorageKeys.USER_ROLE, role);
};
