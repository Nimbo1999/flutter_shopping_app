import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/products-overview-screen';
  final IProductsService productsService;

  const ProductsOverviewScreen({Key? key, required this.productsService})
      : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = true;

  void setShowOnlyFavorites(bool newValue) {
    setState(() {
      _showOnlyFavorites = newValue;
    });
  }

  void setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchProducts(widget.productsService)
        .then((_) => setIsLoading(false));
    super.initState();
  }

  void onChangeFilter(FilterOptions filterOption) {
    if (FilterOptions.Favorites == filterOption) {
      return setShowOnlyFavorites(true);
    }
    setShowOnlyFavorites(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: onChangeFilter,
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.Favorites,
                      child: Text('Only Favorites'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Show all'),
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) =>
                Badge(value: cart.itemsCount.toString(), child: child!),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(strokeWidth: 5),
            )
          : ProductsGrid(
              showOnlyFavorites: _showOnlyFavorites,
              productsService: widget.productsService),
    );
  }
}
