import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_shop/providers/cart_Item.dart';
import 'package:my_shop/providers/order_item.dart';
import 'package:my_shop/services/orders_service.dart';

class OrdersServiceImpl implements IOrdersService {
  final String _baseUrl = const String.fromEnvironment("BASE_URL");

  @override
  Future<String> saveOrder(OrderItem orderItem) async {
    Uri url = Uri.parse('$_baseUrl/orders.json');
    try {
      final http.Response response =
          await http.post(url, body: _encodeOrder(orderItem));
      return json.decode(response.body)['name'];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<OrderItem>> fetchOrders() async {
    Uri url = Uri.parse('$_baseUrl/orders.json');
    try {
      final http.Response response = await http.get(url);
      return _responseToOrderList(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  String _encodeOrder(OrderItem orderItem) {
    final products = orderItem.products
        .map((product) => {
              'id': product.id,
              'price': product.price,
              'quantity': product.quantity,
              'title': product.title
            })
        .toList();
    return json.encode({
      'amount': orderItem.amount,
      'products': products,
      'dateTime': orderItem.dateTime.toIso8601String()
    });
  }

  List<OrderItem> _responseToOrderList(Map<String, dynamic> data) {
    return data.keys
        .map((id) => OrderItem(
            id: id,
            amount: data[id]['amount'],
            products: _getProducts(data[id]['products']),
            dateTime: DateTime.parse(data[id]['dateTime'])))
        .toList();
  }

  List<CartItem> _getProducts(List<dynamic> products) {
    return products
        .map((product) => CartItem(
            id: product['id'],
            title: product['title'],
            quantity: product['quantity'],
            price: product['price']))
        .toList();
  }
}
