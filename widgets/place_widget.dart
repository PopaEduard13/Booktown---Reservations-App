import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/place_details_screen.dart';
import '../utils/stars_system.dart';

// ignore: must_be_immutable

class PlaceWidget extends StatelessWidget {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final String category;
  final String openingHour;
  final String closingHour;
  final Map<String, dynamic> timpBlocat;
  final String tag;

  PlaceWidget(this.id, this.title, this.location, this.imageUrl, this.category,
      this.openingHour, this.closingHour, this.timpBlocat, this.tag);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc('Categories')
            .collection(category)
            .doc(title)
            .collection('reviews')
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting ||
              !streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.docs;
          List<double> reviewsStars = [];

          for (int i = 0; i < documents.length; ++i) {
            if (documents[i]['placeId'] == title) {
              reviewsStars.add(documents[i]['nota']);
            }
          }
          return Column(
            children: [
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: InkWell(
                  // onTap: () =>  ,
                  onTap: () => Navigator.of(context).pushNamed(
                    PlaceDetailsScreen.routeName,
                    arguments: Arguments(title, category, imageUrl, timpBlocat),
                  ),

                  child: Container(
                    height: 200,
                    width: 380,
                    child: Hero(
                      tag: "$tag+poza",
                      child: Image.network(imageUrl, fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: Image.asset(
                              "assets/Loading Image.png",
                              fit: BoxFit.cover,
                              width: 800,
                              height: 400,
                            ),
                          );
                        }
                        // loadingProgress == null ? return child : return Image.asset("Loading Image.png");
                      }),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.grey.shade300,
                ),
                height: 50,
                width: 380,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                              softWrap: true,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.blueGrey,
                                size: 12,
                              ),
                              Text(
                                location,
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            reviewsStars.length > 0
                                ? '${getRating(reviewsStars)}'
                                : "0.0",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "(${reviewsStars.length})",
                            style:
                                TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                          SizedBox(width: 15),
                          category == 'Evenimente' ||
                                  category == 'Sport' ||
                                  category == 'Cazari'
                              ? Container()
                              : openClosedLocation(openingHour, closingHour) ==
                                      'Deschis'
                                  ? Text(
                                      'OPEN',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Text(
                                      'CLOSED',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}

class Arguments {
  String placeId;
  String category;
  String imageUrl;
  Map<String, dynamic> timpBlocat;

  Arguments(this.placeId, this.category, this.imageUrl, this.timpBlocat);
}
