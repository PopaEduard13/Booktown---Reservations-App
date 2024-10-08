import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './place_details_screen.dart';

class AddSpecialistReviewScreen extends StatefulWidget {
  const AddSpecialistReviewScreen({Key key}) : super(key: key);

  static const routeName = '/AddSpecialistReviewScreen';

  @override
  State<AddSpecialistReviewScreen> createState() =>
      _AddSpecialistReviewScreenState();
}

class _AddSpecialistReviewScreenState extends State<AddSpecialistReviewScreen> {
  double rating = 0;
  final String _uid = FirebaseAuth.instance.currentUser.uid;

  TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profiles')
              .doc(_uid)
              .snapshots(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting ||
                !profileSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final profile = profileSnapshot.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackButton(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Adauga o recenzie pentru ${args.titlu}",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 17),
                        child: Text(
                          "Nume : ${profile['firstName']} ${profile['lastName']}",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            allowHalfRating: true,
                            initialRating: rating,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                this.rating = rating;
                              });
                            },
                          ),
                          Text("$rating / 5.0"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
                        child: TextFormField(
                          controller: _comment,
                          decoration: InputDecoration(
                            labelText: "Scrie o recenzie..",
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('specialists')
                                  .doc(args.titlu)
                                  .collection('reviews')
                                  .add({
                                'nume':
                                    '${profile['firstName']} ${profile['lastName']}',
                                'nota': rating,
                                'comentariu': _comment.text,
                                'placeId': args.placeid,
                                'data': getDate(),
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Salveaza recenzia",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

String getDate() {
  final List months = [
    'Ianuarie',
    'Februarie',
    'Martie',
    'Aprilie',
    'Mai',
    'Iunie',
    'Iulie',
    'August',
    'Septembrie',
    'Octombrie',
    'Noiembrie',
    'Decembrie'
  ];
  var now = DateTime.now();
  var dayFormatter = new DateFormat('dd');
  String day = dayFormatter.format(now);
  var month = months[now.month - 1];
  var yearFormatter = new DateFormat('yyyy');
  String year = yearFormatter.format(now);
  String date = '$day $month $year';
  print(date);
  return date;
}
