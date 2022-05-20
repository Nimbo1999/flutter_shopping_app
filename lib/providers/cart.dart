import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart_Item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmout {
    return _items.entries.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.value.price * element.value.quantity));
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
      notifyListeners();
      return;
    }

    _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price));
    notifyListeners();
  }
}
