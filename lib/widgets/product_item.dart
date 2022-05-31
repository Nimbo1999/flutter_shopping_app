import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final IProductsService productsService;
  const ProductItem({Key? key, required this.productsService})
      : super(key: key);

  void onClickAddToCart(BuildContext context, Cart cart, Product product) {
    cart.addItem(product.id, product.price, product.title);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${product.title} added to cart!',
          style: const TextStyle(fontSize: 16)),
      backgroundColor: const Color.fromARGB(255, 0, 97, 8),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.amber,
        onPressed: () => cart.decreaseQuantityOfProduct(product.id),
      ),
    ));
  }

  Future<void> onPressFavoriteButton(Product product,
      ScaffoldMessengerState scaffoldMessage, String token) async {
    try {
      await product.changeFavoriteState(productsService, token);
    } catch (error) {
      scaffoldMessage.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final Product product = Provider.of<Product>(context, listen: false);
    final String? authToken = Provider.of<Auth>(context, listen: false).token;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, value, child) => IconButton(
              icon: Icon(
                  value.isFavorite ? Icons.favorite : Icons.favorite_outline),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => onPressFavoriteButton(
                  value, scaffoldMessengerState, authToken ?? ''),
            ),
          ),
          trailing: Consumer<Cart>(
            builder: (ctx, value, child) => IconButton(
              icon: child!,
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => onClickAddToCart(context, value, product),
            ),
            child: const Icon(Icons.shopping_cart),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
