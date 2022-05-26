import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../models/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  final IProductsService productsService;

  const ProductsGrid(
      {Key? key,
      required this.showOnlyFavorites,
      required this.productsService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    List<Product> products = showOnlyFavorites
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            key: Key(products[i].id), productsService: productsService),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10),
    );
  }
}
