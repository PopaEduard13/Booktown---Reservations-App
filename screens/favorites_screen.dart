import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/screens/reservations_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../utils/user_simple_preferences.dart';
import './categories_screen.dart';
import '../utils/day_name.dart';
import '../widgets/place_widget.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/FavoritesScreen';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // List<String> _favs;

  final String _uid = FirebaseAuth.instance.currentUser.uid;

  // @override
  // void initState() {
  //   super.initState();

  //   _favs = UserSimplePreferences.getFavorites() ?? [];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Locațiile tale preferate",
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
            FontAwesome.heart,
            color: Colors.red,
          ),
          Icon(Icons.home),
          Icon(
            FlutterIcons.calendar_edit_mco,
            color: Colors.green,
          ),
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
          if (index == 2) {
            Navigator.of(context).pushNamed(ReservationsScreen.routeName);
          }
        },
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profiles')
              .doc(_uid)
              .collection("favorites")
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting ||
                !streamSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.docs;
            print(documents.length);
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: documents.length,
              itemBuilder: (ctx, i) {
                final tag = 'tag-${documents[i]['imageUrl']}';
                if (documents[i]['category'] == 'Barber' ||
                    documents[i]['category'] == 'Coafor' ||
                    documents[i]['category'] == 'Dentisti' ||
                    documents[i]['category'] == 'Oftalmologi' ||
                    documents[i]['category'] == 'Pediatrii' ||
                    documents[i]['category'] == 'Spa & Relax') {
                  return PlaceWidget(
                    documents[i].id,
                    documents[i]['title'],
                    documents[i]['location'],
                    documents[i]['imageUrl'],
                    documents[i]['category'],
                    documents[i]['program'][getDayByName()]['Open'],
                    documents[i]['program'][getDayByName()]['Close'],
                    {},
                    tag,
                  );
                } else
                  return PlaceWidget(
                    documents[i].id,
                    documents[i]['title'],
                    documents[i]['location'],
                    documents[i]['imageUrl'],
                    documents[i]['category'],
                    documents[i]['program'][getDayByName()]['Open'],
                    documents[i]['program'][getDayByName()]['Close'],
                    documents[i]['timpBlocat'],
                    tag,
                  );
              },
            );
          },
        ),
      ),
    );
  }
}
