import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Container, Spinner } from 'react-bootstrap';

const Revenue = () => {
    const [totalRevenue, setTotalRevenue] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        axios.get('http://localhost:8000/api/orders/doanhthu')
            .then(response => {
                setTotalRevenue(response.data.totalRevenue);
            })
            .catch(error => {
                console.error('Error:', error);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, []);

    return (
        <Container style={{ margin: 0 }}>
            <h2>Tổng doanh thu:</h2>
            {isLoading ? (
                <Spinner animation="border" role="status">
                    <span className="visually-hidden">Loading...</span>
                </Spinner>
            ) : (
                totalRevenue !== null && <h2>{totalRevenue}</h2>
            )}
        </Container>
    );
};

export default Revenue;
