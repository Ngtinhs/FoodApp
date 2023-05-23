<?php


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application.
| These routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Login
Route::post('/login', '\App\Http\Controllers\Api\UserController@login');

// Register
Route::post('/register', '\App\Http\Controllers\Api\UserController@register');

// Categories
Route::group(['prefix' => 'categories'], function () {
    // Create a category
    Route::post('create', [\App\Http\Controllers\Api\CategoriesController::class, 'insert']);

    // Get all categories
    Route::get('/', [\App\Http\Controllers\Api\CategoriesController::class, 'index']);

    // Update a category
    Route::put('update/{id}', [\App\Http\Controllers\Api\CategoriesController::class, 'update']);

    // Delete a category
    Route::delete('delete/{id}', [\App\Http\Controllers\Api\CategoriesController::class, 'delete']);
});

// Cart
Route::group(['prefix' => 'cart'], function () {
    // Get cart
    Route::post('index', [\App\Http\Controllers\ShoppingController::class, 'index']);

    // Add product to cart
    Route::post('create', [\App\Http\Controllers\ShoppingController::class, 'insert']);

    // Remove product from cart
    Route::post('delete', [\App\Http\Controllers\ShoppingController::class, 'delete']);

    // Delete product from cart
    Route::post('deleteproduct', [\App\Http\Controllers\ShoppingController::class, 'deleteproduct']);

    // Delete entire cart
    Route::post('deleteall', [\App\Http\Controllers\ShoppingController::class, 'deleteall']);

    // Order
    Route::post('/order', [\App\Http\Controllers\ShoppingController::class, 'order']);

     // Get all orders
     Route::get('allorders', [\App\Http\Controllers\ShoppingController::class, 'getAllOrders']);

     //Cập nhật status
     Route::put('updatestatus/{id}', [\App\Http\Controllers\ShoppingController::class, 'updateStatus']);

     // Tính tổng doanh thu
    Route::get('revenue', [\App\Http\Controllers\ShoppingController::class, 'calculateTotalRevenue']);


    Route::get('doanhthungay', [\App\Http\Controllers\ShoppingController::class, 'calculateDailyRevenue']);




});

// List orders
Route::get('/listorder/{id}/{status}', [\App\Http\Controllers\ShoppingController::class, 'listorder']);

// Cancel order
Route::post('/huydon', [\App\Http\Controllers\ShoppingController::class, 'huydon']);

// Order detail
Route::get('/orderdetail/{id}', [\App\Http\Controllers\ShoppingController::class, 'orderdetail']);

// Change user image
Route::post('/changeimage', '\App\Http\Controllers\Api\UserController@changeimage');

// Change user information
Route::post('/changeinfo', '\App\Http\Controllers\Api\UserController@changeinfo');

//get all user
Route::get('/users', '\App\Http\Controllers\Api\UserController@getUsers');

// Delete user
Route::delete('/users/{id}', '\App\Http\Controllers\Api\UserController@deleteUser');

// Update user
Route::put('/users/{id}', '\App\Http\Controllers\Api\UserController@updateUser');



// Product
Route::group(['prefix' => 'product'], function () {
    // Get all products
    Route::get('/', [\App\Http\Controllers\Api\ProductController::class, 'index']);

    // Get new products
    Route::get('/newproduct', [\App\Http\Controllers\Api\ProductController::class, 'newproduct']);

    // Get products by category
    Route::get('/muanhieu', [\App\Http\Controllers\Api\ProductController::class, 'muanhieu']);

    // Get all products (no category filter)
    Route::get('/tatcasanpham', [\App\Http\Controllers\Api\ProductController::class, 'tatcasanpham']);

    // Search products by keyword
    Route::get('/searchproduct/{keyword}', [\App\Http\Controllers\Api\ProductController::class, 'searchproduct']);

    // Create a product
    Route::post('/create', [\App\Http\Controllers\Api\ProductController::class, 'create']);

    // Get products by category ID
    Route::get('/danhmuc/{id}', [\App\Http\Controllers\Api\ProductController::class, 'searchdanhmuc']);

    Route::put('/edit/{id}', [\App\Http\Controllers\Api\ProductController::class, 'edit']);
    
    Route::delete('/delete/{id}', [\App\Http\Controllers\Api\ProductController::class, 'delete']);
});

// Routes protected by authentication middleware
Route::group(['middleware' => 'auth:api'], function () {
    // Get currently logged in user
    Route::get('/detail', '\App\Http\Controllers\Api\UserController@detail');

    // Posts
    Route::group(['prefix' => 'posts'], function () {
        // Create a post
        Route::post('/', '\App\Http\Controllers\Api\PostController@store');

        // Update a post
        Route::post('/update/{id}', '\App\Http\Controllers\Api\PostController@update');

        // Delete a post
        Route::post('/delete/{id}', '\App\Http\Controllers\Api\PostController@delete');

        // Get post details
        Route::get('/detail/{id}', '\App\Http\Controllers\Api\PostController@detail');

        // Get posts by user
        Route::get('/user/{id}', '\App\Http\Controllers\Api\PostController@getpostbyuser');
    });

    // Get user details by ID
    Route::group(['prefix' => 'users'], function () {
        Route::get('/{id}', '\App\Http\Controllers\Api\UserController@detailuserbyid');
    });

    // Search
    Route::group(['prefix' => 'search'], function () {
        // Search users by keyword
        Route::get('user/{key}', '\App\Http\Controllers\Api\SearchController@searchuser');

        // Search posts by keyword
        Route::get('post/{key}', '\App\Http\Controllers\Api\SearchController@searchpost');

        // Search products by keyword
        Route::get('product/{key}', '\App\Http\Controllers\Api\SearchController@searchproduct');
    });

    // Comments
    Route::group(['prefix' => 'comments'], function () {
        // Get comments by post ID
        Route::get('/{post_id}', '\App\Http\Controllers\Api\CommentController@index');

        // Add a comment to a post
        Route::post('/{post_id}', '\App\Http\Controllers\Api\CommentController@newcomment');

        // Delete a comment
        Route::post('/delete/{id}', '\App\Http\Controllers\Api\CommentController@delete');
    });

    // Messages
    Route::group(['prefix' => 'message'], function () {
        // Get messages between current user and a specific user
        Route::post('get/{to}', 'App\Http\Controllers\Api\MessageController@getmessage');

        // Get list of messages for current user
        Route::post('getlist', 'App\Http\Controllers\Api\MessageController@getlistmessage');

        // Send a message to a specific user
        Route::post('send/{to}', 'App\Http\Controllers\Api\MessageController@sendmessage');

        // Delete all messages between current user and a specific user
        Route::post('deletemes/{to}', 'App\Http\Controllers\Api\MessageController@deletemes');

        // Delete a specific message
        Route::post('delete/{id}', 'App\Http\Controllers\Api\MessageController@delete');
    });
});

// Public routes
Route::group(['prefix' => 'posts'], function () {
    // Get all posts
    Route::get('/', '\App\Http\Controllers\Api\PostController@index');
});

