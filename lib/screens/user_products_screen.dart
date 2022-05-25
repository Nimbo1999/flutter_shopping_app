import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products-screen';
  final IProductsService productsService;

  const UserProductsScreen({Key? key, required this.productsService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchProducts =
        Provider.of<Products>(context, listen: false).fetchProducts;
    final products = Provider.of<Products>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => fetchProducts(productsService),
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, i) => UserProductItem(
                  key: Key(products[i].id),
                  productsService: productsService,
                  id: products[i].id,
                  title: products[i].title,
                  imageUrl: products[i].imageUrl,
                )),
      ),
    );
  }
}
