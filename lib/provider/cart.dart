import 'package:flutter/foundation.dart';

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

  Map<String, CartItem> get item {
    return {..._items};
  }
  // Map<String, CartItem> get items {
  //   return {...items};
  // }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingcartItem) => CartItem(
              id: existingcartItem.id,
              title: existingcartItem.title,
              quantity: existingcartItem.quantity + 1,
              price: existingcartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existcartitem) => CartItem(
              id: existcartitem.id,
              title: existcartitem.title,
              quantity: existcartitem.quantity - 1,
              price: existcartitem.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
