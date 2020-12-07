import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:udemy_provider/screens/edit_product_screen.dart';

import '../providers/products.dart';
import '../controllers/productController.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import 'package:get/get.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshProducts(BuildContext ctx) async{
    //await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(filterByUser:  true); --
    await ProductController.to.fetchAndSetProducts(filterByUser:  true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Provider.of<Products>(context, listen: false).fetchAndSetProducts(filterByUser:  true); --
    ProductController.to.fetchAndSetProducts(filterByUser:  true);

  }

  @override
  Widget build(BuildContext context) {
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    //final productsData = Provider.of<Products>(context);    --
    final productsData = ProductController.to;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
        padding: EdgeInsets.all(8),
        child: Obx( () => ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
        ),)
      ),)
    );
  }
}
