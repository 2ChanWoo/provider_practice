import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  RxBool isFavorite = false.obs;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) {
    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final backupFavorite = isFavorite.value;
    isFavorite.value = !backupFavorite;

    return http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    )
        .then((value) {
      if (value.statusCode >= 400) {
        print('http ErrorCode :: ${value.statusCode}');
        isFavorite.value = backupFavorite;
      }
    }).catchError(
          (error) {
        isFavorite.value = backupFavorite;
        print('toggleFavoriteStatus() ERROR ::::: $error');
        throw error;
      },
    );
  }
}


