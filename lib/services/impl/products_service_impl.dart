import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_shop/adapters/products_adapter.dart';
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/services/products_service.dart';

class ProductsServiceImpl implements IProductsService {
  final String _baseUrl = const bool.hasEnvironment("BASE_URL")
      ? const String.fromEnvironment("BASE_URL")
      : "";

  @override
  Future<String> postProduct(Product product, String token) async {
    final Uri url = Uri.parse('$_baseUrl/products.json?auth=$token');
    try {
      http.Response response =
          await http.post(url, body: _encodeProduct(product));
      final String generatedId = json.decode(response.body)['name'];
      return generatedId;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> fetchProducts(String token) async {
    final Uri url = Uri.parse('$_baseUrl/products.json?auth=$token');
    try {
      final http.Response response = await http.get(url);
      if (response.statusCode > 399) {
        throw HttpException("Something went wrong.");
      }

      return ProductsAdapter.fetchProductsToListOfProducts(
          json.decode(response.body) as Map<String, dynamic>);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Product> updateProduct(Product product, String token) async {
    final Uri url =
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$token');
    try {
      await http.put(url, body: _encodeProduct(product));
      return product;
    } catch (error) {
      rethrow;
    }
  }

  String _encodeProduct(Product product) {
    return json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite
    });
  }

  @override
  Future<void> deleteProduct(Product product, String token) async {
    Uri url = Uri.parse('$_baseUrl/products/${product.id}.json?auth=$token');
    try {
      http.Response response = await http.delete(url);
      if (response.statusCode > 399) {
        throw HttpException('Unabled to delete the product');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> toggleFavorite(Product product, String token) async {
    Uri url = Uri.parse('$_baseUrl/products/${product.id}.json?auth=$token');
    try {
      final http.Response response = await http.patch(url,
          body: json.encode({'isFavorite': product.isFavorite}));
      if (response.statusCode > 399) {
        throw HttpException(
            'Unabled to favorite this item. Please try again later');
      }
    } catch (error) {
      rethrow;
    }
  }
}
