import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:udemy_provider/controllers/auth.dart';
import '../models/http_exception.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  RxList<Product> _items = <Product>[
//    Product(
//    id: 'p1',
//    title: 'Red Shirt',
//    description: 'A red shirt - it is pretty red!',
//    price: 29.99,
//    imageUrl:
//    'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//  ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ].obs;

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

  RxList<Product> get items { //안돼는줄 알았는데, 실험결과 반환 제대로 될듯요
//    return [..._items];
      return _items;
  }

  List<Product> get favoriteItems {   //이렇게 게터하면 자동반환 되는거지? obs값이 아니게되나..? otList니까..??
    return _items.where((e) => e.isFavorite == true ).toList();
  }   // 아..ㅋㅋ _items.obs 안의 값 isFavorite도 obs니까 .value를 붙어야지~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  bool isFavofite(String id) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    return _items[prodIndex].isFavorite;
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId, String id) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final currentItem = _items[prodIndex];

    final url =
        'https://flutter-udemy-3cde6.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final backupFavorite = currentItem.isFavorite;
    //currentItem.isFavorite = !backupFavorite;
    currentItem.changeFavorite(!backupFavorite);

    return http.put(
      url,
      body: json.encode(
        currentItem.isFavorite,
      ),
    )
        .then((value) {
      if (value.statusCode >= 400) {
        print('http ErrorCode :: ${value.statusCode}');
        currentItem.isFavorite = backupFavorite;
      }
    }).catchError(
          (error) {
            currentItem.isFavorite = backupFavorite;
        print('toggleFavoriteStatus() ERROR ::::: $error');
        throw error;
      },
    );
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
          print(loadedProducts[loadedProducts.length - 1].toString());
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