import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    if (_items.isEmpty) return 0;

    List<String> keys = _items.keys.toList();
    List<CartItem> carts = [];

    for (var key in keys) {
      carts.add(_items[key]);
    }

    if (carts.isNotEmpty) {
      return carts
          .reduce((value, element) => CartItem(
                id: '',
                price: 0,
                quantity: value.quantity + element.quantity,
                title: '')
          ).quantity;
    }

    return 0;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }
}
