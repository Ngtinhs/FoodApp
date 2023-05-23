import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Container, Spinner, Button, Form } from 'react-bootstrap';
import { Chart, CategoryScale, LinearScale, BarElement, BarController } from 'chart.js';
import { Bar } from 'react-chartjs-2';

Chart.register(CategoryScale, LinearScale, BarElement, BarController);

const Revenue = () => {
    const [totalRevenue, setTotalRevenue] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [revenueData, setRevenueData] = useState([]);
    const [chartData, setChartData] = useState({});
    const [filterData, setFilterData] = useState([]);
    const [filterStartDate, setFilterStartDate] = useState('');
    const [filterEndDate, setFilterEndDate] = useState('');
    const [showNoDataMessage, setShowNoDataMessage] = useState(false);
    const [isFiltering, setIsFiltering] = useState(false);

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
        if (isFiltering && filterStartDate && filterEndDate) {
            filterChartData();
        }
    }, [isFiltering, filterStartDate, filterEndDate]);

    const filterChartData = () => {
        const filteredData = revenueData.filter(revenueItem => {
            const date = Object.keys(revenueItem)[0];
            return date >= filterStartDate && date <= filterEndDate;
        });

        setFilterData(filteredData);

        const chartLabels = filteredData.map(revenueItem => Object.keys(revenueItem)[0]);
        const chartDataValues = filteredData.map(revenueItem => revenueItem[Object.keys(revenueItem)[0]]);

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

        setShowNoDataMessage(filteredData.length === 0);
    };

    const handleFilterSubmit = event => {
        event.preventDefault();
        setIsFiltering(true);
    };
    return (
        <Container style={{ margin: 0 }}>
            <h2>Tổng doanh thu:</h2>
            {isLoading ? (
                <Spinner animation="border" role="status">
                    <span className="visually-hidden">Loading...</span>
                </Spinner>
            ) : (
                <div>
                    <h2>{totalRevenue}</h2>
                    <br />
                    <br />
                    <h2>Theo doanh thu theo ngày:</h2>
                    <Form onSubmit={handleFilterSubmit}>
                        <div className="row">
                            <div className="col">
                                <Form.Control
                                    type="date"
                                    value={filterStartDate}
                                    onChange={event => setFilterStartDate(event.target.value)}
                                />
                            </div>
                            <div className="col">
                                <Form.Control
                                    type="date"
                                    value={filterEndDate}
                                    onChange={event => setFilterEndDate(event.target.value)}
                                />
                            </div>
                            <div className="col-auto">
                                <Button
                                    type="submit"
                                    variant="primary"
                                    disabled={!filterStartDate || !filterEndDate}
                                >
                                    Lọc
                                </Button>
                            </div>
                        </div>
                    </Form>

                    {showNoDataMessage ? (
                        <p>Không có dữ liệu trong khoảng thời gian đã chọn.</p>
                    ) : (
                        filterData.length > 0 && (
                            <div style={{ height: '400px', marginTop: '20px' }}>
                                <Bar
                                    data={chartData}
                                    options={{
                                        responsive: true,
                                        maintainAspectRatio: false,
                                    }}
                                />
                            </div>
                        )
                    )}
                </div>
            )}
        </Container>
    );
};

export default Revenue;
