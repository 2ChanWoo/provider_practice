import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'products_overview_screen.dart';
import 'auth_screen.dart';

import '../controllers/auth.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<Auth>(context); --
    final auth = Auth.to;
    print('first screen build... auth is ... ${auth.isAuth}');

    return GetBuilder<Auth>(
        builder : (auth) => auth.isAuth
        ? ProductsOverviewScreen()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? Container(
                        color: Colors.cyan,
                      )
                    : AuthScreen(),
          )
    );
  }
}
