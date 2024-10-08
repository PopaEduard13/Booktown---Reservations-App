import 'package:flutter/material.dart';

import '../models/profile.dart';
// import '../models/sex_enum.dart';

class PersonProfile with ChangeNotifier {
  List<Profile> _profile = [
    // Profile(
    //   first_name: "Popa",
    //   last_name: "Eduard",
    //   telephone: "0771493871",
    //   email: "edutzup.13@gmail.com",
    //   sex: Sex.Masculin,
    // )
  ];

  void addProfile(Profile profile) {
    final profil = Profile(
      first_name: profile.first_name,
      last_name: profile.last_name,
      telephone: profile.telephone,
      email: profile.email,
      sex: profile.sex,
    );
    _profile.add(profil);
    notifyListeners();
  }

  void removeProfile() {
    _profile.remove(_profile[0]);
  }

  List<Profile> get profile {
    return [..._profile];
  }
}
