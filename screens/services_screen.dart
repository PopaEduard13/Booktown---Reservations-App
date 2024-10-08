import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../widgets/service_widget.dart';
import '../screens/place_details_screen.dart';
import '../utils/stars_system.dart';
import '../screens/specialists_screen.dart';

class ServicesScreen extends StatelessWidget {
  static const routeName = "/ServicesScreen";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor,
        title: args.category == "Sport & Fun"
            ? Text(
                'Selecteaza activitatea',
                style: TextStyle(color: Colors.black),
              )
            : Text(
                "Selecteaza serviciul",
                style: TextStyle(color: Colors.black),
              ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc("Categories")
            .collection('${args.category}')
            .doc(args.placeid)
            .collection("specialisti")
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting ||
              !streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final document = streamSnapshot.data.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: document.length,
            itemBuilder: (ctx, i) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('specialists')
                      .doc(document[i]['nume'])
                      .collection('reviews')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final specialistReviews = snapshot.data.docs;
                    List<double> reviewsStars = [];

                    for (int i = 0; i < specialistReviews.length; ++i) {
                      final double x = specialistReviews[i]['nota'] as double;
                      reviewsStars.add(x);
                    }
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("places")
                            .doc("Categories")
                            .collection(args.category)
                            .doc(args.placeid)
                            .collection("specialisti")
                            .doc(document[i]['nume'])
                            .collection("servicii")
                            .snapshots(),
                        builder: (context, snapshotServicii) {
                          if (snapshotServicii.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshotServicii.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final servicii = snapshotServicii.data.docs;

                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: SizedBox(
                                                    height: 70,
                                                    width: 70,
                                                    child: ClipOval(
                                                        child: Image.network(
                                                            document[i][
                                                                'profileUrl'])),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                              SpecialistScreen
                                                                  .routeName,
                                                              arguments: ScreenArguments(
                                                                  args.placeid,
                                                                  document[i]
                                                                      ['nume'],
                                                                  args.category,
                                                                  {}),
                                                            );
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    200,
                                                                child: Text(
                                                                  "${document[i]["nume"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        23,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    reviewsStars.length >
                                                                            0
                                                                        ? '${getRating(reviewsStars)}'
                                                                        : "0.0",
                                                                  ),
                                                                  RatingBarIndicator(
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    rating: reviewsStars.length >
                                                                            0
                                                                        ? getRatingAsDouble(
                                                                            reviewsStars)
                                                                        : 0.0,
                                                                    itemSize:
                                                                        20,
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: servicii.length,
                                        itemBuilder: (ctx, j) {
                                          return ServiceWidget(
                                            args.placeid,
                                            servicii[j]['serviciu'] as String,
                                            servicii[j]['pret'] as int,
                                            args.category,
                                            document[i]['nume'] as String,
                                            servicii[j]['durata'] as String,
                                            document[i]['timpBlocat']
                                                as Map<String, dynamic>,
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  // ServiceWidget(
                                  //   args.placeid,
                                  //   document['servicii'][i]['serviciu'] as String,
                                  //   document['servicii'][i]['pret'] as int,
                                  //   args.titlu);
                                ),
                                Divider(
                                  height: 20,
                                )
                              ],
                            ),
                          );
                        });
                  });
            },
          );
        },
      ),
    );
  }
}
