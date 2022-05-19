import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    final String productId =
        ModalRoute.of(context)?.settings.arguments as String;
    final Product product = productsProvider.findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
    );
  }
}
