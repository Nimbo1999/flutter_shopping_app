import 'package:my_shop/providers/order_item.dart';

abstract class IOrdersService {
  Future<String> saveOrder(OrderItem orderItem, String token);
  Future<List<OrderItem>> fetchOrders(String token);
}
