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
  bool _isLoading = false;

  void changeIsLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    Future<void> init() async {
      changeIsLoadingState();
      try {
        await Provider.of<Orders>(context, listen: false)
            .fetchOrders(widget.ordersService);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          action: SnackBarAction(
              label: 'Ok',
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName)),
          duration: const Duration(minutes: 1),
        ));
      } finally {
        changeIsLoadingState();
      }
    }

    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx, index) => OrderItemWidget(
                    key: Key(ordersProvider.orders[index].id),
                    order: ordersProvider.orders[index],
                  )),
    );
  }
}
