import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments  == null
        ? 'NULL'
        : ModalRoute.of(context)!.settings.arguments as String;

    final product;
    if (productId == 'NULL') {
      product = Product(

          id: '',
         
          title: '',
          description: '',
          imageUrl: '',
          price: 0);
    } else {
      product = Provider.of<Products>(context).finById(productId);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: productId == 'NULL'
          ? Center(child: Text('No data'))
          : SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('\$${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    '${product.description}',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )
              ]),
            ),
    );
  }
}
