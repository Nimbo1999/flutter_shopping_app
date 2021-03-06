import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/providers/products.dart';
import 'package:flutter_shopping_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Products>();
    final products = _showOnlyFavorites
      ? productsData.favoriteItems
      : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
