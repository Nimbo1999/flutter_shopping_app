import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:my_shop/services/auth_service.dart';
import 'package:my_shop/services/impl/auth_service_impl.dart';
import 'package:my_shop/services/impl/orders_service_impl.dart';
import 'package:my_shop/services/impl/products_service_impl.dart';
import 'package:my_shop/services/orders_service.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final IProductsService productsService = ProductsServiceImpl();
  final IOrdersService ordersService = OrdersServiceImpl();
  final IAuthService authService = AuthServiceImpl();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(create: (ctx) => Products()),
        ChangeNotifierProvider<Cart>(create: (ctx) => Cart()),
        ChangeNotifierProvider<Orders>(create: (ctx) => Orders()),
        ChangeNotifierProvider<Auth>(
            create: (ctx) => Auth(authService: authService)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato'),
        initialRoute: AuthScreen.routeName,
        routes: {
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(
                productsService: productsService,
              ),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routName: (context) =>
              CartScreen(ordersService: ordersService),
          OrdersScreen.routeName: (context) =>
              OrdersScreen(ordersService: ordersService),
          UserProductsScreen.routeName: (context) => UserProductsScreen(
                productsService: productsService,
              ),
          EditProductScreen.routeName: (context) =>
              EditProductScreen(productsService: productsService),
        },
      ),
    );
  }
}
