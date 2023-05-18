import React, { useEffect, useState } from 'react';
import axios from 'axios';

const OrderList = () => {
    const [orders, setOrders] = useState([]);

    useEffect(() => {
        axios.get('http://localhost:8000/api/orders')
            .then(response => {
                // Cập nhật state 'orders' với dữ liệu đơn hàng từ API
                setOrders(response.data.orders);
            })
            .catch(error => {
                console.error('Error fetching order list:', error);
            });
    }, []);

    // Hàm xác nhận xóa đơn hàng
    const handleDelete = (orderId) => {
        const confirmDelete = window.confirm("Are you sure you want to delete this order?");
        if (confirmDelete) {
            axios.delete(`http://localhost:8000/api/orders/${orderId}`)
                .then(response => {
                    // Xóa đơn hàng khỏi danh sách
                    const updatedOrders = orders.filter(order => order._id !== orderId);
                    setOrders(updatedOrders);
                })
                .catch(error => {
                    console.error(`Error deleting order ${orderId}:`, error);
                });
        }
    }

    return (
        <div>
            <ul className="list-group">
                {Array.isArray(orders) && orders.length > 0 ? (
                    orders.map(order => (
                        <li key={order._id} className="list-group-item">
                            <strong>Username:</strong> {order.username}<br />
                            <strong>Address:</strong> {order.address}<br />
                            <strong>Total:</strong> {order.total}<br />
                            {/* <strong>Status:</strong> {order.status}<br /> */}
                            <strong>Details:</strong>
                            {Array.isArray(order.orderDetails) && order.orderDetails.length > 0 ? (
                                <ul>
                                    {order.orderDetails.map(product => (
                                        <li key={product._id}>
                                            <strong>{product.title}</strong><br />
                                            <strong>Description:</strong> {product.description}<br />
                                            <strong>Price:</strong> {product.price}<br />
                                        </li>
                                    ))}
                                </ul>
                            ) : (
                                <p>No order details available.</p>
                            )}
                            <button onClick={() => handleDelete(order._id)}>Delete Order</button>
                        </li>
                    ))
                ) : (
                    <p>No orders available.</p>
                )}
            </ul>
        </div>
    );
};

export default OrderList;
