import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:udemy_provider/controllers/auth.dart';
import '../models/http_exception.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  RxList<Product> _items = <Product>[].obs;

  String authToken;
  String userId;


  @override
  void onInit() {
    print('ProductController init');

    everAll([Auth.to.RxToken, Auth.to.RxUserId], (_) {
      authToken = Auth.to.RxToken.value;
      userId = Auth.to.RxUserId.value;
    });
  }

  ProductController(this.authToken, this.userId);

  static ProductController get to {
    return Get.find();
  }

  List<Product> get items { //안돼는줄 알았는데, 실험결과 반환 제대로 될듯요
    return [...items];
  }

  List<Product> get favoriteItems {   //이렇게 게터하면 자동반환 되는거지? obs값이 아니게되나..? otList니까..??
    return _items.where((e) => e.isFavorite.value == true ).toList();
  }   // 아..ㅋㅋ _items.obs 안의 값 isFavorite도 obs니까 .value를 붙어야지~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  //강의버전에서는 await version임.
  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    print('authToken is ... $authToken');
    print('userId is ... $userId');
    String filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/products.json?auth=$authToken&$filterString';
    final url2 =
        'https://flutter-udemy-3cde6.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    return http.get(url).then((response) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null || extractedData['error'] != null) {
        print('---------------- extractedData ::::: $extractedData');
        print('------------------- extractedData null check');
        return;
      }

      http.get(url2).then((favoriteResponse) {
        final favoriteData = json.decode(favoriteResponse.body);

        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            //isFavorite: prodData['isFavorite'],
            isFavorite:
            favoriteData == null ? false : (favoriteData[prodId] ?? false),
            imageUrl: prodData['imageUrl'],
          ));
        });

        //_items = loadedProducts;
        _items.assignAll(loadedProducts);
      });
    }).catchError((error) {
      print('fetchAndSetProducts error ::::::::::::::: $error');
      throw error;
    });
  }

  Future<void> addProduct(Product product) {
    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/products.json?auth=$authToken'; //.json은 파베 형식.
    //await Future.delayed(Duration( seconds:  3 ));
    return http
        .post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
//      'isFavorite': product.isFavorite,
          'creatorId': userId,
        }))
        .then((response) {
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

  //updateProduct 의 노랑밑줄은 if를 그냥 넘어가게되면 return값이 없을 수도 있다는 경고.
  Future<void> updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/products/$id.json?auth=$authToken';
    if (prodIndex >= 0) {
      return http
          .patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }))
          .then((value) {
        _items[prodIndex] = newProduct; //로컬 업뎃도 그냥 두는구낭
      }).catchError((error) {
        //patch 에서는 에러스탯코드오면 Error가 안잡힙-----------------------------------------------
        print('업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류업뎃 오류');
        throw error;
      });
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product.'); //dart.io 에도 똑같은게 있나본데??
    }
    existingProduct = null;
  }

}