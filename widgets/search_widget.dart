import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './place_widget.dart';
import '../utils/day_name.dart';

class SearchWidget extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    //   return StreamBuilder(
    //       stream: FirebaseFirestore.instance.collection("places").snapshots(),
    //       builder: (context, streamSnapshot) {
    //         if (streamSnapshot.connectionState == ConnectionState.waiting ||
    //             !streamSnapshot.hasData) {
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //         final documents = streamSnapshot.data.docs;
    //         final day = getDayByName();
    //         return ListView.builder(
    //           padding: const EdgeInsets.all(8),
    //           itemCount: documents.length,
    //           itemBuilder: (BuildContext context, int i) {
    //             return PlaceWidget(
    //               documents[i].id,
    //               documents[i]['title'],
    //               documents[i]['location'],
    //               documents[i]['imageUrl'],
    //               documents[i]['category'],
    //               documents[i]['program'][day]['Open'],
    //               documents[i]['program'][day]['Close'],
    //             );
    //           },
    //         );
    //       });
    // }
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("searchPlaces").snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting ||
            !streamSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = streamSnapshot.data.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int i) {
            final tag = 'tag-${documents[i].id}';
            final day = getDayByName();
            if (documents[i]['title'].toLowerCase().startsWith(query) ||
                documents[i]['title'].startsWith(query) ||
                documents[i]['title'].toUpperCase().startsWith(query))
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('places')
                      .doc('Categories')
                      .collection(documents[i]['category'])
                      .doc(documents[i]['title'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final place = snapshot.data;
                    if (place['category'] == 'Barber' ||
                        place['category'] == 'Coafor' ||
                        place['category'] == 'Dentisti' ||
                        place['category'] == 'Oftalmologi' ||
                        place['category'] == 'Pediatrii' ||
                        place['category'] == 'Spa & Relax') {
                      return PlaceWidget(
                        place.id,
                        place['title'],
                        place['location'],
                        place['imageUrl'],
                        place['category'],
                        place['program'][day]['Open'],
                        place['program'][day]['Close'],
                        {},
                        tag,
                      );
                    }
                    return PlaceWidget(
                      place.id,
                      place['title'],
                      place['location'],
                      place['imageUrl'],
                      place['category'],
                      place['program'][day]['Open'],
                      place['program'][day]['Close'],
                      place['timpBlocat'],
                      tag,
                    );
                  });
            else
              return Container();
          },
        );
      },
    );
  }
}

class CategorySearchWidget extends SearchDelegate<String> {
  final String categ;

  CategorySearchWidget({this.categ});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection("places").snapshots(),
    //     builder: (context, streamSnapshot) {
    //       if (streamSnapshot.connectionState == ConnectionState.waiting ||
    //           !streamSnapshot.hasData) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       final documents = streamSnapshot.data.docs;
    //       return ListView.builder(
    //         padding: const EdgeInsets.all(8),
    //         itemCount: documents.length,
    //         itemBuilder: (BuildContext context, int i) {
    //           final day = getDayByName();
    //           if (documents[i]['category'] == categ) {
    //             return PlaceWidget(
    //               documents[i].id,
    //               documents[i]['title'],
    //               documents[i]['location'],
    //               documents[i]['imageUrl'],
    //               documents[i]['category'],
    //               documents[i]['program'][day]['Open'],
    //               documents[i]['program'][day]['Close'],
    //             );
    //           } else {
    //             return Container();
    //           }
    //         },
    //       );
    //     });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("places")
          .doc('Categories')
          .collection(categ)
          .snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting ||
            !streamSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = streamSnapshot.data.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int i) {
            final tag = 'tag-${documents[i]['imageUrl']}';
            final day = getDayByName();
            if (((documents[i]['title'].toLowerCase().startsWith(query) ||
                        documents[i]['title'].startsWith(query) ||
                        documents[i]['title']
                            .toUpperCase()
                            .startsWith(query)) ||
                    (documents[i]['title'].toLowerCase().contains(query) ||
                        documents[i]['title'].contains(query) ||
                        documents[i]['title'].toUpperCase().contains(query))) &&
                documents[i]['category'] ==
                    categ) if (documents[i]['category'] == 'Barber' ||
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
                documents[i]['program'][day]['Open'],
                documents[i]['program'][day]['Close'],
                documents[i]['timpBlocat'],
                tag,
              );
            } else
              return PlaceWidget(
                documents[i].id,
                documents[i]['title'],
                documents[i]['location'],
                documents[i]['imageUrl'],
                documents[i]['category'],
                documents[i]['program'][day]['Open'],
                documents[i]['program'][day]['Close'],
                {},
                tag,
              );
            // return PlaceWidget(
            //   documents[i].id,
            //   documents[i]['title'],
            //   documents[i]['location'],
            //   documents[i]['imageUrl'],
            //   documents[i]['category'],
            //   documents[i]['program'][day]['Open'],
            //   documents[i]['program'][day]['Close'],
            //   tag,
            // );
            else
              return Container();
          },
        );
      },
    );
  }
}
