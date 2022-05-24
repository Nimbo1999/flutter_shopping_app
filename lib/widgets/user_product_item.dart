import 'package:flutter/material.dart';
import 'package:my_shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              color: Theme.of(context).colorScheme.primary),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ),
    );
  }
}
