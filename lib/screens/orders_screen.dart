import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:provider/provider.dart';

//import '../providers/orders.dart' show Orders;
import '../controllers/orderController.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    //return Provider.of<Orders>(context, listen: false).fetchAndSetOrders(); --
    return OrderController.to.fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();

    _ordersFuture = _obtainOrdersFuture();
  }
  //원래 FutureBuilder쓰이는게 맞는데 그냥 내가 이렇게 해버림. ------------- FutureBuilder가 맞는방법인듯싶다.

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Obx(() => ListView.builder(      // ----- consumer to obx
                  itemCount: OrderController.to.orders.length,
                  itemBuilder: (ctx, i) =>
                      OrderItem(OrderController.to.orders[i]), //cart보다 요방식이 더 낫제~
                ),
              );
            }
          }
        },
      ),
    );
  }
}
