import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  void onClickAddToCart(Cart cart, Product product) {
    cart.addItem(product.id, product.price, product.title);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);

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
              onPressed: value.changeFavoriteState,
            ),
          ),
          trailing: Consumer<Cart>(
            builder: (ctx, value, child) => IconButton(
              icon: child!,
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => onClickAddToCart(value, product),
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
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
