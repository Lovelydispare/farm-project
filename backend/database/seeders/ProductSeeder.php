<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Product::create([
            'name'=>'Tomato',
            'price'=>150,
            'category_id'=>2,
            'image'=>'/products/tomato.jpg',
            'availability'=>1,
            'description'=>'Juicy and fresh',
        ]);
        Product::create([
            'name'=>'Onion',
            'price'=>160,
            'category_id'=>2,
            'image'=>'/products/onion.jpg',
            'availability'=>1,
            'description'=>'Juicy and fresh',
        ]);
        Product::create([
            'name'=>'Orange',
            'price'=>200,
            'category_id'=>1,
            'image'=>'/products/orange.jpg',
            'availability'=>1,
            'description'=>'Juicy and fresh',
        ]);
    }
}
