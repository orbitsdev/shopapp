import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = '/userproduct';

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  var _shopisloading = true;
  var _isloading = false;

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProductData();
  }

  @override
  void didChangeDependencies() async {
    if (_shopisloading) {
      try {
        setState(() {
          _isloading = true;
        });

        await Provider.of<Products>(context).fetchProductData();
        setState(() {
          _isloading = false;
        });
      } catch (error) {
        setState(() {
          _isloading = false;
        });
      }
    }

    _shopisloading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productsData.items.length <= 0
              ? Center(child: Text('Your Shop Is Empty'))
              : RefreshIndicator(
                  onRefresh: () => _refreshProduct(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              UserProductItem(
                                  productId: productsData.items[index].id,
                                  userid:productsData.userId as String,
                                  title: productsData.items[index].title,
                                  imageUrl: productsData.items[index].imageUrl),
                              Divider(),
                            ],
                          );
                        }),
                  ),
                ),
    );
  }
}
