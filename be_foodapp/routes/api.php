<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
// login
Route::post('/login','\App\Http\Controllers\Api\UserController@login');
// register
Route::post('/register','\App\Http\Controllers\Api\UserController@register');

Route::group(['prefix'=>'categories'],function(){
    Route::post('create',[\App\Http\Controllers\Api\CategoriesController::class,'insert']);
    Route::get('/',[\App\Http\Controllers\Api\CategoriesController::class,'index']);
});
Route::group(['prefix'=>'cart'],function(){
    Route::post('index',[\App\Http\Controllers\ShoppingController::class,'index']);

    // thêm sản phẩm
    Route::post('create',[\App\Http\Controllers\ShoppingController::class,'insert']);
    // Trừ sản phẩm
    Route::post('delete',[\App\Http\Controllers\ShoppingController::class,'delete']);
    // Xóa sản phẩm
    Route::post('deleteproduct',[\App\Http\Controllers\ShoppingController::class,'deleteproduct']);

    // xóa giỏ hàng
    Route::post('deleteall',[\App\Http\Controllers\ShoppingController::class,'deleteall']);
    //order
    Route::post('/order',[\App\Http\Controllers\ShoppingController::class,'order']);

});
Route::get('/listorder/{id}/{status}',[\App\Http\Controllers\ShoppingController::class,'listorder']);
Route::post('/huydon',[\App\Http\Controllers\ShoppingController::class,'huydon']);
Route::get('/orderdetail/{id}',[\App\Http\Controllers\ShoppingController::class,'orderdetail']);
Route::post('/changeimage','\App\Http\Controllers\Api\UserController@changeimage');
Route::post('/changeinfo','\App\Http\Controllers\Api\UserController@changeinfo');
Route::group(['prefix'=>'product'],function (){
        Route::get('/',[\App\Http\Controllers\Api\ProductController::class,'index']);
        Route::get('/newproduct',[\App\Http\Controllers\Api\ProductController::class,'newproduct']);
        Route::get('/muanhieu',[\App\Http\Controllers\Api\ProductController::class,'muanhieu']);
        Route::get('/tatcasanpham',[\App\Http\Controllers\Api\ProductController::class,'tatcasanpham']);
        Route::get('/searchproduct/{keyword}',[\App\Http\Controllers\Api\ProductController::class,'searchproduct']);
        Route::post('/create',[\App\Http\Controllers\Api\ProductController::class,'create']);
        Route::get('/danhmuc/{id}',[\App\Http\Controllers\Api\ProductController::class,'searchdanhmuc']);
});
//check login
Route::group(['middleware' => 'auth:api'], function(){
   //get user đang login
    Route::get('/detail','\App\Http\Controllers\Api\UserController@detail');

    // bài viết
    Route::group(['prefix'=>'posts'],function(){
        Route::post('/','\App\Http\Controllers\Api\PostController@store'); // tạo mới bài viết
        Route::post('/update/{id}','\App\Http\Controllers\Api\PostController@update');
        Route::post('/delete/{id}','\App\Http\Controllers\Api\PostController@delete');
        Route::get('/detail/{id}','\App\Http\Controllers\Api\PostController@detail'); // chi tiết bài viết
        Route::get('/user/{id}','\App\Http\Controllers\Api\PostController@getpostbyuser'); // chi tiết bài viết
    });
    Route::group(['prefix'=>'users'],function(){
//        Route::post('/','\App\Http\Controllers\Api\PostController@store'); // tạo mới bài viết
        Route::get('/{id}','\App\Http\Controllers\Api\UserController@detailuserbyid'); // chi tiết bài viết
    });
    // sản phẩm
//    Route::group(['prefix'=>'products'],function (){
//        Route::get('/','\App\Http\Controllers\Api\ProductController@index');
//        Route::post('/','\App\Http\Controllers\Api\ProductController@store');
//        Route::post('/update/{id}','\App\Http\Controllers\Api\ProductController@update');
//        Route::post('/delete/{id}','\App\Http\Controllers\Api\ProductController@delete');
//        Route::get('/detail/{id}','\App\Http\Controllers\Api\ProductController@detail');
//    });
    //tìm kiếm
    Route::group(['prefix'=>'search'],function(){
        Route::get('user/{key}','\App\Http\Controllers\Api\SearchController@searchuser');
        Route::get('post/{key}','\App\Http\Controllers\Api\SearchController@searchpost');
        Route::get('product/{key}','\App\Http\Controllers\Api\SearchController@searchproduct');
    });
    //comment
    Route::group(['prefix'=>'comments'],function (){
        Route::get('/{post_id}','\App\Http\Controllers\Api\CommentController@index');
        Route::post('/{post_id}','\App\Http\Controllers\Api\CommentController@newcomment');
        Route::post('/delete/{id}','\App\Http\Controllers\Api\CommentController@delete');
    });
    //message
    Route::group(['prefix'=>'message'],function (){
        Route::post('get/{to}','App\Http\Controllers\Api\MessageController@getmessage');
        Route::post('getlist','App\Http\Controllers\Api\MessageController@getlistmessage');
        Route::post('send/{to}','App\Http\Controllers\Api\MessageController@sendmessage');
        Route::post('deletemes/{to}','App\Http\Controllers\Api\MessageController@deletemes');
        Route::post('delete/{id}','App\Http\Controllers\Api\MessageController@delete');
    });


});
Route::group(['prefix'=>'posts'],function(){
    Route::get('/','\App\Http\Controllers\Api\PostController@index');

});
