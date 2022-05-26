import 'package:my_shop/providers/order_item.dart';

abstract class IOrdersService {
  Future<String> saveOrder(OrderItem orderItem);
  Future<List<OrderItem>> fetchOrders();
}
