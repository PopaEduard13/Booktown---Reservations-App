import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_complete_guide/models/reservation.dart';
import 'package:flutter_complete_guide/screens/place_details_screen.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/review_widget.dart';
import '../screens/add_review_screen.dart';

Future getReviewsFromGoogle(String place) async {
  var url = Uri(
    scheme: 'https',
    host: 'mybusiness.googleapis.com',
    path: '/v4/{$place=accounts/*/locations/*}/reviews',
  );
  print(await http.get(url));
  // print(await http.get('https://mybusiness.googleapis.com/v4/{parent=accounts/*/locations/*}/reviews'));
}

// Future<List<String>> reservationBefore(String uid) async {
//   List<String> result;
//   await FirebaseFirestore.instance
//       .collection("profiles")
//       .doc(uid)
//       .collection("reservations")
//       .snapshots()
//       .listen((data) {
//     data.docs.forEach((reservation) {
//       String titlu = reservation['title'] as String;
//       result.add(titlu);
//     });
//     return result;
//   });
//   // var docs = await FirebaseFirestore.instance.collection("profiles").doc(uid).collection("reservations").get();
//   // var reservations = docs.docs;

//   // for (int i = 0 ; i < reservations.length ; ++i ) {}
// }

class ReviewsScreen extends StatelessWidget {
  static const routeName = "/ReviewsScreen";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    // final String _uid = FirebaseAuth.instance.currentUser.uid;
    print(getReviewsFromGoogle(args.placeid));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recenziile locatiei",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddReviewScreen.routeName,
                arguments: ScreenArguments(args.placeid, '', args.category, {}),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc('Categories')
            .collection(args.category)
            .doc(args.placeid)
            .collection('reviews')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting ||
              !streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final reviews = streamSnapshot.data.docs;
          print(reviews.length);
          if (reviews.length == 0) {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 500,
                    child: Image(
                      image: AssetImage('assets/noReviewsAvailable.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "Pentru moment nu avem disponibile recenzii pentru aceasta locatie. Fa-ti o rezervare si fii primul care lasa o recenzie!",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (ctx, i) {
                print(reviews[i]['placeId']);
                if (reviews[i]['placeId'] == args.placeid) {
                  return ReviewWidget(
                    nume: reviews[i]['nume'],
                    nota: reviews[i]['nota'],
                    comentariu: reviews[i]['comentariu'],
                    data: reviews[i]['data'],
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}
