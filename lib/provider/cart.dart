import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  String? authToken;

  Cart(this.authToken, this._items);

  Map<String, CartItem> get item {
    return {..._items};
  }
  // Map<String, CartItem> get items {
  //   return {...items};
  // }

  Future<void> addItem(
    String productId,
    double price,
    String title,
  ) async {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingcartItem) => CartItem(
              id: existingcartItem.id,
              title: existingcartItem.title,
              quantity: existingcartItem.quantity + 1,
              price: existingcartItem.price));

      final cartid = _items[productId]!.id;
      final oldquantityvalue = _items[productId]!.quantity;

      try {
        final url = Uri.parse(
            'https://shop-27d83-default-rtdb.firebaseio.com/cart/$productId/$cartid.json?auth=$authToken');
        final response = await http.patch(url,
            body: json.encode({
              'quantity': oldquantityvalue + 1,
            }));
      } catch (error) {
        throw (error);
      }

      print('success');
    } else {
      final url = Uri.parse(
          'https://shop-27d83-default-rtdb.firebaseio.com/cart/$productId.json?auth=$authToken');
      var thetime = DateTime.now().toString();
      try {
        final response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              'title': title,
              'quantity': 1,
              'price': price,
            }));

        var cartid = json.decode(response.body)["name"];
        final carturl = Uri.parse(
            'https://shop-27d83-default-rtdb.firebaseio.com/cart/$productId/$cartid.json?auth=$authToken');

        final fetchcart = await http.get(carturl);
        final cart = json.decode(fetchcart.body);

        _items.putIfAbsent(
            productId,
            () => CartItem(
                id: cartid,
                title: cart['title'],
                quantity: cart['quantity'],
                price: cart['price']));
      } catch (error) {
        throw (error);
      }
    }

    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    // to sum map dat; use for each
    var total = 0.0;

    _items.forEach((key, cartitem) {
      total += cartitem.price * cartitem.quantity;
    });

    return total;
  }

  Future<void> removeItem(String productId) async {
    final cartid = _items[productId]!.id;
    final oldquantityvalue = _items[productId]!.quantity;
    try {
      final url = Uri.parse(
          'https://shop-27d83-default-rtdb.firebaseio.com/cart/$productId/$cartid.json?auth=$authToken');

      await http.delete(url);
      _items.remove(productId);
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    final cartid = _items[productId]!.id;
    final oldquantityvalue = _items[productId]!.quantity;

    if (_items[productId]!.quantity > 1) {
    } else {
      try {
        final url = Uri.parse(
            'https://shop-27d83-default-rtdb.firebaseio.com/cart/$productId.json?auth=$authToken');

        final response = await http.get(url);
        _items.remove(productId);
      } catch (error) {
        throw (error);
      }
    }
    notifyListeners();
  }
}
