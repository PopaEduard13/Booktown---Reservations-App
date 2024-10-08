import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_complete_guide/widgets/place_widget.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/program_widget.dart';
import '../screens/reviews_screen.dart';
import '../screens/gallery_screen.dart';
import '../utils/day_name.dart';
import '../screens/setup_profile_screen.dart';
import '../utils/stars_system.dart';
import '../screens/reservation_screen.dart';
import '../screens/menu_screen.dart';
// import '../utils/user_simple_preferences.dart';
import '../widgets/service_widget.dart';
import '../screens/services_screen.dart';
import '../screens/reservations_screen.dart';

class PlaceDetailsScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailsScreen';

  // final String place;
  // final String category;

  // PlaceDetailsScreen(this.place , this.category);
  // const PlaceDetailsScreen({Key key, }) : super(key: key);

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Arguments;

    final String _uid = FirebaseAuth.instance.currentUser.uid;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Theme.of(context).primaryColor,
          ),
        ),
        floatingActionButton: args.category == 'Restaurante' ||
                args.category == 'Cafenele'
            ? FloatingActionButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser.displayName == '' ||
                          FirebaseAuth.instance.currentUser.displayName == null
                      ? Navigator.of(context).pushNamed(
                          SetupProfileScreen.routeName,
                          arguments: ReservationArguments(args.placeId, '',
                              args.category, '', '', args.timpBlocat))
                      : Navigator.of(context).pushNamed(
                          ReservationScreen.routeName,
                          arguments: ReservationArguments(args.placeId, '',
                              args.category, '', '', args.timpBlocat));
                },
                child: Text(
                  'Rezerva',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                backgroundColor: Colors.blue,
              )
            : null,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('places')
              .doc("Categories")
              .collection(args.category)
              .doc('${args.placeId}')
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting ||
                !streamSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = streamSnapshot.data;
            final tag = 'tag-${document['imageUrl']}';
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('places')
                  .doc('Categories')
                  .collection(args.category)
                  .doc(args.placeId)
                  .collection("reviews")
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
                  print("${reviews[i]['nota']}///");
                  reviewsStars.add(reviews[i]['nota']);
                }
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("profiles")
                        .doc(_uid)
                        .collection("favorites")
                        .snapshots(),
                    builder: (context, favSnapshot) {
                      if (favSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          !favSnapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final favorites = favSnapshot.data.docs;
                      bool isFav = false;
                      DocumentReference favReference;
                      for (var fav in favorites) {
                        if (fav['title'] == args.placeId) {
                          isFav = true;
                          favReference = fav.reference;
                        }
                      }
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Hero(
                                tag: "$tag+poza",
                                child: Image.network(
                                  args.imageUrl,
                                  height: 300,
                                  width: 500,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 20,
                                    bottom: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        document.get('title'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (isFav == true) {
                                            deleteDocument(favReference);
                                          } else {
                                            if (document
                                                        .get('category') ==
                                                    'Barber' ||
                                                document.get('category') ==
                                                    'Coafor' ||
                                                document.get('category') ==
                                                    'Dentisti' ||
                                                document.get('category') ==
                                                    'Oftalmologi' ||
                                                document.get('category') ==
                                                    'Pediatrii' ||
                                                document.get('category') ==
                                                    'Spa & Relax') {
                                              FirebaseFirestore.instance
                                                  .collection("profiles")
                                                  .doc(_uid)
                                                  .collection("favorites")
                                                  .add({
                                                "title": document.get('title'),
                                                "category":
                                                    document.get('category'),
                                                "imageUrl":
                                                    document.get('imageUrl'),
                                                "location":
                                                    document.get('location'),
                                                "program":
                                                    document.get('program'),
                                                "timpBlocat": {},
                                              });
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection("profiles")
                                                  .doc(_uid)
                                                  .collection("favorites")
                                                  .add({
                                                "title": document.get('title'),
                                                "category":
                                                    document.get('category'),
                                                "imageUrl":
                                                    document.get('imageUrl'),
                                                "location":
                                                    document.get('location'),
                                                "program":
                                                    document.get('program'),
                                                "timpBlocat":
                                                    document.get('timpBlocat')
                                              });
                                            }
                                          }
                                        },
                                        icon: isFav == true
                                            ? Icon(FontAwesome.heart)
                                            : Icon(FontAwesome.heart_o),
                                        color: isFav == true
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  child: Text(
                                    document.get('description'),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 10),
                                  child: Row(
                                    children: [
                                      document.get('category') == 'Evenimente'
                                          ? Container()
                                          : Row(
                                              children: [
                                                Icon(Icons.timelapse),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                openClosedLocation(
                                                            document.get(
                                                                        'program')[
                                                                    getDayByName()]
                                                                ['Open'],
                                                            document.get(
                                                                        'program')[
                                                                    getDayByName()]
                                                                ['Close']) ==
                                                        'Deschis'
                                                    ? Text(
                                                        'OPEN',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                    : Text(
                                                        'CLOSED',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                      document.get('category') == 'Evenimente'
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    reviewsStars.length > 0
                                                        ? '${getRating(reviewsStars)}'
                                                        : "0.0",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.star,
                                                    size: 15,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "(${reviewsStars.length})",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blueGrey),
                                                  )
                                                ],
                                              ),
                                            ),
                                      document.get('category') == 'Evenimente'
                                          ? Container()
                                          : Expanded(
                                              child: SizedBox(),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, left: 10, right: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              size: 15,
                                              color: Colors.blue,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                  GalleryScreen.routeName,
                                                  arguments: args.placeId,
                                                );
                                              },
                                              child: Text(
                                                'Galerie foto',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Icon(Icons.place),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document.get('location')),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.call),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document.get('phone')),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    document.get('category') == 'Restaurante' ||
                                            document.get('category') ==
                                                'Cafenele'
                                        ? Navigator.of(context).pushNamed(
                                            MenuScreen.routeName,
                                            arguments: MenuArguments(
                                                args.placeId, args.category),
                                          )
                                        : Navigator.of(context).pushNamed(
                                            ServicesScreen.routeName,
                                            arguments: ScreenArguments(
                                                args.placeId,
                                                'Servicii',
                                                args.category, {}),
                                          );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.grey,
                                        //       spreadRadius: 3,
                                        //       blurRadius: 3)
                                        // ],
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.grey.shade200),
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 15, bottom: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          document.get('category') ==
                                                      'Restaurante' ||
                                                  document
                                                          .get('category') ==
                                                      'Cafenele'
                                              ? Icons.menu_book_outlined
                                              : document.get('category') ==
                                                          'Saloane' ||
                                                      document
                                                              .get(
                                                                  'category') ==
                                                          'Sport' ||
                                                      document.get(
                                                              'category') ==
                                                          'Cabinete' ||
                                                      document.get(
                                                              'category') ==
                                                          'Entertaining'
                                                  ? Icons.list
                                                  : document.get('category') ==
                                                          'Cazari'
                                                      ? Icons.bed_rounded
                                                      : Icons.list,
                                          size: 34,
                                        ),
                                        SizedBox(width: 14),
                                        Text(
                                          document.get('category') ==
                                                      'Restaurante' ||
                                                  document.get('category') ==
                                                      'Cafenele'
                                              ? 'Meniu'
                                              : document.get('category') ==
                                                      'Cazari'
                                                  ? 'Oferte cazare'
                                                  : document.get('category') ==
                                                              'Evenimente' ||
                                                          document.get(
                                                                  'category') ==
                                                              'Sport & Fun'
                                                      ? 'Oferte'
                                                      : 'Servicii',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_right_outlined)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                document.get('category') == 'Evenimente'
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ReviewsScreen.routeName,
                                              arguments: ScreenArguments(
                                                  args.placeId,
                                                  '',
                                                  args.category, {}));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //       color: Colors.grey,
                                              //       spreadRadius: 3,
                                              //       blurRadius: 3)
                                              // ],
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color: Colors.grey.shade200),
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 15, bottom: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.chat_bubble_outline,
                                                size: 34,
                                              ),
                                              SizedBox(width: 14),
                                              Text(
                                                'Recenzii',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                              Icon(Icons.arrow_right_outlined)
                                            ],
                                          ),
                                        ),
                                      ),
                                document.get('category') == 'Evenimente'
                                    ? Container()
                                    : SizedBox(
                                        height: 10,
                                      ),
                                InkWell(
                                  onTap: () {
                                    MapsLauncher.launchQuery(
                                        '${document['title']} Constanta');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.grey,
                                        //       spreadRadius: 3,
                                        //       blurRadius: 3)
                                        // ],
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.grey.shade200),
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 15, bottom: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          size: 34,
                                        ),
                                        SizedBox(width: 14),
                                        Text(
                                          'Locație',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_right_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Container(
                                //   padding: const EdgeInsets.all(15),
                                //   child: Column(children: [
                                //     Row(
                                //       children: [
                                //         Icon(Icons.info_rounded),
                                //         Text("Facilitati"),
                                //       ],
                                //     ),
                                //     // FacilitiesWidget(place),-
                                //   ]),
                                // ),
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    width: 250,
                                    child:
                                        document.get('category') == 'Evenimente'
                                            ? ProgramWidget(
                                                document.get('program'), true)
                                            : ProgramWidget(
                                                document.get('program'), false))
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String placeid;
  final String titlu;
  final String category;
  final Map<String, dynamic> timpBlocat;

  ScreenArguments(this.placeid, this.titlu, this.category, this.timpBlocat);
}

String openClosedLocation(String openingHour, String closingHour) {
  if (openingHour == "Inchis") {
    return openingHour;
  } else {
    final DateTime hour = DateTime.now();
    final DateTime openHour = DateFormat('Hm').parse(openingHour);
    if (closingHour == '00:00') {
      closingHour = '23:59';
    }
    final DateTime closeHour = DateFormat('Hm').parse(closingHour);

    if (hour.hour > openHour.hour && hour.hour < closeHour.hour ||
        hour.hour == closeHour.hour && hour.minute < closeHour.minute ||
        hour.hour == openHour.hour && hour.minute >= openHour.minute) {
      return 'Deschis';
    } else {
      return 'Inchis';
    }
  }
}
