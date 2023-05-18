import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, NavLink } from 'react-router-dom';
import OrderList from './components/OderFood/OrderList';
import FoodList from './components/Food/FoodList';
import UserList from './components/User/UserList';
import 'react-toastify/dist/ReactToastify.css';
import { ToastContainer } from 'react-toastify';
import CategoriesList from './components/Category/Categories';
import Revenue from './components/Doanhthu/Doanhthu';

const App = () => {
  return (
    <Router>
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
                <NavLink to="/Categories" className="nav-link" activeClassName="active">Cate Management</NavLink>
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
                <Link to="/Categories" className="text-decoration-none text-dark">Cate List</Link>
              </li>
              <li className="list-group-item">
                <Link to="/Revenue" className="text-decoration-none text-dark">Revenue</Link>
              </li>
            </ul>
          </div>

          <div style={{ width: '80%' }}>
            <Routes>
              <Route path="/products" element={<FoodList />} />
              <Route path="/users" element={<UserList />} />
              <Route path="/orders" element={<OrderList />} />
              <Route path="/Categories" element={<CategoriesList />} />
              <Route path="/Revenue" element={<Revenue />} />
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
};

export default App;
