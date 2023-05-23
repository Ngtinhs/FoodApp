import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Form } from 'react-bootstrap';

const UserList = () => {
    const [users, setUsers] = useState([]);
    const [selectedUser, setSelectedUser] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const [updatedName, setUpdatedName] = useState('');
    const [updatedEmail, setUpdatedEmail] = useState('');
    const [updatedPhone, setUpdatedPhone] = useState('');
    const [updatedAddress, setUpdatedAddress] = useState('');

    // Lấy danh sách người dùng từ API
    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = () => {
        axios
            .get('http://localhost:8000/api/users')
            .then((response) => {
                setUsers(response.data);
            })
            .catch((error) => {
                console.error(error);
            });
    };

    // Xóa người dùng
    const deleteUser = (userId) => {
        axios
            .delete(`http://localhost:8000/api/users/${userId}`)
            .then((response) => {
                console.log(response.data.message);
                // Cập nhật danh sách người dùng sau khi xóa thành công
                fetchUsers();
            })
            .catch((error) => {
                console.error(error);
            });
    };

    // Mở modal và chọn người dùng để cập nhật
    const openModal = (user) => {
        setSelectedUser(user);
        setUpdatedName(user.name);
        setUpdatedEmail(user.email);
        setUpdatedPhone(user.phone);
        setUpdatedAddress(user.address);
        setShowModal(true);
    };

    // Đóng modal
    const closeModal = () => {
        setSelectedUser(null);
        setUpdatedName('');
        setUpdatedEmail('');
        setUpdatedPhone('');
        setUpdatedAddress('');
        setShowModal(false);
    };

    // Cập nhật người dùng
    const updateUser = () => {
        const userData = {
            name: updatedName,
            email: updatedEmail,
            phone: updatedPhone,
            address: updatedAddress,
        };

        axios
            .put(`http://localhost:8000/api/users/${selectedUser.id}`, userData)
            .then((response) => {
                console.log(response.data.message);

                // Cập nhật thông tin người dùng sau khi cập nhật thành công
                const updatedUsers = users.map((user) => {
                    if (user.id === selectedUser.id) {
                        return { ...user, ...userData };
                    }
                    return user;
                });

                setUsers(updatedUsers);
                closeModal();
            })
            .catch((error) => {
                console.error(error);
            });
    };


    return (
        <div>
            <h1>Danh sách người dùng</h1>
            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {users.map((user) => (
                        <tr key={user.id}>
                            <td>{user.id}</td>
                            <td>{user.name}</td>
                            <td>{user.email}</td>
                            <td>{user.phone}</td>
                            <td>{user.address}</td>
                            <td>
                                <Button variant="info" onClick={() => openModal(user)}>Edit</Button>
                                <Button variant="danger" onClick={() => deleteUser(user.id)}>Delete</Button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>

            <Modal show={showModal} onHide={closeModal}>
                <Modal.Header closeButton>
                    <Modal.Title>Update User</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group controlId="formBasicName">
                            <Form.Label>Name</Form.Label>
                            <Form.Control
                                type="text"
                                placeholder="Enter name"
                                value={updatedName}
                                onChange={(e) => setUpdatedName(e.target.value)}
                            />
                        </Form.Group>
                        <Form.Group controlId="formBasicEmail">
                            <Form.Label>Email</Form.Label>
                            <Form.Control
                                type="email"
                                placeholder="Enter email"
                                value={updatedEmail}
                                onChange={(e) => setUpdatedEmail(e.target.value)}
                            />
                        </Form.Group>
                        <Form.Group controlId="formBasicPhone">
                            <Form.Label>Phone</Form.Label>
                            <Form.Control
                                type="text"
                                placeholder="Enter phone"
                                value={updatedPhone}
                                onChange={(e) => setUpdatedPhone(e.target.value)}
                            />
                        </Form.Group>
                        <Form.Group controlId="formBasicAddress">
                            <Form.Label>Address</Form.Label>
                            <Form.Control
                                type="text"
                                placeholder="Enter address"
                                value={updatedAddress}
                                onChange={(e) => setUpdatedAddress(e.target.value)}
                            />
                        </Form.Group>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="primary" onClick={updateUser}>
                        Update
                    </Button>
                    <Button variant="secondary" onClick={closeModal}>
                        Cancel
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
};

export default UserList;
