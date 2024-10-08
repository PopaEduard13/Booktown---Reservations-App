import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/my_flutter_app_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import '../models/type_enum.dart';

import '../screens/subcategories_screen.dart';
import '../screens/category_list_screen.dart';
// import '../utils/user_simple_preferences.dart';

final mediciSubcategs = [
  new CategoryWidget(10, 'Dentisti', Icon(MaterialCommunityIcons.tooth),
      Type.Cabinet, 'Subcategories'),
  new CategoryWidget(
      11, 'Pediatrii', Icon(FontAwesome.child), Type.Cabinet, 'Subcategories'),
  new CategoryWidget(
      12, 'Oftalmologi', Icon(FontAwesome.eye), Type.Cabinet, 'Subcategories'),
  // new CategoryWidget(13, 'Clinici', Icon(FontAwesome.hospital_o), Type.Cabinet,
  //     'Subcategories')
];

final saloaneSubcategs = [
  new CategoryWidget(
      20,
      'Barber',
      Icon(
        MyFlutterApp.barber,
      ),
      Type.Salon,
      'Subcategories'),
  new CategoryWidget(
      21,
      'Coafor',
      Icon(
        MyFlutterApp.makeover,
      ),
      Type.Salon,
      'Subcategories'),
  new CategoryWidget(
      22,
      'Spa & Relax',
      Icon(
        MyFlutterApp.massage,
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
        type == Type.Sport
            ? SizedBox(
                height: 50,
              )
            : Container(),
        Container(
          // color: Theme.of(context).primaryColor,
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
                        color: Colors.white,
                        //     color: (() {
                        //   if (type == Type.Restaurant) {
                        //     return Colors.black;
                        //   }
                        //   if (type == Type.Cafenea) {
                        //     return Colors.brown;
                        //   }
                        //   if (type == Type.Salon) {
                        //     return Colors.pink;
                        //   }
                        //   if (type == Type.Sport) {
                        //     return Colors.blueAccent;
                        //   }
                        //   if (type == Type.Cabinet) {
                        //     return Colors.redAccent;
                        //   }
                        //   if (type == Type.Eveniment) {
                        //     return Colors.orange;
                        //   }
                        //   if (type == Type.Entertaining) {
                        //     return Colors.purple;
                        //   }
                        //   if (type == Type.Cazare) {
                        //     return Colors.lightBlue;
                        //   }
                        // }()),
                        size: 27),
                    child: icon,
                  ),
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
                  }()),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(17),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        type == Type.Cafenea
            ? SizedBox(
                height: 50,
              )
            : Container(),
      ],
    );
  }
}
