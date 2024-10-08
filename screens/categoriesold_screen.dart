import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../models/category.dart';
// import '../models/profile.dart';
// import '../providers/profiles.dart';
import '../widgets/category_widget.dart';
import '../widgets/main_drawer.dart';
import '../widgets/search_widget.dart';
import './reservations_screen.dart';
import './setup_profile_screen.dart';
import './profile_screen.dart';
import '../screens/favorites_screen.dart';
// import '../utils/user_simple_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/CategoriesScreen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // final mediciSub = ['Dentiști']
  @override
  Widget build(BuildContext context) {
    // final existingProfile = FirebaseFirestore.instance.collection('profiles').doc(GoogleSignIn(scopes: ['email']).currentUser.id).get();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final profile = Provider.of<PersonProfile>(context).profile;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(FontAwesome.heart, color: Colors.red),
            Icon(Icons.home),
            Icon(
              FlutterIcons.calendar_edit_mco,
              color: Colors.green,
            ),
          ],
          height: 50,
          backgroundColor: Theme.of(context).primaryColor,
          animationDuration: Duration(milliseconds: 400),
          index: 1,
          onTap: (index) {
            if (index == 2) {
              Navigator.of(context).pushReplacementNamed(ReservationsScreen.routeName);
            }
            if (index == 0) {
              Navigator.of(context).pushReplacementNamed(FavoritesScreen.routeName);
            }
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        drawer: MainDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (ctx) => IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "BookTown momentan funcționează doar în Constanța!"),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(FlutterIcons.location_pin_sli),
                          Container(
                            child: TextButton(
                              child: Text(
                                'Constanța 🌊',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "BookTown momentan funcționează doar în Constanța!"),
                                  ),
                                );
                              },
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(FlutterIcons.location_pin_sli),
                    //     Container(
                    //       child: TextButton(
                    //         child: Text(
                    //           'Constanta',
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //       alignment: Alignment.center,
                    //     ),
                    //   ],
                    // ),
                    IconButton(
                      icon: Icon(Icons.person_outline,
                          size: 35, color: Colors.black),
                      onPressed: () {
                        // ignore: unrelated_type_equality_checks
                        FirebaseAuth.instance.currentUser.displayName != ''
                                // existingProfile != null
                            ? Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName)
                            : Navigator.of(context).pushNamed(
                                SetupProfileScreen.routeName,
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchWidget(),
                );
              },
              child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Caută locația dorită ...",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 300,
                height: 40,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Categories_above.map(
                    (catData) => CategoryWidget(
                      catData.id,
                      catData.title,
                      catData.icon,
                      catData.type,
                      'Categories'
                    ),
                  ).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: Image(
                    image: AssetImage('assets/logo scurtat.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: Categories_under.map(
                  (catData) => CategoryWidget(
                    catData.id,
                    catData.title,
                    catData.icon,
                    catData.type,
                    'Categories'
                  ),
                ).toList(),
              ),
            ),
            Container(
              height: 60,
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
