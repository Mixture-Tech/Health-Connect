import React from 'react';
import { RiChatHistoryLine, RiHome2Line } from 'react-icons/ri';
import { IoIosAdd } from "react-icons/io";

export function ChatHistory({ chatHistory, activeChatId, onLoadChat, onNewChat, onGoHome }) {
    return (
        <div className="w-1/4 bg-gray-200 p-4 overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
                {/* Icon Trở về Trang Chủ */}
                <button 
                    onClick={onGoHome}
                    className="text-primary-500 hover:text-primary-600 focus:outline-none"
                    title="Trở về trang chủ"
                >
                    <RiHome2Line className="w-6 h-6" />
                </button>
                
                {/* Tiêu đề Lịch Sử */}
                <h2 className="text-xl font-bold flex items-center">
                    <RiChatHistoryLine className="mr-2" /> Lịch sử
                </h2>
                
                {/* Icon Tạo Cuộc Trò Chuyện Mới */}
                <button 
                    onClick={onNewChat}
                    className="bg-primary-500 text-white p-1 rounded hover:bg-primary-600"
                    title="New Chat"
                >
                    <IoIosAdd className="w-6 h-6" />
                </button>
            </div>
            
            {/* Danh sách Lịch sử trò chuyện */}
            {chatHistory.map(chat => (
                <div 
                    key={chat.id}
                    onClick={() => onLoadChat(chat.id)}
                    className={`p-2 mb-2 rounded cursor-pointer hover:bg-gray-300 ${
                        activeChatId === chat.id ? 'bg-blue-100' : 'bg-white'
                    }`}
                >
                    <p className="text-sm font-semibold truncate">
                        {chat.messages[1]?.text || 'New Chat'}
                    </p>
                    <p className="text-xs text-gray-500">
                        {chat.timestamp}
                    </p>
                </div>
            ))}
        </div>
    );
}
