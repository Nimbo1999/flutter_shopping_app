import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../models/product.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  // final List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    List<Product> products = productsProvider.items;

    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (context, i) => ProductItem(
        key: Key(products[i].id),
        id: products[i].id,
        title: products[i].title,
        imageUrl: products[i].imageUrl,
        isFavorite: products[i].isFavorite,
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
