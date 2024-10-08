import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/my_flutter_app_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import '../models/type_enum.dart';

import '../screens/subcategories_screen.dart';
import '../screens/category_list_screen.dart';
// import '../utils/user_simple_preferences.dart';

final mediciSubcategs = [
  new CategoryWidget(
      10,
      'Dentisti',
      Icon(
        MaterialCommunityIcons.tooth,
        color: Colors.greenAccent,
      ),
      Type.Cabinet,
      'Subcategories'),
  new CategoryWidget(
      11, 'Pediatrii', Icon(FontAwesome.child), Type.Cabinet, 'Subcategories'),
  new CategoryWidget(
      12,
      'Oftalmologi',
      Icon(FontAwesome.eye, color: Colors.blueGrey),
      Type.Cabinet,
      'Subcategories'),
  new CategoryWidget(13, 'Clinici', Icon(FontAwesome.hospital_o), Type.Cabinet,
      'Subcategories')
];

final saloaneSubcategs = [
  new CategoryWidget(
      20,
      'Barber',
      Icon(
        MyFlutterApp.barber,
        color: Colors.brown,
      ),
      Type.Salon,
      'Subcategories'),
  new CategoryWidget(
      21,
      'Coafor',
      Icon(
        MyFlutterApp.makeover,
        color: Colors.redAccent,
      ),
      Type.Salon,
      'Subcategories'),
  new CategoryWidget(
      22,
      'Spa & Relax',
      Icon(
        MyFlutterApp.massage,
        color: Colors.yellow.shade900,
      ),
      Type.Salon,
      'Subcategories'),
  new CategoryWidget(
      23,
      'Unghii',
      Icon(
        MyFlutterApp.nail_polish,
        color: Colors.blue,
      ),
      Type.Salon,
      'Subcategories'),
];

class CategoryWidget extends StatelessWidget {
  final int id;
  final String title;
  final Icon icon;
  final Type type;
  final String screen;

  CategoryWidget(this.id, this.title, this.icon, this.type, this.screen);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(500),
            color: Colors.white,
          ),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  child: MaterialButton(
                    onPressed: () {
                      type == Type.Cabinet && screen == 'Categories'
                          ? Navigator.of(context).pushNamed(
                              Subcategories.routeName,
                              arguments: mediciSubcategs)
                          : type == Type.Salon && screen == 'Categories'
                              ? Navigator.of(context).pushNamed(
                                  Subcategories.routeName,
                                  arguments: saloaneSubcategs)
                              : Navigator.of(context).pushNamed(
                                  CategoryListScreen.routeName,
                                  arguments: id);
                    },
                    child: IconTheme(
                      data: IconThemeData(
                          color: (() {
                        if (type == Type.Restaurant) {
                          return Colors.black;
                        }
                        if (type == Type.Cafenea) {
                          return Colors.brown;
                        }
                        if (type == Type.Salon) {
                          return Colors.pink;
                        }
                        if (type == Type.Sport) {
                          return Colors.blueAccent;
                        }
                        if (type == Type.Cabinet) {
                          return Colors.redAccent;
                        }
                        if (type == Type.Eveniment) {
                          return Colors.orange;
                        }
                        if (type == Type.Entertaining) {
                          return Colors.purple;
                        }
                        if (type == Type.Cazare) {
                          return Colors.lightBlue;
                        }
                      }())),
                      child: icon,
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
