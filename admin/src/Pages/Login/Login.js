import React, { useState, useContext } from 'react';
import axios from 'axios';
import { AuthContext } from './../../components/Auth/AuthContext';

function LoginForm() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const { login } = useContext(AuthContext);

    const handleSubmit = (e) => {
        e.preventDefault();

        axios
            .post('http://localhost:8000/api/login', {
                email: email,
                password: password
            })
            .then((response) => {
                const accessToken = response.data.token;
                const userData = response.data.users;
                const isAuthenticated = true;
                localStorage.setItem('isAuthenticated', JSON.stringify(isAuthenticated));
                localStorage.setItem('accessToken', accessToken);
                localStorage.setItem('userData', JSON.stringify(userData));
                // Gọi hàm login từ AuthContext để thiết lập thông tin xác thực và isAuthenticated
                login({ isAuthenticated, accessToken, userData });
                localStorage.setItem('accessToken', accessToken);

            })
            .catch((error) => {
                console.error(error);
            });
    };

    return (
        <div>
            <h1>Trang Đăng nhập</h1>
            <form onSubmit={handleSubmit}>
                <label htmlFor="email">Email:</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                />
                <br />
                <br />
                <label htmlFor="password">Mật khẩu:</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                />
                <br />
                <br />
                <button type="submit">Đăng nhập</button>
            </form>
        </div>
    );
}

export default LoginForm;
