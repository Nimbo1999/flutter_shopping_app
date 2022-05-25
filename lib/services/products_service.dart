import 'package:my_shop/models/product.dart';

abstract class IProductsService {
  Future<String> postProduct(Product product);
}
