import 'package:my_shop/models/product.dart';

abstract class IProductsService {
  Future<String> postProduct(Product product, String token);
  Future<List<Product>> fetchProducts(String token);
  Future<Product> updateProduct(Product product, String token);
  Future<void> deleteProduct(Product product, String token);
  Future<void> toggleFavorite(Product product, String token);
}
