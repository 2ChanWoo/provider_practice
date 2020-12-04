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
    RxBool ll = false.obs;
    ll = true.obs;
    print(ll);
    //final productsData = Provider.of<Products>(context); // listen : false 해도 똑같은데?? 22
    final productsData = ProductController.to;
    final products = _showOnlyFavorites ? productsData.favoriteItems : productsData.items;
    print('grid_item build  Get Items...');

    return Obx(() => GridView.builder(
        padding: const EdgeInsets.all(10.0),    //const를 사용하는 것이 좋은 습관????
        itemCount: productsData.items.length,
        itemBuilder: (ctx, i) => ProductItem(productsData.items[i]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }


}
