import 'package:flutter/material.dart';
import 'package:udemy_provider/controllers/cartController.dart';
//import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../controllers/orderController.dart';
import 'package:get/get.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
 //   final cart = Provider.of<Cart>(context);
    final cart = CartController.to;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(/*cart: cart*/)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                //이렇게 하나씩 넘겨주는 거 보다 orders방식처럼 list를 통쨰로 주는게 나을듯
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
 //   @required this.cart,
  }) : super(key: key);

//  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  final cart = CartController.to;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });
//        await Provider.of<Orders>(context, listen: false).addOrder(
//          cart.items.values.toList(),
//          cart.totalAmount,
//        );
        await OrderController.to.addOrder(cart.items.values.toList(), cart.totalAmount);
        setState(() {
          _isLoading = false;
        });
        cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
