import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Form } from 'react-bootstrap';

const FoodList = () => {
    const [foods, setFoods] = useState([]);
    const [categories, setCategories] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedFoodId, setSelectedFoodId] = useState(null);
    const [newFood, setNewFood] = useState({
        name: '',
        description: '',
        price: '',
        quantity: '',
        image: null,
        categories_id: '',
    });

    useEffect(() => {
        fetchFoods();
        fetchCategories();
    }, []);

    const fetchFoods = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/product/tatcasanpham', {
                headers: {
                    Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
                },
            });
            setFoods(response.data);
        } catch (error) {
            console.log(error);
        }
    };

    const fetchCategories = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/categories', {
                headers: {
                    Authorization: `Bearer ${localStorage.getItem('accessToken')}`,
                },
            });
            setCategories(response.data);
        } catch (error) {
            console.log(error);
        }
    };


    const handleInputChange = (e) => {
        setNewFood({
            ...newFood,
            [e.target.name]: e.target.value,
        });
    };

    const handleFileChange = (e) => {
        setNewFood({
            ...newFood,
            image: e.target.files[0],
        });
    };

    const handleCreateFood = async (e) => {
        e.preventDefault();
        try {
            const formData = new FormData();
            formData.append('name', newFood.name);
            formData.append('detail', newFood.detail);
            formData.append('price', newFood.price);
            formData.append('quantity', newFood.quantity);
            formData.append('image', newFood.image);
            formData.append('categories_id', newFood.categories_id);
            await axios.post('http://localhost:8000/api/product/create', formData);
            setNewFood({
                name: '',
                detail: '',
                price: '',
                quantity: '',
                image: null,
                categories_id: '',
            });
            fetchFoods();
            setShowModal(false);
            // Fetch foods after the request is completed
            axios
                .get('http://localhost:8000/api/product')
                .then((response) => {
                    setFoods(response.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        } catch (error) {
            console.log(error);
        }
    };

    const handleEditFood = async (e) => {
        e.preventDefault();
        try {
            const formData = new FormData();
            formData.append('name', foods.find((food) => food.id === selectedFoodId).name);
            formData.append('detail', foods.find((food) => food.id === selectedFoodId).detail);
            formData.append('price', foods.find((food) => food.id === selectedFoodId).price);
            formData.append('quantity', foods.find((food) => food.id === selectedFoodId).quantity);
            formData.append('image', newFood.image);
            formData.append('categories_id', newFood.categories_id);
            await axios.put(`http://localhost:8000/api/product/update/${selectedFoodId}`, formData);
            setNewFood({
                name: '',
                detail: '',
                price: '',
                quantity: '',
                image: null,
                categories_id: '',
            });
            setShowModal(false);
            setSelectedFoodId(null);
            // Update foods in the state
            const updatedFoods = foods.map((food) => {
                if (food.id === selectedFoodId) {
                    return {
                        ...food,
                        name: newFood.name,
                        detail: newFood.detail,
                        price: newFood.price,
                        quantity: newFood.quantity,
                        categories_id: newFood.categories_id,
                    };
                }
                return food;
            });
            setFoods(updatedFoods);

            // Save the update to the database
            await axios.put(`http://localhost:8000/api/product/update/${selectedFoodId}`, {
                name: newFood.name,
                detail: newFood.detail,
                price: newFood.price,
                quantity: newFood.quantity,
                categories_id: newFood.categories_id,
            });
            fetchFoods();
        } catch (error) {
            console.log(error);
        }
    };

    const handleDeleteFood = async (foodId) => {
        try {
            await axios.delete(`http://localhost:8000/api/product/delete/${foodId}`);
            fetchFoods();
        } catch (error) {
            console.log(error);
        }
    };

    const handleShowModal = (foodId = null) => {
        const selectedFood = foods.find((food) => food.id === foodId);

        setNewFood({
            name: selectedFood ? selectedFood.name : '',
            detail: selectedFood ? selectedFood.detail : '',
            price: selectedFood ? selectedFood.price : '',
            quantity: selectedFood ? selectedFood.quantity : '',
            image: null,
            categories_id: selectedFood ? selectedFood.categories_id : '',
        });

        setSelectedFoodId(foodId);
        setShowModal(true);
    };

    const handleCloseModal = () => {
        setShowModal(false);
        setSelectedFoodId(null);
    };

    return (
        <div>
            <Button onClick={() => handleShowModal()}>Thêm món ăn</Button>

            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedFoodId ? 'Chỉnh sửa món' : 'Tạo món'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={selectedFoodId ? handleEditFood : handleCreateFood}>
                        <Form.Group>
                            <Form.Label>Tên món ăn:</Form.Label>
                            <Form.Control type="text" name="name" value={newFood.name} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Mô tả:</Form.Label>
                            <Form.Control type="text" name="detail" value={newFood.detail} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Giá:</Form.Label>
                            <Form.Control type="text" name="price" value={newFood.price} onChange={handleInputChange} />
                        </Form.Group>

                        <Form.Group>
                            <Form.Label>Số lượng:</Form.Label>
                            <Form.Control type="text" name="quantity" value={newFood.quantity} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Hình ảnh:</Form.Label>
                            <Form.Control type="file" name="image" accept="image/*" onChange={handleFileChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Danh mục:</Form.Label>
                            <Form.Control
                                as="select"
                                name="categories_id"
                                value={newFood.categories_id}
                                onChange={handleInputChange}
                            >
                                {categories.map((category) => (
                                    <option key={category.id} value={category.id}>
                                        {category.name}
                                    </option>
                                ))}
                            </Form.Control>
                        </Form.Group>
                        <br />
                        <Button variant="primary" type="submit">
                            {selectedFoodId ? 'Chỉnh sửa món' : 'Tạo món'}
                        </Button>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Hủy
                    </Button>
                </Modal.Footer>
            </Modal>

            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Mã món</th>
                        <th>Tên món</th>
                        <th>Mô tả</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Hình ảnh</th>
                        <th>Danh mục</th>
                        <th>Tùy chọn</th>
                    </tr>
                </thead>
                <tbody>
                    {foods.map((food) => (
                        <tr key={food.id}>
                            <td>{food.id}</td>
                            <td>{food.name}</td>
                            <td style={{ width: '450px' }}>{food.detail}</td>
                            <td>{food.price}</td>
                            <td>{food.quantity}</td>
                            <td>
                                <img src={`http://127.0.0.1:8000/upload/product/${food.image}`} alt={food.name} style={{ width: '100px' }} />
                            </td>
                            <td>{categories.find(category => category.id === food.category_id)?.name}</td>
                            <td style={{ width: '200px' }}>
                                <Button variant="info" onClick={() => handleShowModal(food.id)}>
                                    Chỉnh sửa
                                </Button>
                                <span style={{ marginLeft: '10px' }}></span>
                                <Button variant="danger" onClick={() => handleDeleteFood(food.id)}>
                                    Xóa
                                </Button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>
        </div>
    );
};

export default FoodList;
