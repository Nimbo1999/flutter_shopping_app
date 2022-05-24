import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    onPressOrderNow() {
      Provider.of<Orders>(context, listen: false)
          .addOrder(cart.itemsList, cart.totalAmout);
      cart.clearCart();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmout}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                      onPressed: onPressOrderNow,
                      child: const Text('Order now'))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemsList.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: cart.itemsList[i],
                      child: CartItemWidget(
                          key: Key(cart.itemsList[i].id),
                          productId: cart.getProductIdFromCart(i)),
                    )),
          ),
        ],
      ),
    );
  }
}
