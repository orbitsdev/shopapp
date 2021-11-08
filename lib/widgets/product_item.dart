import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/view/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline)),
            title: Text(product.title, textAlign: TextAlign.center),
            trailing: IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                },
                icon: Icon(Icons.shopping_cart_rounded)),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailsScreen()));
        },
      ),
    );
  }
}
