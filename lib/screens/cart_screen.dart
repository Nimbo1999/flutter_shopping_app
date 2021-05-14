import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shopping_app/providers/cart.dart';

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
                      label: Text('\$ ${cart.totalAmount.toString()}', style: TextStyle(color: Colors.white),),
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
          )
        ],
      ),
    );
  }
}
