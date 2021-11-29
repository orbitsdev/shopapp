import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/exception/http_exception.dart';
import 'package:shop/model/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  var showFavoriteOnly = false;

  String? authtoken;
  String? userId;

  Products(this.authtoken, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProductData() async {
    var url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product.json?auth=$authtoken&orderBy="creatorid"&equalTo="$userId"');

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      print(extractData);
      List<Product> loadedProduct = [];

      extractData.forEach((productid, productdata) {
        loadedProduct.insert(
            0,
            Product(
                id: productid,
                title: productdata['title'],
                description: productdata['description'],
                imageUrl: productdata['imageUrl'],
                price: productdata['price']));
      });

      _items = loadedProduct;
      print('_____________');
      notifyListeners();

      // url = Uri.parse(
      //     'https://shop-27d83-default-rtdb.firebaseio.com/userfavorite/$userId.json?auth=$authtoken');

      // final favoriteresponse = await http.get(url);
      // final favoriteData = json.decode(favoriteresponse.body);

      // final List<Product> loadedProduct = [];
      // extractData.forEach((prodId, productdata) {
      //   loadedProduct.insert(
      //       0,
      //       Product(

      //         id: prodId,
      //         title: productdata['title'],
      //         description: productdata['description'],
      //         imageUrl: productdata['imageUrl'],
      //         price: productdata['price'],
      //         isFavorite: favoriteData[prodId] == null
      //             ? false
      //             : favoriteData[prodId] ?? false,
      //       ));
      // });

      // _items = loadedProduct;
      // notifyListeners();
    } catch (error) {
      print(error);

      throw (error);
    }
  }

  Product finById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product.json?auth=$authtoken');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'creatorid': userId,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
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
          'https://shop-27d83-default-rtdb.firebaseio.com/product/$id.json?auth=$authtoken');
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
        'https://shop-27d83-default-rtdb.firebaseio.com/product/$id.json?auth=$authtoken');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingproductindex, product);
      notifyListeners();
      throw HttpExeption('Colud Not Delete Prodyct');
    }

    product = null;
  }
}
