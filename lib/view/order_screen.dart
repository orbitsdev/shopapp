import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.theorders.length,
          itemBuilder: (context, index) {
            return ord.OrderItem(orderData.theorders[index]);
          }),
    );
  }
}
