import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screens/account_screen.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profile_screen.dart';
import '../utils/authentication_service.dart';
import '../screens/reservations_screen.dart';
import '../screens/setup_profile_screen.dart';
// import '../utils/user_simple_preferences.dart';
import '../screens/contact_screen.dart';

class MainDrawer extends StatelessWidget {
  // final _googleSignIn = GoogleSignIn(scopes: ['email']);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            Container(
              height: 100,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 135,
                      child: Image(
                        image: AssetImage('assets/Logo fara background.png'),
                      ),
                    ),
                    Text(
                      'v1.0',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Profilul tău',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                _auth.currentUser.displayName == '' ||
                        _auth.currentUser.displayName == null
                    // ignore: unnecessary_statements
                    ? {
                        Navigator.pop(context),
                        Navigator.of(context).pushNamed(
                          SetupProfileScreen.routeName,
                        ),
                      }
                    : Navigator.of(context).pushNamed(ProfileScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Rezervările tale',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ReservationsScreen.routeName);
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings, color: Colors.black),
            //   title: Text(
            //     'Settings',
            //     style: TextStyle(color: Colors.black),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pushNamed(SettingsScreen.routeName);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.call, color: Theme.of(context).primaryColor),
              title: Text(
                'Contact',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(ContactScreen.routeName);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.person_off, color: Theme.of(context).primaryColor),
              title: Text(
                'Deconectează-te',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Decontectează-te"),
                    content: Text(
                        "Ești sigur că vrei să te deconectezi de la contul tău?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Nu"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context)
                              .pushReplacementNamed(AccountScreen.routeName);
                          context.read<AuthenticationService>().signOut();
                          // await _googleSignIn.signOut();
                        },
                        child: Text("Da"),
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  color: Theme.of(context).primaryColor),
              title: Text(
                'Ieșire',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.exit_to_app, color: Colors.black),
            //   title: Text(
            //     'User Details',
            //     style: TextStyle(color: Colors.black),
            //   ),
            //   onTap: () {

            //     // print(GoogleSignIn(scopes: ['email']).currentUser.email);
            //     // print(FirebaseAuth.instance.currentUser.displayName);
            //     print(FirebaseAuth.instance.currentUser.email);
            //     // print(FirebaseAuth.instance.currentUser.phoneNumber);
            //   },
            // ),
            // SizedBox(
            //   height: 25,
            // ),
            // ListTile(
            //     leading: Icon(Icons.exit_to_app, color: Colors.black),
            //     title: Text(
            //       'clear displayname',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     onTap: () {
            //       FirebaseAuth.instance.currentUser.updateDisplayName('');
            //     }),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Termeni si Condiții',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  child: Text(
                    'FAQ',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Bine ai venit în Constanța! 🌊',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
