// import Cookies from "js-cookie";
import { Navigate, Outlet, useLocation } from "react-router-dom";

export default function ChatbotLayout() {
    const location = useLocation();

    // return Cookies.get(StorageKeys.ACCESS_TOKEN) &&
    //     (location.pathname === "/dang-nhap" || location.pathname === "/dang-ky") ? (
    //     <Navigate to="/" replace />
    // ) : (
    //     <div className="flex flex-col min-h-screen">
    //         <Header />
    //         {/* <Outlet /> */}
    //         {/* <Footer /> */}
    //     </div>
    // );
    return (
        <div className="flex flex-col min-h-screen">
            <Outlet />
        </div>
    );
}
