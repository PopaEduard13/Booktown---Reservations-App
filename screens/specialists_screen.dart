import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/review_widget.dart';
import '../utils/stars_system.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './place_details_screen.dart';
import './add_specialist_review_screen.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({Key key}) : super(key: key);
  static const routeName = '/specialistScreen';

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('specialists')
              .doc(args.titlu)
              .collection('reviews')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final reviews = snapshot.data.docs;
            List<double> reviewsStars = [];

            for (int i = 0; i < reviews.length; ++i) {
              final double x = reviews[i]['nota'] as double;
              reviewsStars.add(x);
            }
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('specialists')
                    .doc(args.titlu)
                    .snapshots(),
                builder: (context, reviewsSnapshot) {
                  if (reviewsSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      !reviewsSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final specialist = reviewsSnapshot.data;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: SizedBox(
                                  // height: 150,
                                  // width: 150,
                                  child: ClipOval(
                                      child: Image.network(
                                          specialist['imageUrl'])),
                                ),
                                maxRadius: 40,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  specialist['name'],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(specialist['location']),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Galerie",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height -
                                  (MediaQuery.of(context).size.height / 1.4),
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: specialist['gallery'].length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Image.network(
                                            specialist['gallery'][i]));
                                  }),
                            ),
                          ],
                        ),
                        Divider(),
                        Container(
                          child: Center(
                            child: Text(
                              "Recenzii",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                reviewsStars.length > 0
                                    ? '${getRating(reviewsStars)}'
                                    : "0.0",
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                            ),
                            RatingBarIndicator(
                                itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                rating: reviewsStars.length > 0
                                    ? getRatingAsDouble(reviewsStars)
                                    : 0.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AddSpecialistReviewScreen.routeName,
                                      arguments: ScreenArguments(
                                          args.placeid,
                                          specialist['name'],
                                          args.category, {}));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text("Adauga recenzie"),
                                  ],
                                )),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (ctx, i) {
                              return Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: ReviewWidget(
                                  nume: reviews[i]['nume'],
                                  nota: reviews[i]['nota'],
                                  data: reviews[i]['data'],
                                  comentariu: reviews[i]['comentariu'],
                                ),
                              );
                            })
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
