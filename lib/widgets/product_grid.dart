import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isShowFavorite;
  ProductGrid(this.isShowFavorite);

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    // final productcollection = productData.items;

    final producData = Provider.of<Products>(context);
    final productcollection =
        isShowFavorite ? producData.favoriteItems : producData.items;

    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: productcollection.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
              value: productcollection[index], child: ProductItem());
          // create: (_) => productcollection[index], child: ProductItem());
        });
  }
}
