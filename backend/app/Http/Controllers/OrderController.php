<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $orders = Order::all();
        return response()->json($orders);
    }

    public function getOrderPerUser($id){
        $orders = Order::with('product')->where('user_id', $id)->get();
        return response()->json($orders);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $products = $request->products;
        try{
            foreach($products as $product){
                $order = new Order();
                $order->product_id =$product['product_id'];
                $order->user_id = $request->user_id;
                $order->quantity = $product['quantity'];
                $order->order_status = 1;
                $order->save();
            }
            return response()->json([
                'message'=>'Order created sucessfully',
                //'order'=>$order,
            ],201);
        }catch(\Exception $exception){
            return response()->json([
                "Error"=>'Order creation failed',
                $exception
            ],500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Order $order)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order $order)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order)
    {
        //
    }
}
