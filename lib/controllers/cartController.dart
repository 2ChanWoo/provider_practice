import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:udemy_provider/controllers/productController.dart';
import '../models/cart.dart';

class CartController extends GetxController {
  RxMap<String, Cart> _items = {}.obs;

  static CartController get to {
    return Get.find();
  }

//  Map<String, Cart> get items {
//    return {..._items};
//  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //이미 있을경우
      // change quantity...
      _items.update(    //get에서의 class업데이트랑은 다른거지? ㅇㅇ
        productId,      //해당 cart값을 버리고 새로운 cart로 대체하는거겟지? cart가 final이니까. ==> ㅇㅇ 실험완료.
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
      print('+1 $title');
    } else {
      //새로 추가할경우.
      _items.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      print('new item in my cart! - $title !!');
    }
  }

  //quantity를 obs로 바꾸고, 위의 update대신 quantity+1 으로 바꾸면 간단해질듯.
  double get totalAmount {
    double total = 0.0;
    print('total ------------------------------------- $total');
    _items.forEach((key, value) {
      print('price ------------------------ ${value.price}');
      print('quantity -------------------------- ${value.quantity}');

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
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => Cart(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
  }

  void clear() {
    _items.assignAll({});
    // 그냥 {}이면 에러가나네용,, 앞에 RxMap<String,Cart> 같은건 붙이면 안되네 ㅋㅋ ==> {}.obs
    //{}.obs 에서 assignAll로 바꿈.
  }
}
