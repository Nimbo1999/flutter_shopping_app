import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart_Item.dart';
import 'package:my_shop/providers/order_item.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    DateTime now = DateTime.now();
    _orders.insert(
        0,
        OrderItem(
            id: now.toString(),
            amount: total,
            products: cartProducts,
            dateTime: now));
    notifyListeners();
  }
}
