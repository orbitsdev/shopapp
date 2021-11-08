import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/cart_screen.dart';
import 'package:shop/view/order_screen.dart';
import 'package:shop/view/product_details_screen.dart';
import 'package:shop/view/product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Products()),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProvider(
            create: (_) => Orders(),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: ProductScreen(),
          routes: {
            ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
