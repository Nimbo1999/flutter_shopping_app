import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final IProductsService productsService;

  const UserProductItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.imageUrl,
      required this.productsService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(children: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id),
                color: Theme.of(context).colorScheme.primary),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Future<bool?> removeItem = showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text(
                              'Do you want to remove this product from the app?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('No')),
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Yes'))
                          ],
                        ));
                removeItem.then((value) => {
                      if (value != null && value == true)
                        Provider.of<Products>(context, listen: false)
                            .deleteProduct(productsService, id)
                    });
              },
              color: Theme.of(context).colorScheme.error,
            ),
          ]),
        ),
      ),
    );
  }
}
