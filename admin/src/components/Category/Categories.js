import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Table, Button, Modal, Form } from 'react-bootstrap';

const CategoriesList = () => {
    const [categories, setCategories] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedCategoryId, setSelectedCategoryId] = useState(null);
    const [newCategory, setNewCategory] = useState({
        name: '',
        image: null,
    });

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            const response = await axios.get('http://localhost:8000/api/categories');
            setCategories(response.data);
        } catch (error) {
            console.log(error);
        }
    };

    const handleInputChange = (e) => {
        setNewCategory({
            ...newCategory,
            [e.target.name]: e.target.value,
        });
    };

    const handleFileChange = (e) => {
        setNewCategory({
            ...newCategory,
            image: e.target.files[0],
        });
    };

    const handleCreateCategory = async (e) => {
        e.preventDefault();
        try {
            const formData = new FormData();
            formData.append('name', newCategory.name);
            formData.append('image', newCategory.image);
            await axios.post('http://localhost:8000/api/categories/create', formData);
            setNewCategory({
                name: '',
                image: null,
            });
            setShowModal(false);
            // Fetch categories after the request is completed
            axios.get('http://localhost:8000/api/categories')
                .then((response) => {
                    setCategories(response.data);
                })
                .catch((error) => {
                    console.log(error);
                });
        } catch (error) {
            console.log(error);
        }
    };

    const handleEditCategory = async (e) => {
        e.preventDefault();
        try {
            const formData = new FormData();
            formData.append('name', categories.find((category) => category.id === selectedCategoryId).name);
            formData.append('image', newCategory.image);
            await axios.put(`http://localhost:8000/api/categories/update/${selectedCategoryId}`, formData);
            setNewCategory({
                name: '',
                image: null,
            });
            setShowModal(false);
            setSelectedCategoryId(null);
            // Update categories in the state
            const updatedCategories = categories.map((category) => {
                if (category.id === selectedCategoryId) {
                    return {
                        ...category,
                        name: newCategory.name,
                    };
                }
                return category;
            });
            setCategories(updatedCategories);

            // Save the update to the database
            await axios.put(`http://localhost:8000/api/categories/update/${selectedCategoryId}`, {
                name: newCategory.name,
            });

        } catch (error) {
            console.log(error);
        }
    };


    const handleDeleteCategory = async (categoryId) => {
        try {
            await axios.delete(`http://localhost:8000/api/categories/delete/${categoryId}`);
            fetchCategories();
        } catch (error) {
            console.log(error);
        }
    };

    const handleShowModal = (categoryId = null) => {
        const selectedCategory = categories.find((category) => category.id === categoryId);

        setNewCategory({
            name: selectedCategory ? selectedCategory.name : '',
            image: null,
        });

        setSelectedCategoryId(categoryId);
        setShowModal(true);
    };


    const handleCloseModal = () => {
        setShowModal(false);
        setSelectedCategoryId(null);
    };

    return (
        <div>

            <Button onClick={() => handleShowModal()}>Tạo danh mục món ăn</Button>
            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title>{selectedCategoryId ? 'Edit Category' : 'Create Category'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form onSubmit={selectedCategoryId ? handleEditCategory : handleCreateCategory}>
                        <Form.Group>
                            <Form.Label>Tên danh mục:</Form.Label>
                            <Form.Control type="text" name="name" value={newCategory.name} onChange={handleInputChange} />
                        </Form.Group>
                        <Form.Group>
                            <Form.Label>Hình ảnh:</Form.Label>
                            <Form.Control type="file" name="image" accept="image/*" onChange={handleFileChange} />
                        </Form.Group>
                        <br />
                        <Button variant="primary" type="submit">
                            {selectedCategoryId ? 'Chỉnh sửa danh mục' : 'Tạo danh mục món ăn'}
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
                        <th>Mã danh mục</th>
                        <th>Tên danh mục</th>
                        <th>Hình ảnh</th>
                        <th>Tùy chọn</th>
                    </tr>
                </thead>
                <tbody>
                    {categories.map((category) => (
                        <tr key={category.id}>
                            <td>{category.id}</td>
                            <td>{category.name}</td>
                            <td>
                                <img src={`http://127.0.0.1:8000/upload/categories/${category.image}`} alt={category.name} style={{ width: '100px' }} />
                            </td>
                            <td>
                                <Button variant="info" onClick={() => handleShowModal(category.id)}>
                                    Chỉnh sửa
                                </Button>
                                <span style={{ marginLeft: '10px' }}></span>
                                <Button variant="danger" onClick={() => handleDeleteCategory(category.id)}>
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

export default CategoriesList;
