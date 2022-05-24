import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = 'EditProductScreen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
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
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _changeFocusNode(FocusNode next) =>
        FocusScope.of(context).requestFocus(next);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_priceFocusNode),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_descriptionFocusNode),
                  focusNode: _priceFocusNode,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (value) =>
                      _changeFocusNode(_priceFocusNode),
                  focusNode: _descriptionFocusNode,
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
                                  print(error);
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
