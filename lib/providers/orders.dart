import 'package:flutter/foundation.dart';
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/providers/cart_Item.dart';
import 'package:my_shop/providers/order_item.dart';
import 'package:my_shop/services/orders_service.dart';

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  String? _authToken;

  Orders setAuthToken(String? token) {
    _authToken = token;
    return this;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  bool _hasNotAToken(String? token) {
    return token == null || token.isEmpty;
  }

  Future<void> addOrder(IOrdersService ordersService,
      List<CartItem> cartProducts, double total) async {
    final OrderItem orderItem = OrderItem(
        id: '',
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now());
    try {
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      String orderId = await ordersService.saveOrder(orderItem, _authToken!);
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
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      List<OrderItem> orders = await ordersService.fetchOrders(_authToken!);
      _orders = orders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
