import 'package:flutter/material.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/auth_screen.dart';
import 'package:shop/view/cart_screen.dart';
import 'package:shop/view/edit_product_screen.dart';
import 'package:shop/view/order_screen.dart';
import 'package:shop/view/product_details_screen.dart';
import 'package:shop/view/product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/splash_screen.dart';
import 'package:shop/view/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token as String,
              auth.userId as String,
              previousProducts!.items == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart('', {}),
          update: (ctx, auth, previousCart) => Cart(auth.token as String,
              previousCart!.item == null ? {} : previousCart.item),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token as String,
              auth.userId as String,
              previousOrders == null ? [] : previousOrders.theorders),
        ),
      ],
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                ),
                home: auth.isAuth
                    ? ProductScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authresult) =>
                            authresult.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()),
                routes: {
                  ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
                  CartScreen.routeName: (_) => CartScreen(),
                  OrderScreen.routeName: (_) => OrderScreen(),
                  UserProductScreen.routeName: (_) => UserProductScreen(),
                  EditProductScreen.routeName: (_) => EditProductScreen(),
                },
                debugShowCheckedModeBanner: false,
              )),
    );
  }
}
