import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;    //하도많이서 충돌이 일어날 수 있기 때문에 http만 사용할 수 있도록?

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((e) => e.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //강의버전에서는 await version임.
  Future<void> fetchAndSetProducts() {
    const url = 'https://flutter-udemy-3cde6.firebaseio.com/products.json';

    return http.get(url).then((response) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      print(extractedData);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    }).catchError((error) {
      print('fetchAndSetProducts error ::::::::::::::: $error');
      throw error;
    });
  }

  Future<void> addProduct(Product product) {
    const url = 'https://flutter-udemy-3cde6.firebaseio.com/products.json'; //.json은 파베 형식.
    //await Future.delayed(Duration( seconds:  3 ));
    return http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    })).then((response) {
      print(response);
      print(json.decode(response.body));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        //id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    }).catchError((error) {
      print('@ @@ @@@ @@ @ addProduct in catchError : $error');
      throw error;
    });
// 위로옮김
//    final newProduct = Product(
//      title: product.title,
//      description: product.description,
//      price: product.price,
//      imageUrl: product.imageUrl,
//      id: DateTime.now().toString(),
//    );
//    _items.add(newProduct);
//    // _items.insert(0, newProduct); // at the start of the list
//    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = 'https://flutter-udemy-3cde6.firebaseio.com/products/$id.json';
    if (prodIndex >= 0) {
      return http.patch(url, body: json.encode({
        'title' : newProduct.title,
        'price' : newProduct.price,
        'description' : newProduct.description,
        'imageUrl' : newProduct.imageUrl,
      })
      ).then((value) {
        _items[prodIndex] = newProduct; //로컬 업뎃도 그냥 두는구낭
        notifyListeners();
      }).catchError((error) {
        print('업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류');
        throw error;
      });
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.'); //dart.io 에도 똑같은게 있나본데??
    }
    existingProduct = null;
  }
}
