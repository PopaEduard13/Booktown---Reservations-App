import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/category_widget.dart';

class Subcategories extends StatelessWidget {
  const Subcategories({Key key}) : super(key: key);
  static const routeName = '/Subcategories';

  @override
  Widget build(BuildContext context) {
    final subcategs =
        ModalRoute.of(context).settings.arguments as List<CategoryWidget>;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: subcategs
                      .map((subcateg) => CategoryWidget(
                            subcateg.id,
                            subcateg.title,
                            subcateg.icon,
                            subcateg.type,
                            subcateg.screen,
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
