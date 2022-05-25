import 'package:my_shop/models/product.dart';

class ProductsAdapter {
  static List<Product> fetchProductsToListOfProducts(
      Map<String, dynamic> data) {
    return data.keys
        .map((key) => Product(
            id: key,
            title: data[key]['title'],
            description: data[key]['description'],
            price: data[key]['price'],
            imageUrl: data[key]['imageUrl']))
        .toList();
  }
}
