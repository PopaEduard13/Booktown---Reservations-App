import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/screens/place_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  // var formatter = new DateFormat('dd.MM.yyyy');
  // String date = formatter.format(now);
  // return date;
}

class AddReviewScreen extends StatefulWidget {
  static const routeName = '/AddReviewScreen';

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double rating = 0;

  TextEditingController _comment = TextEditingController();

  final String _uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
      backgroundColor: Colors.white,
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
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(_uid)
                  .collection("reservations")
                  .snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting ||
                    !streamSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final reservations = streamSnapshot.data.docs;
                bool prevReservations = false;
                for (var res in reservations) {
                  if (res['title'] == args.placeid) prevReservations = true;
                }
                return prevReservations == true
                    ? SafeArea(
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
                                    "Adauga o recenzie locatiei",
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
                                  padding: const EdgeInsets.only(
                                      left: 5, bottom: 17),
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
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 25.0),
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
                                            .collection("places")
                                            .doc("Categories")
                                            .collection(args.category)
                                            .doc(args.placeid)
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
                      )
                    : SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BackButton(),
                                Text(
                                  "Inapoi",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Center(
                              child: Image.asset(
                                  "assets/ReviewRequiredPicture.jpg"),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Ne pare rau. \n \n Pentru a putea pastra o incredere in recenziile BookTown trebuie sa aveti minim o rezervare in aceasta locatie.",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            );
          }),
    );
  }
}
