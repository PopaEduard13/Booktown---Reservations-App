// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_complete_guide/screens/categories_screen.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// import './categories_screen.dart';

// import '../utils/user_simple_preferences.dart';
// import '../screens/edit_profile_screen.dart';
import '../screens/setup_profile_screen.dart';
// import '../screens/favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _firstName;
  String _lastName;
  String _phone;
  String _email;

  // @override
  // void initState() {
  //   super.initState();

  //   _firstName = UserSimplePreferences.getFirstName() ?? '';
  //   _lastName = UserSimplePreferences.getSecondName() ?? '';
  //   _phone = UserSimplePreferences.getPhone() ?? '';
  //   _email = UserSimplePreferences.getEmail() ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profilul tău',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final profile = snapshot.data;
              _firstName = profile['firstName'];
              _lastName = profile['lastName'];
              _phone = profile['phone'];
              _email = profile['email'];
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40, bottom: 60, left: 25),
                    //   child: Text(
                    //     "Profilul tau",
                    //     style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Center(
                        child: Text(
                          'Salut $_lastName :)',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListTile(
                          leading: Text(
                            'Nume :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(_firstName),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SetupProfileScreen.routeName,
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListTile(
                          leading: Text(
                            'Prenume :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(_lastName),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SetupProfileScreen.routeName,
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListTile(
                          leading: Text(
                            'Telefon :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(_phone),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SetupProfileScreen.routeName,
                              );
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListTile(
                        leading: Text(
                          'Email :',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(_email),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
