import 'package:flutter/material.dart';

import 'package:flutter_shopping_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const String routeName = '/products-overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'),),
      body: ProductsGrid(),
    );
  }
}
