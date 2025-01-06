import React, { useRef, useEffect, useState } from 'react';
import { RiRobot2Fill, RiUser3Line } from 'react-icons/ri';
import Logo from '../../../components/Form/Auth/Logo';

export function ChatMessages({ messages, userName }) {
    const messagesEndRef = useRef(null);
    const [showUserMenu, setShowUserMenu] = useState(false);

    // Lấy username từ localStorage, với giá trị mặc định nếu không tìm thấy
    const [displayName, setDisplayName] = useState(() => {
        return localStorage.getItem('USER_NAME') || userName || "Hoàng";
    });

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    };

    useEffect(() => {
        scrollToBottom();
    }, [messages]);

    const toggleUserMenu = () => {
        setShowUserMenu((prev) => !prev);
    };

    return (
        <div className="relative flex-grow overflow-y-auto p-4 space-y-4">
            {/* User Header */}
            <div className="flex items-center justify-start space-x-4">
                <RiUser3Line className="w-8 h-8 text-primary-500" />
                <p className="font-semibold text-black">{displayName}</p>
            </div>

            {/* Messages */}
            <div className="space-y-4">
                {messages.length === 0 ? (
                    <div className="flex flex-col mt-40 items-center justify-center text-center">
                        <Logo />
                        <p className="text-gray-700">
                            Chào mừng bạn đến với dịch vụ dự đoán bệnh.
                            Nhập triệu chứng của bạn để bắt đầu trò chuyện và nhận hỗ trợ!
                        </p>
                    </div>
                ) : (
                    messages.map((msg) => (
                        <div
                            key={msg.id}
                            className={`flex items-start space-x-2 ${
                                msg.sender === "user" ? "justify-end" : "justify-start"
                            }`}
                        >
                            {msg.sender === "bot" && <RiRobot2Fill className="w-8 h-8 text-primary-500" />}
                            <div
                                className={`p-2 rounded-lg max-w-[70%] ${
                                    msg.sender === "user" ? "bg-primary-500 text-white" : "bg-white text-black border"
                                }`}
                            >
                                {msg.text}
                            </div>
                            {msg.sender === "user" && <RiUser3Line className="w-8 h-8 text-primary-500" />}
                        </div>
                    ))
                )}
                <div ref={messagesEndRef} />
            </div>
        </div>
    );
}
