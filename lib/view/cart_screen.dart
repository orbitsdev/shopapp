import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.item.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: Text('ORDER NOW')),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          //       Text('${cart.item.length}'),
          Expanded(
            child: ListView.builder(
                itemCount: cart.item.length,
                itemBuilder: (context, index) {
                  return ci.CartItem(
                      id: cart.item.values.toList()[index].id,
                      productId: cart.item.keys.toList()[index],
                      price: cart.item.values.toList()[index].price,
                      quantity: cart.item.values.toList()[index].quantity,
                      title: cart.item.values.toList()[index].title);
                }),
          ),
        ],
      ),
    );
  }
}
