import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/providers/products.dart';
import 'package:flutter_shopping_app/providers/cart.dart';

import 'package:flutter_shopping_app/screens/products_overview_screen.dart';
import 'package:flutter_shopping_app/screens/product_detail_screen.dart';
import 'package:flutter_shopping_app/screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext ctx) => Products()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Cart()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
        initialRoute: ProductsOverviewScreen.routeName,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}