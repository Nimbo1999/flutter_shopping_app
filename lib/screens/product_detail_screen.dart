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
      // appBar: AppBar(title: Text(product.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 800),
          ]))
        ],
      ),
    );
  }
}
