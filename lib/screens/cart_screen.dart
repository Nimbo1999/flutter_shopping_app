import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/services/orders_service.dart';
import 'package:my_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routName = '/cart-screen';
  final IOrdersService ordersService;
  const CartScreen({Key? key, required this.ordersService}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  void changeLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> onPressOrderNow(ScaffoldMessengerState scaffoldMessengerState,
      BuildContext context, Cart cart) async {
    changeLoadingState();
    try {
      await Provider.of<Orders>(context, listen: false)
          .addOrder(widget.ordersService, cart.itemsList, cart.totalAmout);
      changeLoadingState();
      cart.clearCart();
    } catch (error) {
      scaffoldMessengerState
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final Cart cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                if (_isLoading) const LinearProgressIndicator(),
                Padding(
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
                      OrderNowButton(
                        label: 'Order now',
                        onPressed: () => onPressOrderNow(
                            scaffoldMessengerState, context, cart),
                        isDisabled: cart.items.isEmpty,
                      )
                    ],
                  ),
                ),
              ],
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

class OrderNowButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String label;
  final bool isDisabled;
  const OrderNowButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.isDisabled = false})
      : super(key: key);

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool _isLoading = false;

  void changeIsLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> onPressed() async {
    changeIsLoadingState();
    await widget.onPressed();
    changeIsLoadingState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.isDisabled || _isLoading ? null : onPressed,
        child: Text(widget.label));
  }
}
