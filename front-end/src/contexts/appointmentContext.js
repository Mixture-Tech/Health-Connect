import React, { createContext, useState, useContext, useEffect } from 'react';

// Tạo context cho việc đặt lịch
const AppointmentContext = createContext();

// Provider component để bao quanh ứng dụng
export const AppointmentProvider = ({ children }) => {
  const [appointmentData, setAppointmentData] = useState(() => {
    // Khôi phục dữ liệu từ localStorage khi khởi tạo
    const savedAppointmentData = localStorage.getItem('appointmentData');
    return savedAppointmentData 
      ? JSON.parse(savedAppointmentData) 
      : {
          doctor: null,
          schedule: null,
        };
  });

  // Hàm cập nhật thông tin đặt lịch
  const updateAppointmentData = (newData) => {
    setAppointmentData(prev => {
      const updatedData = {
        ...prev,
        ...newData
      };
      
      // Lưu dữ liệu vào localStorage
      localStorage.setItem('appointmentData', JSON.stringify(updatedData));
      
      return updatedData;
    });
  };

  // Thêm effect để đồng bộ hóa với localStorage
  useEffect(() => {
    const handleStorageChange = (e) => {
      if (e.key === 'appointmentData') {
        try {
          const newData = JSON.parse(e.newValue);
          setAppointmentData(newData);
        } catch (error) {
          console.error('Error parsing appointment data:', error);
        }
      }
    };

    // Lắng nghe sự kiện storage từ các tab khác
    window.addEventListener('storage', handleStorageChange);

    return () => {
      window.removeEventListener('storage', handleStorageChange);
    };
  }, []);

  // Thêm hàm để xóa dữ liệu sau khi đặt lịch thành công
  const clearAppointmentData = () => {
    setAppointmentData({
      doctor: null,
      schedule: null,
    });
    localStorage.removeItem('appointmentData');
  };

  return (
    <AppointmentContext.Provider value={{ 
      appointmentData, 
      updateAppointmentData,
      clearAppointmentData 
    }}>
      {children}
    </AppointmentContext.Provider>
  );
};

// Hook để sử dụng context trong các component
export const useAppointmentContext = () => {
  const context = useContext(AppointmentContext);
  if (!context) {
    throw new Error('useAppointmentContext must be used within an AppointmentProvider');
  }
  return context;
};