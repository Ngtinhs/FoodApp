import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Form } from 'react-bootstrap';

const FoodList = () => {
    const [foods, setFoods] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedFoodId, setSelectedFoodId] = useState(null);
    const [newFood, setNewFood] = useState({
        name: '',
        image: null,
        price: 0,
        detail: '',
        quantity: 0,
        categories_id: 0,
    });
    const [categories, setCategories] = useState([]);

    useEffect(() => {
        fetchFoods();
        fetchCategories();
    }, []);

    const fetchFoods = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/product/tatcasanpham');
            setFoods(response.data);
        } catch (error) {
            console.log(error);
        }
    };

    const fetchCategories = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/categories');
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
            const accessToken = localStorage.getItem('accessToken');
            const formData = new FormData();
            formData.append('name', newFood.name);
            formData.append('image', newFood.image);
            formData.append('price', newFood.price);
            formData.append('detail', newFood.detail);
            formData.append('quantity', newFood.quantity);
            formData.append('categories_id', newFood.categories_id);
            await axios.post('http://localhost:8000/api/product/create', formData, {
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            setNewFood({
                name: '',
                image: null,
                price: 0,
                detail: '',
                quantity: 0,
                categories_id: 0,
            });
            setShowModal(false);
            fetchFoods();
        } catch (error) {
            console.log(error);
        }
    };

    const handleEditFood = async (e) => {
        e.preventDefault();
        try {
            const accessToken = localStorage.getItem('accessToken');
            const formData = new FormData();
            formData.append('name', newFood.name);
            formData.append('image', newFood.image);
            formData.append('price', newFood.price);
            formData.append('detail', newFood.detail);
            formData.append('quantity', newFood.quantity);
            formData.append('categories_id', newFood.categories_id);
            await axios.put(
                `http://localhost:8000/api/product/edit/${selectedFoodId}`,
                formData,
                {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                }
            );
            setNewFood({
                name: '',
                image: null,
                price: 0,
                detail: '',
                quantity: 0,
                categories_id: 0,
            });
            setShowModal(false);
            setSelectedFoodId(null);
            const updatedFoods = foods.map((food) => {
                if (food.id === selectedFoodId) {
                    return {
                        ...food,
                        ...newFood,
                    };
                }
                return food;
            });
            setFoods(updatedFoods);
        } catch (error) {
            console.log(error);
        }
    };

    const handleDeleteFood = async (foodId) => {
        try {
            const accessToken = localStorage.getItem('accessToken');
            await axios.delete(`http://localhost:8000/api/product/delete/${foodId}`, {
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            fetchFoods();
        } catch (error) {
            console.log(error);
        }
    };

    const handleOpenModal = (foodId) => {
        setShowModal(true);
        setSelectedFoodId(foodId);
        const selectedFood = foods.find((food) => food.id === foodId);
        setNewFood({
            name: selectedFood.name,
            image: null,
            price: selectedFood.price,
            detail: selectedFood.detail,
            quantity: selectedFood.quantity,
            categories_id: selectedFood.categories_id,
        });
    };

    const handleCloseModal = () => {
        setShowModal(false);
        setSelectedFoodId(null);
        setNewFood({
            name: '',
            image: null,
            price: 0,
            detail: '',
            quantity: 0,
            categories_id: 0,
        });
    };

    return (
        <div>
            <Button variant="primary" onClick={() => setShowModal(true)}>
                Add Food
            </Button>
            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Image</th>
                        <th>Price</th>
                        <th>Detail</th>
                        <th>Quantity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foods.map((food) => (
                        <tr key={food.id}>
                            <td>{food.name}</td>
                            <td>
                                <img src={food.image} alt={food.name} width="100" height="100" />
                            </td>
                            <td>{food.price}</td>
                            <td>{food.detail}</td>
                            <td>{food.quantity}</td>
                            <td>
                                <Button variant="primary" onClick={() => handleOpenModal(food.id)}>
                                    Edit
                                </Button>
                                <Button variant="danger" onClick={() => handleDeleteFood(food.id)}>
                                    Delete
                                </Button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </Table>

            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedFoodId ? 'Edit Food' : 'Add Food'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={selectedFoodId ? handleEditFood : handleCreateFood}>
                        <Form.Group>
                            <Form.Label>Name:</Form.Label>
                            <Form.Control
                                type="text"
                                name="name"
                                value={newFood.name}
                                onChange={handleInputChange}
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Image:</Form.Label>
                            <Form.Control type="file" onChange={handleFileChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Price:</Form.Label>
                            <Form.Control
                                type="number"
                                name="price"
                                value={newFood.price}
                                onChange={handleInputChange}
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Detail:</Form.Label>
                            <Form.Control
                                as="textarea"
                                rows={3}
                                name="detail"
                                value={newFood.detail}
                                onChange={handleInputChange}
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Quantity:</Form.Label>
                            <Form.Control
                                type="number"
                                name="quantity"
                                value={newFood.quantity}
                                onChange={handleInputChange}
                            />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Category:</Form.Label>
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
                        <Button variant="primary" type="submit">
                            {selectedFoodId ? 'Save Changes' : 'Create Food'}
                        </Button>
                    </Form>
                </Modal.Body>
            </Modal>
        </div>
    );
};

export default FoodList;
