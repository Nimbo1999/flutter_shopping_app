import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/providers/order_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
  }

  setExpanded() {
    if (_expanded) {
      _animationController!.reverse();
    } else {
      _animationController!.forward();
    }
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: setExpanded,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20 + 20, 100)
                : 0,
            child: FadeTransition(
              opacity: _opacityAnimation!,
              child: ListView(
                children: widget.order.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('${product.quantity}x \$${product.price}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary))
                          ],
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
