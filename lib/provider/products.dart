import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/exception/http_exception.dart';
import 'package:shop/model/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  var showFavoriteOnly = false;
  List<Product> get items {
    return [..._items];
  }

  Product finById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));

      final newproduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newproduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = _items.indexWhere((element) => element.id == id);

    if (proIndex >= 0) {
      final url = Uri.parse(
          'https://shop-27d83-default-rtdb.firebaseio.com/product/$id.json');
      await http.patch(url,
          body: json.encode({
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'title': newProduct.title,
          }));

      _items[proIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> removeProduct(String id) async {
    final existingproductindex =
        _items.indexWhere((product) => product.id == id);
    Product? product = _items[existingproductindex];
    _items.removeAt(existingproductindex);
    notifyListeners();

    final url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product/$id.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingproductindex, product);
      notifyListeners();
      throw HttpExeption('Colud Not Delete Prodyct');
    }

    product = null;
  }

  Future<void> fetchProductData() async {
    final url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product.json');

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final List<Product> loadedProduct = [];
      extractData.forEach((key, productdata) {
        loadedProduct.insert(
            0,
            Product(
                id: key,
                title: productdata['title'],
                description: productdata['description'],
                imageUrl: productdata['imageUrl'],
                price: productdata['price'],
                isFavorite: productdata['isFavorite']));
      });

      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);

      throw (error);
    }
  }
}
