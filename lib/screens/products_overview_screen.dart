import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider/providers/cart.dart';
import 'package:udemy_provider/screens/cart_screen.dart';
import 'package:udemy_provider/widgets/app_drawer.dart';
import 'package:udemy_provider/widgets/badge.dart';

import '../widgets/products_grid.dart';
enum FilterOptions {
  Favorites,
  All,
}
class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    print('Products over view build');
  //  bool _showOnlyFavorites = false; 22222222222222222222222222222222222222

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          cartButton(),
          FavoritePopupButton(),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }

  Widget FavoritePopupButton() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedOption) {
        setState(() {
          if (selectedOption == FilterOptions.Favorites) {
            _showOnlyFavorites = true;
          } else {
            _showOnlyFavorites = false;
          }
        });
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Text('Only Favorites'),
          value: FilterOptions.Favorites,
        ),
        PopupMenuItem(
          child: Text('Show All'),
          value: FilterOptions.All,
        )

      ],
    );
  }

  Widget cartButton() {
    return Consumer<Cart>(
      builder: (_, cart, ch) => Badge(
        child: ch,  //ch가 아래 child 인듯하다.!
        value: cart.itemCount.toString(),
      ),
      child: IconButton(  //이건 변경될 필요가 없는거니까 child로 둬도 무방함.
        icon: Icon(
          Icons.shopping_cart,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            CartScreen.routeName
          );
        },
      ),
    );
  }
}
