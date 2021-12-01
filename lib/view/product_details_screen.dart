import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments == null
        ? 'NULL'
        : ModalRoute.of(context)!.settings.arguments as String;

    final product;
    if (productId == 'NULL') {
      product =
          Product(id: '', title: '', description: '', imageUrl: '', price: 0);
    } else {
      product = Provider.of<Products>(context).finById(productId);
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: productId == 'NULL'
          ? Center(child: Text('No data'))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(product.title),
                    background: Hero(
                      tag: productId,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  ),
                  SizedBox(height: 800),
                ])),
              ],
            ),
    );
  }
}
