import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isorderloaded = true;
  var _isloading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Orders>(context, listen: false).fetchandPrepaireData();
  //   });

  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    if (_isorderloaded) {
      try {
        setState(() {
          _isloading = true;
        });

        await Provider.of<Orders>(context).fetchandPrepaireData();
        setState(() {
          _isloading = false;
        });
      } catch (error) {
        setState(() {
          _isloading = false;
        });
      }
    }

    _isorderloaded = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (orderData.theorders.length <= 0)
              ? Center(
                  child: Text('No Orders'),
                )
              : ListView.builder(
                  itemCount: orderData.theorders.length,
                  itemBuilder: (context, index) {
                    return ord.OrderItem(orderData.theorders[index]);
                  }),
    );
  }
}
