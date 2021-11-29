import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imagUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();

  String? token;
  String? userId;

  var _editedProduct = Product(

      id: 'null',
    
      title: 'B',
      description: 'C',
      imageUrl: 'D',
      price: 0);

  var _isArgumentloaded = true;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
  };

  var _isLoading = false;
  @override
  void initState() {
    super.initState();

    _imageFocusNode.addListener(updateImageUrl);
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imagUrlController.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imagUrlController.text.startsWith('http') ||
              !_imagUrlController.text.startsWith('https')) &&
          (!_imagUrlController.text.endsWith('.png') &&
              !_imagUrlController.text.endsWith('.jpg') &&
              !_imagUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid) {
      return;
    }

    _formkey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != 'null') {
      print(_editedProduct.id);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('An error occor'),
                  content: Text('Someting Went Wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isArgumentloaded) {
      final productId = ModalRoute.of(context)!.settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context)!.settings.arguments as String;

      if (productId != "NULL") {
        _editedProduct = Provider.of<Products>(context).finById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imagUrlController.text = _editedProduct.imageUrl;
        _editedProduct = _editedProduct;
      }
    }
    _isArgumentloaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        label: Text('Title'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provie A Value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          
                          id: _editedProduct.id,
                          title: value as String,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.id,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        label: Text('Price'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please Enter Valid Number';
                        }

                        if (double.parse(value) <= 0) {
                          return 'Please Enter A number greater than zero';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                           
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.id,
                            price: double.parse(value as String));
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        label: Text('Description'),
                      ),
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Desciption';
                        }

                        if (value.length < 10) {
                          return 'Input Atlease  10 Characters Long';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                           
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value as String,
                            imageUrl: _editedProduct.id,
                            price: _editedProduct.price);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imagUrlController.text.isEmpty
                              ? Center(child: Text('Enter a Url'))
                              : FittedBox(
                                  child: Image.network(_imagUrlController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: Text('Image Url'),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imagUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter an Image Url';
                              }

                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Url a valid url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please Enter a valid image Url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                 
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value as String,
                                  price: _editedProduct.price);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
