import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/view/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  
  final String userid;
  final String productId;
  final String title;
  final String imageUrl;
  UserProductItem({
    Key? key,
    required this.productId,
    required this.userid, 
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: productId);
              },
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
            ),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(productId);
                  } catch (error) {
                    scaffold
                        .showSnackBar(SnackBar(content: Text('Delete Faild')));
                        print(error);
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                )),
          ],
        ),
      ),
    );
  }
}
