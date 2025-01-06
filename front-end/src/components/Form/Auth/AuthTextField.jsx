import React from "react";

export default function InputField({ label, type, placeholder, icon: Icon, value, onChange }) {
    return (
        <div className="mb-1.5">
            {/* Nhãn của input */}
            <label className="block text-gray-700 text-sm font-semibold mb-2">
                {label}
            </label>
            <div className="flex items-center border rounded-lg px-3 py-2 focus-within:ring-2 focus-within:ring-blue-500">
                {/* Hiển thị icon nếu được cung cấp */}
                {Icon && <Icon className="text-gray-500 mr-3" />}
                <input
                    type={type} // Loại input (text, password, ...)
                    placeholder={placeholder} // Placeholder hiển thị
                    value={value} // Giá trị hiện tại của input
                    onChange={onChange} // Hàm xử lý sự kiện thay đổi giá trị
                    className="w-full focus:outline-none"
                />
            </div>
        </div>
    );
}
