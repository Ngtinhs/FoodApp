import React, { useContext, useState } from 'react';
import { Routes, Route, Link, NavLink, useNavigate } from 'react-router-dom';
import OrderList from './components/OderFood/OrderList';
import FoodList from './components/Food/FoodList';
import UserList from './components/User/UserList';
import 'react-toastify/dist/ReactToastify.css';
import { ToastContainer } from 'react-toastify';
import CategoriesList from './components/Category/Categories';
import Revenue from './components/Doanhthu/Doanhthu';
import { AuthContext } from './components/Auth/AuthContext';
import LoginForm from './Pages/Login/Login';

const App = () => {
  const { isAuthenticated, logout } = useContext(AuthContext);

  const handleLogout = () => {
    logout();
  };
  if (!isAuthenticated) {
    return <LoginForm />;
  }

  return (

    <div>
      <ToastContainer />
      <div>
        <nav className="navbar navbar-expand-lg navbar-light bg-light">
          <Link to="/" className="navbar-brand">Admin Page</Link>
          <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="collapse navbar-collapse" id="navbarNav">
            <ul className="navbar-nav">
              <li className="nav-item">
                <NavLink to="/products" className="nav-link" activeClassName="active">Product Management</NavLink>
              </li>
              <li className="nav-item">
                <NavLink to="/users" className="nav-link" activeClassName="active">User Management</NavLink>
              </li>
              <li className="nav-item">
                <NavLink to="/orders" className="nav-link" activeClassName="active">Order Management</NavLink>
              </li>
              <li className="nav-item">
                <NavLink to="/categories" className="nav-link" activeClassName="active">Category Management</NavLink>
              </li>
            </ul>
          </div>
        </nav>

        <div style={{ display: 'flex' }}>
          <div style={{ width: '20%' }}>
            <ul className="list-group">
              <li className="list-group-item">
                <Link to="/products" className="text-decoration-none text-dark">Product List</Link>
              </li>
              <li className="list-group-item">
                <Link to="/users" className="text-decoration-none text-dark">User List</Link>
              </li>
              <li className="list-group-item">
                <Link to="/orders" className="text-decoration-none text-dark">Order List</Link>
              </li>
              <li className="list-group-item">
                <Link to="/categories" className="text-decoration-none text-dark">Category List</Link>
              </li>
              <li className="list-group-item">
                <Link to="/revenue" className="text-decoration-none text-dark">Revenue</Link>
              </li>
              <li className="list-group-item">
                <button onClick={handleLogout} className="btn btn-link text-decoration-none text-dark">Logout</button>
              </li>
            </ul>
          </div>

          <div style={{ width: '80%' }}>
            <Routes>
              <Route path="/products" element={<FoodList />} />
              <Route path="/users" element={<UserList />} />
              <Route path="/orders" element={<OrderList />} />
              <Route path="/categories" element={<CategoriesList />} />
              <Route path="/revenue" element={<Revenue />} />
            </Routes>
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
