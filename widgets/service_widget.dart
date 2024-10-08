import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/reservation_screen.dart';
import '../screens/specialist_reservation_screen.dart';
// import '../utils/user_simple_preferences.dart';
import '../screens/setup_profile_screen.dart';

class ServiceWidget extends StatelessWidget {
  final String placeId;
  final String service;
  final int price;
  final String category;
  final String specialist;
  final String durataServiciu;
  final Map<String, dynamic> timpBlocat;

  ServiceWidget(this.placeId, this.service, this.price, this.category,
      this.specialist, this.durataServiciu, this.timpBlocat);

  final _name = FirebaseAuth.instance.currentUser.displayName;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _name == null || _name == ''
            ? Navigator.of(context).pushNamed(
                SetupProfileScreen.routeName,
                arguments: ReservationArguments(placeId, service, category,
                    specialist, durataServiciu, timpBlocat),
              )
            : specialist != ''
                ? Navigator.of(context).pushNamed(
                    SpecialistReservationScreen.routeName,
                    arguments: ReservationArguments(placeId, service, category,
                        specialist, durataServiciu, timpBlocat),
                  )
                : Navigator.of(context).pushNamed(
                    ReservationScreen.routeName,
                    arguments: ReservationArguments(placeId, service, category,
                        specialist, durataServiciu, timpBlocat),
                  );

        print(durataServiciu);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 25,
            padding: const EdgeInsets.all(10),
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(width: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      service,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesome.tag,
                          color: Colors.lightGreen,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("$price RON"),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          FontAwesome.clock_o,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(durataServiciu),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Icon(
                    Icons.arrow_right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReservationArguments {
  final String placeId;
  final String serviceTitle;
  final String category;
  final String specialist;
  final String durataServiciu;
  final Map<String, dynamic> zileBlocate;

  ReservationArguments(this.placeId, this.serviceTitle, this.category,
      this.specialist, this.durataServiciu, this.zileBlocate);
}
