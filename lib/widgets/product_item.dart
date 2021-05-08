import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/providers/product.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  void navigateToProductPage(BuildContext context) {
    final String id = context.read<Product>().id;

    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    return Container(
      decoration: BoxDecoration(
          boxShadow: kElevationToShadow[2],
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () => navigateToProductPage(context),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: product.toggleFavoriteStatus,
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
