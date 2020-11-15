import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider/providers/cart.dart';
import 'package:udemy_provider/providers/products.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //아래코드는 initState에서는 context를 사용할 수 없기 때문에 발생하였고,
    //만약, listen : false 로 설정해준다면 , 아래코드도 사용 가능하다.!
    //Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!

    //아래 코드는 일종의 해킹 방법이다. 안되는 코드를 어떻게든 되게 만든 것.!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  //위 initState에서 동작하지 않는 코드를 did를 이용하여 해결할 수 있다.
  @override
  void didChangeDependencies() {
    //여기서는 반드시 한번만 실행할 수 있도록 _isInit이 필요하다..! 아니면 무한 get하는데???
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading ? Center( child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavorites),
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
