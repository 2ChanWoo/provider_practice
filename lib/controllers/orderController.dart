import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/order.dart';
import '../models/cart.dart';


import 'package:get/get.dart';

class OrderController extends GetxController {
  RxList<Order> _orders = [].obs;

  List<Order> get orders {
    return [..._orders];
  }

  String authToken;

  OrderController(this.authToken, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        Order(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => Cart(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            ),
          )
              .toList(),
        ),
      );
    });
    //_orders = loadedOrders.reversed.toList();
    _orders.assignAll(loadedOrders.reversed.toList());
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price,
          })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
    } catch (e) {
      print('addOrder error ::::: $e');
    }
  }
}