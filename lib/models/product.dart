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
}


