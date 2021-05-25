import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({ this.id, this.price, this.quantity, this.title, this.productId })
    : assert(
      id != null && id.isNotEmpty &&
      quantity != null && quantity > 0,
      "Verifique os valores de 'Quantity ou id'!"
    );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<Cart>().removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(child: Text('\$${price.toStringAsFixed(2)}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}