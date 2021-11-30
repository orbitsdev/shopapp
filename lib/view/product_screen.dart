import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_grid.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductScreen extends StatefulWidget {
//  final productcontroller = Get.put(ProductController());

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var isShowFavorite = false;
  var _isproductload = true;

  var _islaoding = false;
  @override
  void didChangeDependencies() async {
    if (_isproductload) {
      try {
        setState(() {
          _islaoding = true;
        });

        await Provider.of<Products>(context).fetchProductData();
    
        setState(() {
          _islaoding = false;
        });
      } catch (error) {
        setState(() {
          _islaoding = false;
        });
      }
    }
    _isproductload = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productObject = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorite) {
                    isShowFavorite = true;
                  } else {
                    isShowFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOption.Favorite),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (context, cartobject, ch) => Badge(
                value: cartobject.itemCount.toString(),
                color: Theme.of(context).primaryColor,
                child: ch as Widget),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _islaoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (productObject.items.length <= 0)
              ? Center(child: Text('No Item Is Available '))
              : SafeArea(
                  child: ProductGrid(isShowFavorite),
                ),
    );
  }
}
