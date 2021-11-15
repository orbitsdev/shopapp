import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get theorders {
    return [..._orders];
  }

  Future<void> fetchandPrepaireData() async {
    final url =
        Uri.parse('https://shop-27d83-default-rtdb.firebaseio.com/order.json');

    try {
      final response = await http.get(url);

      var extreactdata = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> fetchdata = [];

      extreactdata.forEach((key, orderdata) {
        fetchdata.add(OrderItem(
            id: key,
            amount: orderdata['amount'],
            products: (orderdata['product'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
            dateTime: DateTime.parse(orderdata['dateTime'])));
      });

      _orders = fetchdata;
      notifyListeners();
    } catch (error) {
      throw 'error';
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        Uri.parse('https://shop-27d83-default-rtdb.firebaseio.com/order.json');

    final thedate = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode({
            'id': thedate.toString(),
            'amount': total,
            'dateTime': thedate.toIso8601String(),
            'product': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList()
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              dateTime: thedate,
              products: cartProducts));

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
