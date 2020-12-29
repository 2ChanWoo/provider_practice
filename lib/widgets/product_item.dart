import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider/providers/auth.dart';
import 'package:udemy_provider/providers/product.dart';

import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    print('product_item build');
    final prod = Provider.of<Product>(context,
        listen: false); // listen : false 해도 똑같은데??
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    //원래 타입을 몰라서 그냥 앞에 긴 타입을 안적어놨음. ctrl+q 로 확인한 타입은 아래와 같다.
    //ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    // --------------------------- Widget 반환하도록 다시 바꿈.
    Widget addCartSnackBar() {
      return SnackBar(
        content: Text(
          'add to cart!   \'${prod.title}\'',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Theme.of(context).primaryColorLight,
        duration: Duration(milliseconds: 1800),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            cart.removeSingleItem(prod.id);
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: prod.id,
              );
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(prod.imageUrl),
              fit: BoxFit.cover,
            )
//          Image.network(
//            prod.imageUrl,
//            fit: BoxFit.cover,
//          ),
            ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  prod.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                prod
                    .toggleFavoriteStatus(
                  auth.token,
                  auth.userId,
                )
                    .catchError((error) {
                  print('Favorite Icon Button Error ::::: $error');
                });
              },
            ),
          ),
          title: Text(
            prod.title ?? '',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              //이렇게하면 안되는데 왜 이렇게 했지? 그래도 본능적으로 알아서 다행이다
              // Cart().addItem(prod.id, prod.price, prod.title);
              cart.addItem(prod.id, prod.price, prod.title);
              Scaffold.of(context).hideCurrentSnackBar(); //스낵바 바로바로 나오게!!
              Scaffold.of(context).showSnackBar(addCartSnackBar());
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
