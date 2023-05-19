import React, { useState, useContext, useEffect } from 'react';
import axios from 'axios';
import { AuthContext } from './../../components/Auth/AuthContext';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';


function LoginForm() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const { login } = useContext(AuthContext);

    useEffect(() => {
        const isAuthenticated = localStorage.getItem('isAuthenticated');
        const accessToken = localStorage.getItem('accessToken');
        const userData = JSON.parse(localStorage.getItem('userData'));

        if (isAuthenticated && accessToken && userData) {
            login({ isAuthenticated, accessToken, userData });
        }
    }, [login]);

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
                login({ isAuthenticated, accessToken, userData });
            })
            .catch((error) => {
                console.error(error);
            });
    };

    return (
        <Container className="d-flex justify-content-center align-items-center" style={{ height: '100vh' }}>
            <Row style={{ background: '#f7f7f7', padding: '20px', }}>
                <Col>
                    <h1>Trang Đăng nhập</h1>
                    <Form onSubmit={handleSubmit}>
                        <Form.Group controlId="email">
                            <Form.Label>Email:</Form.Label>
                            <Form.Control
                                type="email"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required
                            />
                        </Form.Group>
                        <Form.Group controlId="password">
                            <Form.Label>Mật khẩu:</Form.Label>
                            <Form.Control
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                            />
                        </Form.Group>
                        <br />
                        <Button variant="primary" type="submit">
                            Đăng nhập
                        </Button>
                    </Form>
                </Col>
            </Row>
        </Container>
    );
}

export default LoginForm;
