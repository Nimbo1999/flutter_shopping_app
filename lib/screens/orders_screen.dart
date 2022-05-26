import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/screens/products_overview_screen.dart';
import 'package:my_shop/services/orders_service.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';
  final IOrdersService ordersService;

  const OrdersScreen({Key? key, required this.ordersService}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _getOrders() {
    return Provider.of<Orders>(context, listen: false)
        .fetchOrders(widget.ordersService);
  }

  @override
  void initState() {
    _ordersFuture = _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (asyncSnapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'An error occured!',
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(
                              ProductsOverviewScreen.routeName),
                      child: const Text('Return')),
                )
              ],
            );
          }
          return Consumer<Orders>(
            builder: (context, value, child) => ListView.builder(
                itemCount: value.orders.length,
                itemBuilder: (ctx, index) => OrderItemWidget(
                      key: Key(value.orders[index].id),
                      order: value.orders[index],
                    )),
          );
        },
      ),
    );
  }
}
