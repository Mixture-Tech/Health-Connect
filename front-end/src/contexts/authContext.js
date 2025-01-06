// // authContext.js
// import React, { createContext, useState, useContext, useEffect } from 'react';
// import Cookies from 'js-cookie';
// import { StorageKeys } from '../services/key/keys';

// const AuthContext = createContext(undefined);

// export const AuthProvider = ({ children }) => {
//   const [user, setUser] = useState(null);
//   const [token, setToken] = useState(null);

//   useEffect(() => {
//     // Khôi phục thông tin người dùng khi reload trang
//     const storedToken = Cookies.get(StorageKeys.ACCESS_TOKEN);
//     const storedName = localStorage.getItem(StorageKeys.USER_NAME);
//     const storedRole = localStorage.getItem(StorageKeys.USER_ROLE);
//     const storedPhone = localStorage.getItem(StorageKeys.USER_PHONE);
//     const storedEmail = localStorage.getItem(StorageKeys.USER_EMAIL);

//     if (storedToken && storedName) {
//       setUser({
//         name: storedName,
//         role: storedRole || '',
//         phone: storedPhone || '',
//         email: storedEmail || ''
//       });
//       setToken(storedToken);
//     }
//   }, []);

//   const login = (userData, authToken) => {
//     // Lưu thông tin người dùng
//     setUser(userData);
//     setToken(authToken);

//     // Lưu vào localStorage và Cookies
//     localStorage.setItem(StorageKeys.USER_NAME, userData.name);
//     localStorage.setItem(StorageKeys.USER_ROLE, userData.role);
//     localStorage.setItem(StorageKeys.USER_PHONE, userData.phone);
//     localStorage.setItem(StorageKeys.USER_EMAIL, userData.email);
//     Cookies.set(StorageKeys.ACCESS_TOKEN, authToken);
//   };

//   const logout = () => {
//     // Xóa thông tin người dùng
//     setUser(null);
//     setToken(null);

//     // Xóa localStorage và Cookies
//     localStorage.removeItem(StorageKeys.USER_NAME);
//     localStorage.removeItem(StorageKeys.USER_ROLE);
//     localStorage.removeItem(StorageKeys.USER_PHONE);
//     localStorage.removeItem(StorageKeys.USER_EMAIL);
//     Cookies.remove(StorageKeys.ACCESS_TOKEN);
//   };

//   return (
//     <AuthContext.Provider value={{ user, token, login, logout }}>
//       {children}
//     </AuthContext.Provider>
//   );
// };

// // Hook để sử dụng context
// export const useAuth = () => {
//   const context = useContext(AuthContext);
//   if (context === undefined) {
//     throw new Error('useAuth must be used within an AuthProvider');
//   }
//   return context;
// };
