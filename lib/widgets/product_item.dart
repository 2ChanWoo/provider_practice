import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider/providers/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    print('product_item build');
    final prod = Provider.of<Product>(context, listen: false); // listen : false 해도 똑같은데??

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
          child: Image.network(
            prod.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(prod.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => prod.toggleFavoriteStatus(),
            ),
          ),
          title: Text(
            prod.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
