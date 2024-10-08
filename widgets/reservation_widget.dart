// // ignore_for_file: non_constant_identifier_names

// import 'package:flutter/material.dart';
// import '../screens/your_reservation_screen.dart';

// class ReservationWidget extends StatelessWidget {
//   final String imageURL;
//   final String place_name;
//   final String date;
//   final String hour;
//   final String nrPers;

//   ReservationWidget(
//       this.imageURL, this.place_name, this.date, this.hour, this.nrPers);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Navigator.of(context).pushNamed(
//         YourReservationScreen.routeName,
//         arguments:
            
//       ),
//       child: ListTile(
//         leading: Container(
//           child: Image.network(
//             imageURL,
//             fit: BoxFit.fill,
//           ),
//           width: 80,
//           height: 120,
//         ),
//         title: Text(place_name),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("$date $hour"),
//             Text("Nr. persoane : $nrPers"),
//           ],
//         ),
//         dense: false,
//         trailing: Icon(Icons.menu),
//       ),
//     );
//   }
// }

