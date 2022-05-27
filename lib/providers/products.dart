import 'package:flutter/material.dart';
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/services/products_service.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];
  String? _authToken;

  Products setAuthToken(String? authToken) {
    _authToken = authToken;
    return this;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  bool _hasNotAToken(String? token) {
    return token == null || token.isEmpty;
  }

  Future<void> addProduct(
      IProductsService productsService, Product newProduct) async {
    try {
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      final String productId =
          await productsService.postProduct(newProduct, _authToken!);
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
    try {
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      List<Product> productList =
          await productsService.fetchProducts(_authToken!);
      _items = productList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(
      IProductsService productsService, Product product) async {
    final int productIndex =
        _items.indexWhere((element) => element.id == product.id);
    if (productIndex == -1) return;
    try {
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      await productsService.updateProduct(product, _authToken!);
      _items[productIndex] = product;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(
      IProductsService productsService, String id) async {
    final int indexOfProduct = _items.indexWhere((element) => element.id == id);
    final Product product = _items[indexOfProduct];
    _items.removeAt(indexOfProduct);
    notifyListeners();
    try {
      if (_hasNotAToken(_authToken)) {
        throw HttpException("You must be authenticated to make this request");
      }
      await productsService.deleteProduct(product, _authToken!);
    } catch (error) {
      _items.insert(indexOfProduct, product);
      notifyListeners();
      rethrow;
    }
  }
}
