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
    });

    useEffect(() => {
        fetchFoods();
    }, []);

    const fetchFoods = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/product/tatcasanpham');
            setFoods(response.data);
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
            formData.append('image', newFood.image);
            formData.append('price', newFood.price);
            formData.append('detail', newFood.detail);
            formData.append('quantity', newFood.quantity);
            await axios.post('http://localhost:8000/api/product/create', formData);
            setNewFood({
                name: '',
                image: null,
                price: 0,
                detail: '',
                quantity: 0,
            });
            setShowModal(false);
            fetchFoods(); // Fetch foods after the request is completed
        } catch (error) {
            console.log(error);
        }
    };

    const handleEditFood = async (e) => {
        e.preventDefault();
        try {
            const formData = new FormData();
            formData.append('name', newFood.name);
            formData.append('image', newFood.image);
            formData.append('price', newFood.price);
            formData.append('detail', newFood.detail);
            formData.append('quantity', newFood.quantity);
            await axios.put(`http://localhost:8000/api/product/update/${selectedFoodId}`, formData);
            setNewFood({
                name: '',
                image: null,
                price: 0,
                detail: '',
                quantity: 0,
            });
            setShowModal(false);
            setSelectedFoodId(null);
            const updatedFoods = foods.map((food) => {
                if (food.id === selectedFoodId) {
                    return {
                        ...food,
                        name: newFood.name,
                    };
                }
                return food;
            });
            setFoods(updatedFoods);
            await axios.put(`http://localhost:8000/api/product/update/${selectedFoodId}`, {
                name: newFood.name,
            });
            fetchFoods(); // Fetch foods after the update is completed
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
            image: null,
            price: selectedFood ? selectedFood.price : 0,
            detail: selectedFood ? selectedFood.detail : '',
            quantity: selectedFood ? selectedFood.quantity : 0,
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
            <h1>Food List</h1>

            <Button onClick={() => handleShowModal()}>Create Food</Button>

            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedFoodId ? 'Edit Food' : 'Create Food'}</Modal.Title>
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
                            <Form.Control
                                type="file"
                                name="image"
                                accept="image/*"
                                onChange={handleFileChange}
                            />
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
                        <Button variant="primary" type="submit">
                            {selectedFoodId ? 'Update Food' : 'Create Food'}
                        </Button>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Close
                    </Button>
                </Modal.Footer>
            </Modal>

            <Table striped bordered hover>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Image</th>
                        <th>Price</th>
                        <th>Detail</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    {foods.map((food) => (
                        <tr key={food.id}>
                            <td>{food.id}</td>
                            <td>{food.name}</td>
                            <td>
                                <img
                                    src={`/upload/foods/${food.image}`}
                                    alt={food.name}
                                    style={{ width: '100px' }}
                                />
                            </td>
                            <td>{food.price}</td>
                            <td>{food.detail}</td>
                            <td>{food.quantity}</td>
                            <td>
                                <Button variant="primary" onClick={() => handleShowModal(food.id)}>
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
        </div>
    );
};

export default FoodList;
