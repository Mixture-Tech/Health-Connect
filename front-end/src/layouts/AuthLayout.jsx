<<<<<<< HEAD
import React from "react";
import Cookies from "js-cookie";
import { StorageKeys } from "../services/key/keys";
import { Navigate, Outlet} from "react-router-dom";

export default function AuthLayout() {
    // return !Cookies.get(StorageKeys.ACCESS_TOKEN) ? <Navigate to="/dang-nhap" replace /> : <Outlet />;
    return <Outlet />;
=======
import Login from "../pages/Login/Login";

export default function AuthLayout() {
    // return !Cookies.get(StorageKeys.ACCESS_TOKEN) ? <Navigate to="/dang-nhap" replace /> : <Outlet />;
    return <Login />;
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d
}
