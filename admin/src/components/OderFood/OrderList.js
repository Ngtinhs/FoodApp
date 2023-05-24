import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Form } from 'react-bootstrap';

const OrderList = () => {
    const [orders, setOrders] = useState([]);

    useEffect(() => {
        fetchOrders();
    }, []);

    const fetchOrders = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/cart/allorders');
            setOrders(response.data);
        } catch (error) {
            console.log(error);
        }
    };

    const handleUpdateStatus = async (orderId, newStatus) => {
        try {
            await axios.put(`http://localhost:8000/api/cart/updatestatus/${orderId}`, { status: newStatus });
            fetchOrders(); // Fetch orders again to update the list
        } catch (error) {
            console.log(error);
        }
    };

    const getStatusLabel = (status) => {
        switch (status) {
            case 0:
                return 'Đang xử lý';
            case 1:
                return 'Đang giao hàng';
            case 2:
                return 'Thành công';
            case 3:
                return 'Đã hủy';
            default:
                return '';
        }
    };

    const renderActions = (order) => {
        const { id, status } = order;

        switch (status) {
            case 0:
                return (
                    <div>
                        <Button variant="primary" onClick={() => handleUpdateStatus(id, 1)}>Giao hàng</Button>
                        <Button variant="danger" onClick={() => handleUpdateStatus(id, 3)}>Hủy đơn</Button>
                    </div>
                );
            case 1:
                return (
                    <div>
                        <Button variant="primary" onClick={() => handleUpdateStatus(id, 2)}>Hoàn thành</Button>
                    </div>
                );
            case 2:
                return (
                    <div>
                        <p>Đã hoàn thành</p>
                        {/* <Button variant="primary">Xem chi tiết</Button> */}
                    </div>
                );
            case 3:
                return (
                    <div>
                        <p>Đơn hàng đã hủy</p>
                        <Button variant="info" onClick={() => handleUpdateStatus(id, 0)}>Đặt lại</Button>
                    </div>
                );
            default:
                return null;
        }
    };

    return (
        <div>
            <h1>Danh sách đơn</h1>
            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Tên</th>
                        <th>Số điện thoại</th>
                        <th>Địa chỉ</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Mã người dùng</th>
                        <th>Ngày tạo đơn</th>
                        <th>Lần cuối cập nhật</th>
                        <th>Ghi chú</th>
                        <th>Tùy chọn</th>
                    </tr>
                </thead>
                <tbody>
                    {orders.map((order) => (
                        <tr key={order.id}>
                            <td>{order.id}</td>
                            <td>{order.name}</td>
                            <td>{order.phone}</td>
                            <td>{order.address}</td>
                            <td>{order.total_price}</td>
                            <td>{getStatusLabel(order.status)}</td>
                            <td>{order.user_id}</td>
                            <td>{order.created_at}</td>
                            <td>{order.updated_at}</td>
                            <td>{order.note}</td>
                            <td>{renderActions(order)}</td>
                        </tr>
                    ))}
                </tbody>
            </Table>
        </div>
    );
};

export default OrderList;
