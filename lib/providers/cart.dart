import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart_Item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItem> get itemsList {
    return _items.values.toList();
  }

  String getProductIdFromCart(int index) {
    return _items.keys.toList()[index];
  }

  int get itemsCount {
    return _items.values
        .fold(0, (previousValue, element) => previousValue + element.quantity);
  }

  double get totalAmout {
    return _items.values
        .fold(0, (previousValue, element) => previousValue + element.subTotal);
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

  void removeItemFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantityOfProduct(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              quantity: cartItem.quantity - 1,
              price: cartItem.price));
      notifyListeners();
    } else {
      removeItemFromCart(productId);
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
