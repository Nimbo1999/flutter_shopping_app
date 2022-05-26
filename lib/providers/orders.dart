import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart_Item.dart';
import 'package:my_shop/providers/order_item.dart';
import 'package:my_shop/services/orders_service.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(IOrdersService ordersService,
      List<CartItem> cartProducts, double total) async {
    final OrderItem orderItem = OrderItem(
        id: '',
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now());
    try {
      String orderId = await ordersService.saveOrder(orderItem);
      final OrderItem order = OrderItem(
          id: orderId,
          amount: orderItem.amount,
          dateTime: orderItem.dateTime,
          products: orderItem.products);
      _orders.insert(0, order);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchOrders(IOrdersService ordersService) async {
    try {
      List<OrderItem> orders = await ordersService.fetchOrders();
      _orders = orders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
