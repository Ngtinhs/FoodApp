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
            <Button onClick={() => handleShowModal()}>Create Food</Button>

            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedFoodId ? 'Edit Food' : 'Create Food'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={selectedFoodId ? handleEditFood : handleCreateFood}>
                        <Form.Group>
                            <Form.Label>Name:</Form.Label>
                            <Form.Control type="text" name="name" value={newFood.name} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Detail:</Form.Label>
                            <Form.Control type="text" name="detail" value={newFood.detail} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Price:</Form.Label>
                            <Form.Control type="text" name="price" value={newFood.price} onChange={handleInputChange} />
                        </Form.Group>

                        <Form.Group>
                            <Form.Label>Quantity:</Form.Label>
                            <Form.Control type="text" name="quantity" value={newFood.quantity} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Image:</Form.Label>
                            <Form.Control type="file" name="image" accept="image/*" onChange={handleFileChange} />
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
                        <th>Description</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Image</th>
                        <th>Category</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    {foods.map((food) => (
                        <tr key={food.id}>
                            <td>{food.id}</td>
                            <td>{food.name}</td>
                            <td>{food.detail}</td>
                            <td>{food.price}</td>
                            <td>{food.quantity}</td>
                            <td>
                                <img src={`/upload/foods/${food.image}`} alt={food.name} style={{ width: '100px' }} />
                            </td>
                            <td>{categories.find(category => category.id === food.category_id)?.name}</td>
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
