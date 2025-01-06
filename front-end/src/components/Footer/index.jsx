
import React from "react";
import {CgFacebook} from "react-icons/cg";
import {BsInstagram, BsLinkedin, BsTwitter, BsGithub} from "react-icons/bs";
import Button from "../Form/Button";

export default function Footer() {

    return (
        <footer className="bg-primary-50 boxShadow rounded-xl w-full p-3 lg:p-4 relative">

            <div
                className="w-full flex items-center justify-center pt-[30px] flex-col gap-[20px] pb-[30px]">
                <img src="https://i.ibb.co/ZHYQ04D/footer-logo.png" alt="logo"
                     className="w-[150px]"/>

                <p className="text-[0.9rem] text-center sm:text-start text-gray-600">
                    Chúng tôi cam kết mang đến chất lượng dịch vụ tốt nhất để đáp ứng nhu cầu chăm sóc sức khỏe của bạn.
                </p>

                <Button>Liên hệ với chúng tôi</Button>

                <div className="flex gap-[15px] text-primary-1000 mt-4">
                    <a href="https://www.facebook.com/" className="text-[1.3rem] p-1.5 cursor-pointer rounded-full bg-white text-text boxShadow">
                        <CgFacebook/>
                    </a>
                    <a href="https://github.com/hoangnguyen229" className="text-[1.2rem] p-1.5 cursor-pointer rounded-full bg-white text-text boxShadow">
                        <BsGithub/>
                    </a>
                    <a href="https://www.instagram.com/" className="text-[1.2rem] p-1.5 cursor-pointer rounded-full bg-white text-text boxShadow">
                        <BsInstagram/>
                    </a>
                    <a href="https://www.linkedin.com/in/hoangnguyen-dev-a2a62529b/" className="text-[1.2rem] p-1.5 cursor-pointer rounded-full bg-white text-text boxShadow">
                        <BsLinkedin/>
                    </a>
                </div>
            </div>

            <div className="border-t border-gray-200 pt-[20px] flex items-center w-full flex-wrap gap-[20px] justify-center">
                <p className="text-[0.8rem] sm:text-[0.9rem] text-gray-600">© 2024 Health Connect. All Rights Reserved.</p>  
            </div>
        </footer>
    );
};                  