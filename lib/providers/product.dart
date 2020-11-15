import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() {
    final url = 'https://flutter-udemy-3cde6.firebaseio.com/products/$id.json';
    final backupFavorite = isFavorite;
    isFavorite = !backupFavorite;
    notifyListeners();

    return http
        .patch(
      url,
      body: json.encode({
        'isFavorite': !backupFavorite,
      }),
    ).then((value) {
      if(value.statusCode >= 400) {
        print('http ErrorCode :: ${value.statusCode}');
        isFavorite = backupFavorite;
        notifyListeners();
      }
    })
        .catchError(
      (error) {
        isFavorite = backupFavorite;
        notifyListeners();
        print('toggleFavoriteStatus() ERROR ::::: $error');
        throw error;
      },
    );
  }
}
