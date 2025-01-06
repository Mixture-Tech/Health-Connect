// import Cookies from "js-cookie";
import Footer from "../components/Footer/index";
import Header from "../components/Header/index";
import Navbar from "../components/Header/components/Navbar";
import { Navigate, Outlet, useLocation } from "react-router-dom";

export default function BasicLayout() {
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
            {location.pathname === "/" ? <Header /> : <Navbar />}
            <Outlet />
            {location.pathname === "/chat-bot" ? null : <Footer />}
        </div>
    );
}
