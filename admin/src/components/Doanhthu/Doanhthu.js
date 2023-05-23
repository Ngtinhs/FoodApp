import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Container, Spinner } from 'react-bootstrap';
import { Chart, CategoryScale, LinearScale, BarElement, BarController } from 'chart.js';
import { Bar } from 'react-chartjs-2';

Chart.register(CategoryScale, LinearScale, BarElement, BarController);

const Revenue = () => {
    const [totalRevenue, setTotalRevenue] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [revenueData, setRevenueData] = useState([]);
    const [chartData, setChartData] = useState({});

    useEffect(() => {
        axios
            .get('http://localhost:8000/api/cart/revenue')
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

    useEffect(() => {
        axios
            .get('http://localhost:8000/api/cart/doanhthungay')
            .then(response => {
                setRevenueData(response.data);
            })
            .catch(error => {
                console.error('Error:', error);
            })
            .finally(() => {
                setIsLoading(false);
            });
    }, []);

    useEffect(() => {
        const chartLabels = revenueData.map(revenueItem => Object.keys(revenueItem)[0]);
        const chartDataValues = revenueData.map(revenueItem => revenueItem[Object.keys(revenueItem)[0]]);

        const chartData = {
            labels: chartLabels,
            datasets: [
                {
                    label: 'Tổng doanh thu',
                    data: chartDataValues,
                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                },
            ],
        };

        setChartData(chartData);
    }, [revenueData]);

    return (
        <Container style={{ margin: 0 }}>
            <h2>Tổng doanh thu:</h2>
            {isLoading ? (
                <Spinner animation="border" role="status">
                    <span className="visually-hidden">Loading...</span>
                </Spinner>
            ) : (
                <div>
                    {totalRevenue !== null && <h2>{totalRevenue}</h2>}
                    {chartData.labels.length > 0 && (
                        <div style={{ height: '400px', marginTop: '20px' }}>
                            <Bar
                                data={chartData}
                                options={{
                                    responsive: true,
                                    maintainAspectRatio: false,
                                }}
                            />
                        </div>
                    )}
                </div>
            )}
        </Container>
    );
};

export default Revenue;
