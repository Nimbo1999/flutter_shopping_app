import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/product.dart';
import 'package:my_shop/services/products_service.dart';

class ProductsServiceImpl implements IProductsService {
  final String _baseUrl = const bool.hasEnvironment("BASE_URL")
      ? const String.fromEnvironment("BASE_URL")
      : "";

  @override
  Future<String> postProduct(Product product) async {
    final Uri url = Uri.parse('$_baseUrl/products.json');
    http.Response response = await http.post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite
        }));
    final String generatedId = json.decode(response.body)['name'];
    return generatedId;
  }
}
