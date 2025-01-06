// import Cookies from "js-cookie";
<<<<<<< HEAD
import Footer from "../components/Footer/index";
import Header from "../components/Header/index";
import Navbar from "../components/Header/components/Navbar";
import { Navigate, Outlet, useLocation } from "react-router-dom";

export default function BasicLayout() {
    const location = useLocation();
=======
// import Footer from "~/components/Footer";
// import Header from "../components/Header/Header";
// import NavigatorCard from "../components/Header/components/Navbar";
import Footer from "../components/Footer/Footer";
import Header from "../components/Header/Header";
// import { StorageKeys } from "~/common/constants/keys.js";
import { Navigate, Outlet, useLocation } from "react-router-dom";

export default function BasicLayout() {
    // const location = useLocation();
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d

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
<<<<<<< HEAD
            {location.pathname === "/" ? <Header /> : <Navbar />}
            <Outlet />
            {location.pathname === "/chat-bot" ? null : <Footer />}
=======
            <Header />
            <Outlet />
            <Footer />
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d
        </div>
    );
}
