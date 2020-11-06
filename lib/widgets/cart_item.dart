import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  //이렇게 하나씩 넘겨받는 거 보다 orders방식처럼 list를 통쨰로 주는게 나을듯
  final String id;
  final String productId; //key
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart, //어느쪽으로 스와이프 할 것 인지.
      confirmDismiss: (direction) async {
        print(direction);
        bool delCart;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              //아래처럼 Text에 \n 을 사용하니까, 다이어로그 center정렬이 자동으로 안되네
              content: Text('$title\n장바구니에서 제거하시겠습니까?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    delCart = true;
                  },
                ),
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                    delCart = false;
                  },
                ),
              ],
            );
          },
        );
        return delCart;
      },
      onDismissed: (direction) async {
        Provider.of<Cart>(context, listen: false).removeItem(productId);  //굳이 이렇게 한 이유가?? cart.removeItem이 아니라..
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
