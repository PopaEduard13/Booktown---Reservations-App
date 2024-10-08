// ignore_for_file: non_constant_identifier_names

import "package:flutter/material.dart";

import './sex_enum.dart';

class Profile {
  String first_name;
  String last_name;
  String telephone;
  String email;
  Sex sex;

  Profile({
    @required this.first_name,
    @required this.last_name,
    @required this.telephone,
    @required this.email,
    @required this.sex,
  });
}
