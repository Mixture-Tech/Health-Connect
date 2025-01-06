import React from 'react';
import { IoSend } from 'react-icons/io5';

export function ChatInput({ input, onInputChange, onSend }) {
    return (
        <div className="p-4 bg-white border-t flex items-center">
            <input
                type="text"
                value={input}
                onChange={onInputChange}
                onKeyPress={(e) => e.key === "Enter" && onSend()}
                placeholder="Nhập tin nhắn..."
                className="flex-grow p-2 border rounded-l-lg focus:outline-none overflow-y-auto word-wrap"
                style={{
                    maxHeight: '100px', // Giới hạn chiều cao tối đa
                    overflowWrap: 'break-word'
                }}
            />
            <button 
                onClick={onSend} 
                className="bg-primary-500 text-white p-2 rounded-r-lg hover:bg-primary-600"
            >
                <IoSend className="w-6 h-6" />
            </button>
        </div>
    );
}