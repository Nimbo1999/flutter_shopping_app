import 'package:flutter/material.dart';
import 'package:my_shop/services/products_service.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(
      IProductsService productsService, Product newProduct) async {
    try {
      final String productId = await productsService.postProduct(newProduct);
      final Product product = Product(
          id: productId,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price,
          title: newProduct.title,
          isFavorite: newProduct.isFavorite);
      _items.add(product);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchProducts(IProductsService productsService) async {
    List<Product> productList = await productsService.fetchProducts();
    _items = productList;
    notifyListeners();
  }

  Future<void> updateProduct(
      IProductsService productsService, Product product) async {
    final int productIndex =
        _items.indexWhere((element) => element.id == product.id);
    if (productIndex == -1) return;
    await productsService.updateProduct(product);
    _items[productIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(IProductsService productsService, String id) {
    final int indexOfProduct = _items.indexWhere((element) => element.id == id);
    final Product product = _items[indexOfProduct];
    _items.removeAt(indexOfProduct);
    notifyListeners();
    return productsService
        .deleteProduct(product)
        .then((_) => Future.value())
        .catchError((error) {
      _items.insert(indexOfProduct, product);
      notifyListeners();
      throw error;
    });
  }
}
