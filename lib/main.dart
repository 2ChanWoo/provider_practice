import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udemy_provider/providers/auth.dart';
import 'package:udemy_provider/providers/cart.dart';
import 'package:udemy_provider/providers/orders.dart';
import 'package:udemy_provider/screens/auth_screen.dart';
import 'package:udemy_provider/screens/cart_screen.dart';
import 'package:udemy_provider/screens/first_screen.dart';
import 'package:udemy_provider/screens/orders_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() {
  //SharedPreferences.setMockInitialValues({});
  //Once you have called dispose() on a Products, it can no longer be used.
  //Udemy에서 위 경고에 setMockInitialValues 이거쓰면 경고 없어진다했는데,,
  //아예 오토로그인이 안됨 ㅜ
  //저게 SharedPreferences값을 테스트값으로 바꾸는거라네 ㅡㅡ ㅁㅈ

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('---------------------------main build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            //Orders는 사용자구분 내가 귀찮아서 안한듯
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: FirstScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            }),

    );
  }
}
