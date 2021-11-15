import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  double price;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldfavoritedata = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://shop-27d83-default-rtdb.firebaseio.com/product/$id.json');

    try {
      await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
    } catch (error) {
      isFavorite = oldfavoritedata;
      notifyListeners();
    }
  }
}
