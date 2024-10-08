import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/place_widget.dart';
import '../models/category.dart';
import './category_favorites_screen.dart';
import '../widgets/search_widget.dart';
import '../utils/day_name.dart';

class CategoryListScreen extends StatefulWidget {
  static const routeName = '/CategoryListScreen';

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  String imageUrlStorage;
  final storage = FirebaseStorage.instance;
  void initState() {
    super.initState();

    imageUrlStorage = '';

    // getImageUrlStorage();
  }

  // Future<void> getImagesUrlsStorage() async {
  //   Map<String, String> imagesUrlsStorage;
  //   // Am nevoie sa iau toate pozele intr-un map unde am <numele locatiei , url-ul de download>
  //   // ca apoi sa le afisez in functie de numele locatiei care este pe pozitia i din bucla builder
  // }

  Future<void> getImageUrlStorage(String name) async {
    final ref = storage.ref().child('$name.jpeg');

    print(ref.name);
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrlStorage = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    final catId = ModalRoute.of(context).settings.arguments as int;
    final category = categories.firstWhere((categ) => categ.id == catId);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        leading: BackButton(
          color: Colors.black54,
        ),
        title: Row(
          children: [
            Text(
              category.title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesome.heart,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      CategoryFavoritesScreen.routeName,
                      arguments: category,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CategorySearchWidget(categ: category.title),
                    );
                  },
                )
              ],
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("places")
              .doc("Categories")
              .collection("${category.title}")
              .orderBy('rating', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting ||
                !streamSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.docs;

            // final documents = {};

            // for (int i = 0; i < documents.length; ++i) {
            //   sortedPlaces[i] = documents[i];
            // }
            // for (int i = 0; i < documents.length; ++i) {
            //   if (sortedPlaces[i + 1]['rating'] as double > sortedPlaces[i]['rating'] as double) {
            //     sortedPlaces[i] = sortedPlaces[i + 1];
            //     sortedPlaces[i + 1] = documents[i];
            //   }
            // }

            return ListView.builder(
                itemCount: documents.length,
                cacheExtent: 400.00 * documents.length,
                // ignore: missing_return
                itemBuilder: (ctx, i) {
                  final tag = 'tag-${documents[i]['imageUrl']}';
                  // await getImageUrlStorage(documents[i]['title']);
                  if (documents[i]['category'] == 'Barber' ||
                      documents[i]['category'] == 'Coafor' ||
                      documents[i]['category'] == 'Dentisti' ||
                      documents[i]['category'] == 'Oftalmologi' ||
                      documents[i]['category'] == 'Pediatrii' ||
                      documents[i]['category'] == 'Spa & Relax') {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: PlaceWidget(
                        documents[i].id,
                        documents[i]['title'],
                        documents[i]['location'],
                        documents[i]['imageUrl'],
                        documents[i]['category'],
                        documents[i]['program'][getDayByName()]['Open'],
                        documents[i]['program'][getDayByName()]['Close'],
                        {},
                        tag,
                      ),
                    );
                  } else
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: PlaceWidget(
                        documents[i].id,
                        documents[i]['title'],
                        documents[i]['location'],
                        documents[i]['imageUrl'],
                        documents[i]['category'],
                        documents[i]['program'][getDayByName()]['Open'],
                        documents[i]['program'][getDayByName()]['Close'],
                        documents[i]['timpBlocat'],
                        tag,
                      ),
                    );
                  // while (imageUrlStorage.isNotEmpty) {
                  // return Container(
                  //     padding: EdgeInsets.all(8),
                  //     child: PlaceWidget(
                  //       documents[i].id,
                  //       documents[i]['title'],
                  //       documents[i]['location'],
                  //       documents[i]['imageUrl'],
                  //       documents[i]['category'],
                  //       documents[i]['program'][getDayByName()]['Open'],
                  //       documents[i]['program'][getDayByName()]['Close'],
                  //       tag,
                  //     ));
                  //   );
                  // }
                  // return Container();
                });
          },
        ),
      ),
    );
  }
}
