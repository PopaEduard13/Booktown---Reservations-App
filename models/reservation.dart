// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Reservation {
  final String imageURL;
  final String place_name;
  final String people;
  final String date;
  final String hour;
  final String name;
  final String phone;

  Reservation({
    @required this.imageURL,
    @required this.place_name,
    @required this.people,
    @required this.date,
    @required this.hour,
    @required this.name,
    @required this.phone,
  });
}
