import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Container, Spinner } from 'react-bootstrap';

const Revenue = () => {
    const [totalRevenue, setTotalRevenue] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [revenueData, setRevenueData] = useState([]);

    useEffect(() => {
        axios.get('http://localhost:8000/api/cart/revenue')
            .then(response => {
                setTotalRevenue(response.data.totalRevenue);
            })
            .catch(error => {
                console.error('Error:', error);
            })
            .finally(() => {
                setIsLoading(false);
            });

        axios.get('http://localhost:8000/api/cart/doanhthungay')
            .then(response => {
                setRevenueData(response.data);
            })
            .catch(error => {
                console.error('Error:', error);
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
                <>
                    {totalRevenue !== null && <h2>{totalRevenue}</h2>}
                    {revenueData.map((revenueItem, index) => {
                        const date = Object.keys(revenueItem)[0];
                        const revenue = revenueItem[date];

                        return (
                            <div key={index}>
                                <h3>Tổng doanh thu ngày {date} là {revenue}</h3>
                                <br />
                            </div>
                        );
                    })}
                </>
            )}
        </Container>
    );
};

export default Revenue;
