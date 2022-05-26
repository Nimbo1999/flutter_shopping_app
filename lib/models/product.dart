import 'package:flutter/foundation.dart';
import 'package:my_shop/services/products_service.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _changeFavoriteValue() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> changeFavoriteState(IProductsService productsService) async {
    _changeFavoriteValue();
    try {
      await productsService.toggleFavorite(this);
    } catch (error) {
      _changeFavoriteValue();
      rethrow;
    }
  }
}
