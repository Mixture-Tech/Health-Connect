import Login from "../pages/Login/Login";

export default function AuthLayout() {
    // return !Cookies.get(StorageKeys.ACCESS_TOKEN) ? <Navigate to="/dang-nhap" replace /> : <Outlet />;
    return <Login />;
}
