import 'package:my_shop/models/product.dart';

abstract class IProductsService {
  Future<String> postProduct(Product product);
  Future<List<Product>> fetchProducts();
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(Product product);
  Future<void> toggleFavorite(Product product);
}
