import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
          itemCount: ordersProvider.orders.length,
          itemBuilder: (ctx, index) => OrderItemWidget(
                key: Key(ordersProvider.orders[index].id),
                order: ordersProvider.orders[index],
              )),
    );
  }
}
