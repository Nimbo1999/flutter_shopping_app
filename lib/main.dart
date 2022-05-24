import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(create: (ctx) => Products()),
        ChangeNotifierProvider<Cart>(create: (ctx) => Cart()),
        ChangeNotifierProvider<Orders>(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato'),
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (ctx) =>
              const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routName: (context) => const CartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProductScreen.routeName: (context) => const EditProductScreen(),
        },
      ),
    );
  }
}
