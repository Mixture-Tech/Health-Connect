import React from "react";
import Cookies from "js-cookie";
import { StorageKeys } from "../services/key/keys";
import { Navigate, Outlet} from "react-router-dom";

export default function AuthLayout() {
    // return !Cookies.get(StorageKeys.ACCESS_TOKEN) ? <Navigate to="/dang-nhap" replace /> : <Outlet />;
    return <Outlet />;
}
