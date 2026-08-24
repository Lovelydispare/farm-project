import 'package:flutter/material.dart';
import '../models/products_model.dart';

class CartService extends ChangeNotifier {
  
  final List<CartItem> cart = [];

  void addProduct(ProductsModel product){
    final index = cart.indexWhere(
      (item) =>item.product.id == product.id
      );

    if(index != -1){
      cart[index].quantity++;
    }else{
      cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeProduct(ProductsModel product){
    cart.removeWhere(
      (item) => item.product.id == product.id,
    );
    notifyListeners();
  }

//function to mamage the total
  double get total => cart.fold(0, (sum, item) =>sum + item.subtotal,);
  int get itemCount => cart.length;
  bool get isEmpty => cart.isEmpty;

  void increaseQty(CartItem item){
    item.quantity++;
    notifyListeners();
  }
  void decreaseQty(CartItem item){
    if(item.quantity > 1){
      item.quantity--;
    }else{
      cart.remove(item);
    }
    notifyListeners();
  }

  void clearCart(){
    cart.clear();
    notifyListeners();
  }

}

class CartItem{
  final ProductsModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1
  });

  double get subtotal => product.price * quantity;
}
