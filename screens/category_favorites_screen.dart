import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/place_widget.dart';
import '../utils/user_simple_preferences.dart';
import '../models/category.dart';
import '../utils/day_name.dart';

class CategoryFavoritesScreen extends StatefulWidget {
  static const routeName = '/CategoryFavoritesScreen';

  @override
  State<CategoryFavoritesScreen> createState() =>
      _CategoryFavoritesScreenState();
}

class _CategoryFavoritesScreenState extends State<CategoryFavoritesScreen> {
  // List<String> _favs;

  // @override
  // void initState() {
  //   super.initState();

  //   _favs = UserSimplePreferences.getFavorites() ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    final categ = ModalRoute.of(context).settings.arguments as Category;
    final _uid = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "${categ.title} preferate",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        actions: [
          Container(
            width: 60,
          ),
        ],
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).primaryColor,
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

                if (documents[i]['category'] == categ.title) {
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
                  return Container();
              },
            );
          },
        ),
      ),
    );
  }
}
