import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';



class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    print('detail page build'); //다른페이지로 갔다가 돌아올 때 써보자.. listen : true 하고.
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
//    final loadedProducts = Provider.of<Products>(context)
//              .items.firstWhere((prod) => prod == productId);
    // 위와 동일한 코드를, 가볍게 만든 것이 바로 아래 코드.
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    //이렇게 함수로 미리 만들어두는것이 더 빠른건가...?

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}


