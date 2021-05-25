import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/providers/cart.dart' show Cart;

import 'package:flutter_shopping_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(flex: 1,),
                  Consumer<Cart>(
                    builder: (BuildContext _, Cart cart, Widget __) => Chip(
                      label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white),),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 16,),
                  TextButton(
                    onPressed: () {},
                    child: Text('Order Now'),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Consumer<Cart>(
              builder: (BuildContext _, Cart cart, Widget __) => ListView.builder(
                itemBuilder: (ctx, index) => CartItem(
                  id: cart.itemsToList[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.itemsToList[index].title,
                  price: cart.itemsToList[index].price,
                  quantity: cart.itemsToList[index].quantity,
                ),
                itemCount: cart.productsCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
