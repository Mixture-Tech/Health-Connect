import { useState } from "react";

const RadioButton = ({ label, isChecked = false, onToggle }) => {
  return (
    <div className="flex items-center gap-4">
      <div 
        className="w-4 h-4 border border-secondary-300 rounded-full flex items-center justify-center cursor-pointer"
        onClick={onToggle}
      >
        <div 
          className={`w-2 h-2 transition-all duration-200 rounded-full
            ${isChecked ? "bg-secondary-300 scale-100" : "bg-transparent scale-75"}`}
        />
      </div>
      
      {label && (
        <p 
          className="cursor-pointer" 
          onClick={onToggle}
        >
          {label}
        </p>
      )}
    </div>
  );
};

export default RadioButton;

// Usage example:

/*
import React, { useState } from "react";
import RadioButton from "../../../components/Form/TextField/RadioButton";

const Inputs = () => {
  const [selectedGender, setSelectedGender] = useState(""); // State lưu trữ giới tính được chọn

  return (
    <div className="space-y-4">
      <RadioButton
        label="Đặt cho mình"
        isChecked={selectedGender === "Đặt cho mình"} // Kiểm tra nếu "Nam" đang được chọn
        onToggle={() => setSelectedGender("Đặt cho mình")} // Cập nhật giới tính thành "Nam"
      />
      <RadioButton
        label="Đặt cho người thân"
        isChecked={selectedGender === "Đặt cho người thân"} // Kiểm tra nếu "Nữ" đang được chọn
        onToggle={() => setSelectedGender("Đặt cho người thân")} // Cập nhật giới tính thành "Nữ"
      />
    </div>
  );
};

export default Inputs;

*/