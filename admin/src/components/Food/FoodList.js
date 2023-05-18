import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Button, Modal } from 'react-bootstrap';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { Form, FormGroup, FormLabel, FormControl } from 'react-bootstrap';

const FoodList = () => {
    const [foods, setFoods] = useState([]);
    const [categories, setCategories] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedFood, setSelectedFood] = useState(null);
    const [selectedFoodToDelete, setSelectedFoodToDelete] = useState(null);
    const [isEditing, setIsEditing] = useState(false);
    const [showEditModal, setShowEditModal] = useState(false); // Biến mới cho form chỉnh sửa
    const [showDeleteModal, setShowDeleteModal] = useState(false); // Biến cho form xóa

    useEffect(() => {
        fetchFoodList();
        fetchCategoryList();
    }, []);

    const fetchFoodList = () => {
        axios
            .get('http://localhost:8000/api/food')
            .then((response) => {
                setFoods(response.data.food);
            })
            .catch((error) => {
                console.error('Error fetching food list:', error);
            });
    };

    const fetchCategoryList = () => {
        axios
            .get('http://localhost:8000/api/categories')
            .then((response) => {
                const categories = response.data.categories.map((category) => ({
                    ...category,
                    slug: category.title.toLowerCase().replace(/ /g, '-'),
                }));
                setCategories(categories);
            })
            .catch((error) => {
                console.error('Error fetching category list:', error);
            });
    };

    const handleAddFood = () => {
        setSelectedFood({
            title: '',
            description: '',
            price: '',
            image: null,
            quantity: '',
            categoryId: categories.length > 0 ? categories[0]._id : '',
        });
        setIsEditing(false);
        setShowModal(true);
    };

    const handleSaveFood = () => {
        const { title, description, price, image, quantity, categoryId } = selectedFood;

        if (title && description && price && image && categoryId) {
            const formData = new FormData();
            formData.append('title', title);
            formData.append('description', description);
            formData.append('price', price);
            formData.append('image', image);
            formData.append('quantity', quantity);
            formData.append('categoryId', categoryId);

            if (isEditing) {
                // Perform update logic
                axios
                    .put(`http://localhost:8000/api/food/${selectedFood._id}`, formData)
                    .then((response) => {
                        const updatedFood = response.data;
                        setFoods(
                            foods.map((food) => (food._id === selectedFood._id ? updatedFood : food))
                        );
                        toast.success('Cập nhật món ăn thành công');
                        setShowModal(false);
                    })
                    .catch((error) => {
                        console.error('Error updating food:', error);
                        toast.error('Cập nhật món ăn thất bại');
                    });
            } else {
                // Perform create logic
                axios
                    .post('http://localhost:8000/api/food', formData)
                    .then((response) => {
                        const newFood = response.data;
                        setFoods([...foods, newFood]);
                        toast.success('Thêm món ăn thành công');
                        setShowModal(false);
                    })
                    .catch((error) => {
                        console.error('Error creating food:', error);
                        toast.error('Thêm món ăn thất bại');
                    });
            }
        } else {
            toast.error('Vui lòng nhập đầy đủ thông tin món ăn');
        }
    };

    const handleEditFood = (food) => {
        setSelectedFood(food);
        setIsEditing(true);
        setShowEditModal(true); // Hiển thị form chỉnh sửa
    };


    const handleDeleteFood = (food) => {
        setSelectedFoodToDelete(food);
        setShowDeleteModal(true); // Hiển thị form xóa
    };

    const handleConfirmDelete = () => {
        axios
            .delete(`http://localhost:8000/api/food/${selectedFoodToDelete._id}`)
            .then((response) => {
                setFoods(foods.filter((f) => f._id !== selectedFoodToDelete._id));
                toast.success('Xóa món ăn thành công');
                setSelectedFoodToDelete(null);
                setShowDeleteModal(false); // Ẩn form xóa sau khi xác nhận xóa
            })
            .catch((error) => {
                console.error('Error deleting food:', error);
                toast.error('Xóa món ăn thất bại');
            });
    };
    return (
        <div>
            <Button variant="success" onClick={handleAddFood}>
                Thêm món ăn
            </Button>
            <ul className="list-group">
                {foods.map((food) => (
                    <li key={food._id} className="list-group-item">
                        <strong>Title:</strong> {food.title}
                        <br />
                        <strong>Description:</strong> {food.description}
                        <br />
                        <strong>Image:</strong> {food.image}
                        <br />
                        <strong>Price:</strong> {food.price}
                        <br />
                        <strong>quantity:</strong> {food.quantity}
                        <br />
                        <strong>category:</strong> {food.category.title}
                        <br />
                        <br />
                        <Button variant="warning" onClick={() => handleEditFood(food)}>Sửa</Button> {/* Thêm nút sửa */}
                        <Button variant="danger" onClick={() => handleDeleteFood(food)}>
                            Xóa
                        </Button>
                    </li>
                ))}
            </ul>

            <Modal show={showModal} onHide={() => setShowModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>{isEditing ? 'Edit Food' : 'Add Food'}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <FormGroup>
                            <FormLabel>Title</FormLabel>
                            <FormControl
                                type="text"
                                value={selectedFood ? selectedFood.title : ''}
                                onChange={(e) => setSelectedFood({ ...selectedFood, title: e.target.value })}
                            />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Description</FormLabel>
                            <FormControl
                                type="text"
                                value={selectedFood ? selectedFood.description : ''}
                                onChange={(e) => setSelectedFood({ ...selectedFood, description: e.target.value })}
                            />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Price</FormLabel>
                            <FormControl
                                type="text"
                                value={selectedFood ? selectedFood.price : ''}
                                onChange={(e) => setSelectedFood({ ...selectedFood, price: e.target.value })}
                            />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Image</FormLabel>
                            <FormControl
                                type="file"
                                accept="image/*"
                                onChange={(e) => setSelectedFood({ ...selectedFood, image: e.target.files[0] })}
                            />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Quantity</FormLabel>
                            <FormControl
                                type="text"
                                value={selectedFood ? selectedFood.quantity : ''}
                                onChange={(e) => setSelectedFood({ ...selectedFood, quantity: e.target.value })}
                            />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Category</FormLabel>
                            <FormControl
                                as="select"
                                value={selectedFood ? selectedFood.categoryId : ''}
                                onChange={(e) => setSelectedFood({ ...selectedFood, categoryId: e.target.value })}
                            >
                                {categories.map((category) => (
                                    <option key={category._id} value={category._id}>
                                        {category.title}
                                    </option>
                                ))}
                            </FormControl>
                        </FormGroup>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={() => setShowModal(false)}>Cancel</Button>
                    <Button onClick={handleSaveFood} variant="primary">
                        Save
                    </Button>
                </Modal.Footer>
            </Modal>

            <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)}>
                <Modal.Header closeButton>
                    <Modal.Title>Delete Food</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <p>Are you sure you want to delete this food?</p>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={() => setShowDeleteModal(false)}>Cancel</Button>
                    <Button onClick={handleConfirmDelete} variant="danger">Delete</Button>
                </Modal.Footer>
            </Modal>

        </div>
    );
}
export default FoodList;
