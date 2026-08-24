import 'package:flutter/material.dart';
import 'package:mobile_app/services/api_service.dart';
import '../models/products_model.dart';

//service
class ProductService extends ChangeNotifier{
   final ApiService apiService = ApiService();

  List<ProductsModel> products = [];
  List<CategoryModel> categories = [];

  bool isLoading = false;

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    try{
      final responsse = await apiService.get("/fetchAllProducts");

      products = (responsse as List)
            .map((products) => ProductsModel.fromJson(products))
            .toList();
    }catch(e){
      print("Error fetching Products: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsModelPerCategory(int id) async{
    isLoading = true;
    notifyListeners();

    try{
      final response = await apiService.get("/fetchProductsModelsPerCategory/$id");

      products = (response as List)
          .map((products) => ProductsModel.fromJson(products))
          .toList();
    }catch(e){
      print("Error fetching books: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

   Future<void> fetchCategories() async{
    isLoading = true;
    notifyListeners();

    try{
      final response = await apiService.get("/fetchAllCategories");

      categories = (response as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    }catch(e){
      print("Error fetching categories");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


}

//model