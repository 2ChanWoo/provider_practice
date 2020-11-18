import 'package:flutter/material.dart';
import 'package:udemy_provider/screens/auth_screen.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My item'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Lisence'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LicensePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Login'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AuthScreen()));
            },
          ),
        ],
      ),
    );
  }
}
