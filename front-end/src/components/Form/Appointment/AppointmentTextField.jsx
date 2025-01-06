import React from 'react'

export default function AppointmentTextField({ 
  icon: Icon, 
  type = "text", 
  placeholder, 
  value = '', // Thêm prop value với giá trị mặc định là chuỗi rỗng
  onChange, // Thêm prop onChange để xử lý sự kiện thay đổi
  readOnly = false, // Thêm prop readOnly để có thể disable việc chỉnh sửa
  className = '' // Thêm prop className để có thể tùy chỉnh thêm class
}) {
  return (
    <div className={`w-[100%] relative ${className}`}>
      <Icon className="absolute top-3.5 left-3 text-[1.5rem] text-secondary-300" />
      <input
        type={type}
        placeholder={placeholder}
        value={value} // Bind giá trị value
        onChange={onChange} // Gán sự kiện onChange
        readOnly={readOnly} // Áp dụng thuộc tính readOnly
        className="peer border-secondary-100 border rounded-md outline-none pl-12 pr-4 py-3 w-full focus:border-primary transition-colors duration-300 
        disabled:bg-gray-100 disabled:cursor-not-allowed" // Thêm style cho trạng thái readOnly
      />
    </div>
  );
}