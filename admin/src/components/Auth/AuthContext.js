import React, { createContext, useState } from 'react';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [authData, setAuthData] = useState(null); // Thông tin xác thực

    const login = (data) => {
        setAuthData(data);
        setIsAuthenticated(data.isAuthenticated);
        console.log(data)
    };


    const logout = () => {
        // Xử lý logic đăng xuất và thiết lập isAuthenticated thành false
        setIsAuthenticated(false);
        setAuthData(null); // Xóa thông tin xác thực
    };

    return (
        <AuthContext.Provider value={{ isAuthenticated, authData, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};
