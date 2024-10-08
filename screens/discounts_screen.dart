import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';

import './categories_screen.dart';
import './favorites_screen.dart';

class DiscountsScreen extends StatelessWidget {
  static const routeName = '/DiscountsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Reducerile noastre",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        actions: [
          Container(
            width: 60,
          ),
        ],
        leading: Container(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            FontAwesome.heart
          ),
          Icon(Icons.home),
          Icon(FontAwesome.percent),
        ],
        height: 50,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 400),
        index: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoriesScreen(),
              ),
            );
          }
          if (index == 0) {
            Navigator.of(context).pushNamed(FavoritesScreen.routeName);
          }
        },
      ),
    );
  }
}
