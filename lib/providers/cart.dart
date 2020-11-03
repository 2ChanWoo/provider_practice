import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {  //이미 있을경우
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1,
            ),
      );
      print('+1 $title');
    } else {  //새로 추가할경우.
      _items.putIfAbsent(
        productId,
        () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,
            ),
      );
      print('new item in my cart! - $title !!');
    }
    notifyListeners();
  }

  double get totalAmount {
    double total=0.0;
    print('total -------------------------- $total');
    _items.forEach((key, value) {
      print('total -------------------------- ${value.price}');
      print('total -------------------------- ${value.quantity}');

      total += value.price * value.quantity;
     // return total; //return 이 왜?
    });
    return total;
  }

  //내가만든건 안되눙 ㅜㅜㅜㅜ ==> value.id 와 prodId가 다름.
//  void removeItem(String prodId) {
//    _items.removeWhere((key, value) {value.id == prodId;} );
//    notifyListeners();
//  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
