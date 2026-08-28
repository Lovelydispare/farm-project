<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\OrderController;

//public routes
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::get('fetchAllProducts', [ProductController::class, 'index']);
Route::get('fetchAllCategories', [CategoryController::class, 'index']);
Route::get('/image/{path}', function ($path) {

    $filePath = storage_path('app/public/' . $path);

    if (!file_exists($filePath)) {
        abort(404);
    }

    return response()->file($filePath);

})->where('path', '.*');



// private routes
Route::middleware('auth:sanctum')->group(function() {
    Route::get('fetchAllOrders', [OrderController::class, 'index']);
    Route::get('fetchOrderPerUser', [OrderController::class, 'getOrderPerUser']);
    Route::post('saveNewOrder', [OrderController::class, 'store']);
    Route::post('completeOrder/{id}', [OrderController::class, 'fulfilOrder']);

    Route::post('addProduct', [ProductController::class, 'store']);
    Route::post('updateProduct/{id}', [ProductController::class, 'update']);
    Route::post('deleteProduct/{id}', [ProductController::class, 'deleteProduct']);

});
