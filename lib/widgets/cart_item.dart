import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/cart_Item.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String productId;
  const CartItemWidget({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<CartItem>(context);
    final removeFromCart =
        Provider.of<Cart>(context, listen: false).removeItemFromCart;

    return Dismissible(
      key: Key(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (DismissDirection direction) => removeFromCart(productId),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                      'Do you want to remove the item from the cart?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Yes'))
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: const EdgeInsets.all(4),
              child: FittedBox(child: Text('\$${cartItem.subTotal}')),
            )),
            title: Text(cartItem.title),
            subtitle: Text('Total: \$${cartItem.subTotal}'),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
