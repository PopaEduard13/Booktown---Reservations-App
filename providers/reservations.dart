import 'package:flutter/material.dart';

import '../models/reservation.dart';

class Reservations with ChangeNotifier {
  // ignore: unused_field
  List<Reservation> _reservations = [
    // Reservation(
    //   imageURL:
    //       'https://buddhabarconstanta.ro/wp-content/uploads/2020/06/buddha-bar-piata-ovidiu.jpg',
    //   place_name: 'Buddha Bar',
    //   people: '2',
    //   date: '3 septembrie 2021',
    //   hour: '19',
    //   name: 'Popa Eduard',
    //   phone: '0771493871',
    // ),
  ];

  List<Reservation> get reservations {
    return [..._reservations];
  }

  void addReservation(Reservation rezervare) {
    final reservation = Reservation(
      imageURL: rezervare.imageURL,
      place_name: rezervare.place_name,
      people: rezervare.people,
      date: rezervare.date,
      hour: rezervare.hour,
      name: rezervare.name,
      phone: rezervare.phone,
    );
    _reservations.add(reservation);
    notifyListeners();
  }
}
