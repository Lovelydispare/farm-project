//service 
import 'package:flutter/material.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/services/auth_service.dart';

class OrdersService extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();

  List<OrdersModel> orders = [];

  bool isLoading = false;

  Future<void> fetchOrders(int userId, String? token) async{

    isLoading = true;
    notifyListeners();

    try{
      final response = await apiService.get("/fetchOrdersperUser/$userId", token:token);

      orders = (response as List)
          .map((order) => OrdersModel.fromJson(order))
          .toList();
    }catch(e){
      print("Error fetching Orders: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

  //new order
  Future<bool> addOrder(Map<String, dynamic> data,String? token) async{

    isLoading = true;
    notifyListeners();

    try{
      await apiService.post("/saveNewOrder", data, token: token);
      return true;
    }catch(e){
      print("Error creating new order: $e");
      return false;
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}

//Model
class OrdersModel{
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final String orderStatus;
  final double price;
  final String image;
  final DateTime createdAt;

  OrdersModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    this.orderStatus = "",
    required this.price,
    required this.image,
    required this.createdAt,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json){
    return OrdersModel(
      id: json["id"],
      productId: json['product_id'] ?? "",
      quantity: json['quantity'] ?? "",
      orderStatus: json['order_status'] == 0 ? 'Fullfilled' : 'Being Processed',
      productName: json["product"]["name"] ?? "",
      price: (json["product"]["price"] as num).toDouble(),
      image: json["product"]["image"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}