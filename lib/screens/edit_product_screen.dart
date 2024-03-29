import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/services/products_service.dart';
import 'package:provider/provider.dart';

class TargetProduct {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  double? price;

  TargetProduct(
      {this.id, this.title, this.description, this.imageUrl, this.price});
}

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  final IProductsService productsService;

  const EditProductScreen({Key? key, required this.productsService})
      : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  TargetProduct _editedProduct = TargetProduct(
      description: null, imageUrl: null, price: null, title: null);
  bool _isInit = false;
  final _initialState = {'title': '', 'description': '', 'price': ''};
  bool _isloading = false;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      if (ModalRoute.of(context) != null &&
          ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
        final Product product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = TargetProduct(
          id: productId,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _initialState['title'] = product.title;
        _initialState['description'] = product.description;
        _initialState['price'] = product.price.toString();
        _imageUrlController.text = product.imageUrl;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  bool isFormValid(FormState? formState) {
    if (formState == null || !formState.validate()) {
      return false;
    }
    return true;
  }

  void _setIsLoading(bool value) {
    setState(() {
      _isloading = value;
    });
  }

  void _onSubmitError(error) {
    print(error);
    _setIsLoading(false);
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error ocurred!'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'))
              ],
            ));
  }

  void _onSubmitForm() {
    if (!isFormValid(_form.currentState)) return;
    _form.currentState!.save();
    final bool isEditingProduct =
        _editedProduct.id != null && _editedProduct.id!.isNotEmpty;
    final Product product = Product(
        id: _editedProduct.id ?? "",
        title: _editedProduct.title!,
        description: _editedProduct.description!,
        price: _editedProduct.price!,
        imageUrl: _editedProduct.imageUrl!);
    _setIsLoading(true);
    if (isEditingProduct) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(widget.productsService, product)
          .then((_) => _setIsLoading(false))
          .then((value) => Navigator.of(context).pop())
          .catchError(_onSubmitError);
      return;
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(widget.productsService, product)
          .then((_) => _setIsLoading(false))
          .then((_) => Navigator.of(context).pop())
          .catchError(_onSubmitError);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _changeFocusNode(FocusNode next) =>
        FocusScope.of(context).requestFocus(next);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product'), actions: [
        IconButton(onPressed: _onSubmitForm, icon: const Icon(Icons.save))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_isloading)
                  LinearProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.blue[100],
                  ),
                TextFormField(
                  initialValue: _initialState['title'],
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_priceFocusNode),
                  onSaved: (value) {
                    _editedProduct = TargetProduct(
                        id: _editedProduct.id,
                        title: value,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price);
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Provide a valid value.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initialState['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_descriptionFocusNode),
                  focusNode: _priceFocusNode,
                  onSaved: (value) {
                    _editedProduct = TargetProduct(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: value != null ? double.parse(value) : 0);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please provide a valid value.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number grater then zero.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initialState['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_priceFocusNode),
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = TargetProduct(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 6) {
                      return 'Please provide a value grater then 5 character.';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      clipBehavior: Clip.hardEdge,
                      child: _imageUrlController.text.isEmpty
                          ? const Text(
                              'Enter a URL',
                              textAlign: TextAlign.center,
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: Image.network(
                                _imageUrlController.text,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Something happends');
                                },
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () => setState(() {}),
                        onFieldSubmitted: (value) => _onSubmitForm(),
                        onSaved: (value) {
                          _editedProduct = TargetProduct(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: value,
                              price: _editedProduct.price);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
