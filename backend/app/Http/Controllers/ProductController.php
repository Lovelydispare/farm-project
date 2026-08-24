<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::with('category')->get();

        foreach($products as $product){
            $product->image = asset('/api/image/' . $product->image);
        }

        return  response()->json($products);
    }
}
