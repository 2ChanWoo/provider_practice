import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

import '../controllers/productController.dart';
import 'package:get/get.dart';

class ProductsGrid extends StatelessWidget {
  bool _showOnlyFavorites;
  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    print('grid_item build');
    final productsData = Provider.of<Products>(context); // listen : false 해도 똑같은데?? 22
    final products = _showOnlyFavorites ? productsData.favoriteItems : productsData.items;
    final p = Products.to
//  내가 작성한 ver.
//    List<Product> products;   //위에 productData도 List<Product>인데
//                              //왜 이 코드는 product를 import해야하지??
//
//    if(_showOnlyFavorites == true)
//      products = productsData.items.where((e) => e.isFavorite == true).toList();
//    else
//      products = productsData.items.where((e) => e.isFavorite == false).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),    //const를 사용하는 것이 좋은 습관????
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        //create: (c) => products[i],
        child: ProductItem(
//            products[i].id,
//            products[i].title,
//            products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }


}
