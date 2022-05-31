import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:my_shop/services/impl/orders_service_impl.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  void _onPressLogout(BuildContext context) {
    Navigator.of(context).pop();
    Provider.of<Auth>(context, listen: false).logoutUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Hello friend!'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacement(CustomRoute(
                builder: ((context) =>
                    OrdersScreen(ordersService: OrdersServiceImpl())))),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Manage Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => _onPressLogout(context),
          )
        ],
      ),
    );
  }
}
