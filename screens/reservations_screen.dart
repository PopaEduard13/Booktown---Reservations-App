import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';

// import '../utils/user_simple_preferences.dart';
import '../screens/favorites_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/your_reservation_screen.dart';

Widget getStatusofReservation(String status) {
  if (status == 'In asteptare') {
    return Text(
      'Status : $status',
      style: TextStyle(color: Colors.orangeAccent),
    );
  } else if (status == 'Confirmata') {
    return Text(
      'Status : $status',
      style: TextStyle(color: Colors.green),
    );
  } else {
    return Text(
      'Status : $status',
      style: TextStyle(color: Colors.red),
    );
  }
}

Future<void> deleteDocument(DocumentReference ref) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.delete(ref);
  });
  // await FirebaseFirestore.instance
  //     .collection('reservations')
  //     .doc(resId)
  //     .delete();
}

class ReservationsScreen extends StatelessWidget {
  static const routeName = '/reservationsScreen';

  final String _uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Container(
            width: 60,
          )
        ],
        title: Center(
          child: Text(
            'Rezervările tale',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(FontAwesome.heart, color: Colors.red),
          Icon(Icons.home),
          Icon(FlutterIcons.calendar_edit_mco, color: Colors.green),
        ],
        height: 50,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 400),
        index: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoriesScreen(),
              ),
            );
          }
          if (index == 0) {
            Navigator.of(context).pushNamed(FavoritesScreen.routeName);
          }
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("profiles")
            .doc(_uid)
            .collection('reservations')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting ||
              !streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.docs;
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, i) {
                if (documents[i]['email'] ==
                    FirebaseAuth.instance.currentUser.email) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (documents[i]['category'] == 'Restaurante' ||
                                documents[i]['category'] == 'Cafenele') {
                              Navigator.of(context).pushNamed(
                                  YourReservationScreen.routeName,
                                  arguments: YourReservationArguments(
                                      documents[i]['title'],
                                      documents[i]['date'],
                                      documents[i]['time'],
                                      documents[i]['imageUrl'],
                                      documents[i]['numberPeople'],
                                      documents[i]['name']));
                            } else {
                              Navigator.of(context).pushNamed(
                                  YourReservationScreen.routeName,
                                  arguments: YourReservationArguments(
                                      documents[i]['title'],
                                      documents[i]['date'],
                                      documents[i]['time'],
                                      documents[i]['imageUrl'],
                                      documents[i]['service'],
                                      documents[i]['name']));
                            }
                          },
                          child: ListTile(
                            leading: Container(
                              child: Image.network(
                                documents[i]['imageUrl'],
                                fit: BoxFit.fill,
                              ),
                              width: 80,
                              height: 70,
                            ),
                            title: Text(documents[i]['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                documents[i]['category'] == 'Cazari'
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Check-In : ${documents[i]['checkIn']}"),
                                          Text(
                                              "Check-Out: ${documents[i]['checkOut']}"),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text('${documents[i]['date']} ,'),
                                          Text(' ${documents[i]['time']}'),
                                        ],
                                      ),
                                Row(
                                  children: [
                                    documents[i]['category'] == 'Restaurante' ||
                                            documents[i]['category'] ==
                                                'Cafenele' ||
                                            documents[i]['category'] ==
                                                'Evenimente'
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${documents[i]['numberPeople']} persoane'),
                                              getStatusofReservation(
                                                  documents[i]['status'])
                                            ],
                                          )
                                        : Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${documents[i]['service']}'),
                                                getStatusofReservation(
                                                    documents[i]['status'])
                                              ],
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                            dense: false,
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Sterge rezervarea"),
                                    content: Text(
                                        "Ești sigur că vrei să stergi rezervarea aceasta din istoricul tău?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Nu"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteDocument(
                                              documents[i].reference);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Da"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                FontAwesome.trash_o,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  );
                } else
                  return Container();
              },
            ),
          );
        },
      ),
    );
  }
}

class YourReservationArguments {
  final String place;
  final String date;
  final String hour;
  final String imageURL;
  final String nrPersOrService;
  final String contactPerson;

  YourReservationArguments(this.place, this.date, this.hour, this.imageURL,
      this.nrPersOrService, this.contactPerson);
}
