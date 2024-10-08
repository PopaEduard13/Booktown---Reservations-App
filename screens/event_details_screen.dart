// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import './reservation_screen.dart';
// import './setup_profile_screen.dart';

// class EventDetailsScreen extends StatefulWidget {
//   const EventDetailsScreen({Key key}) : super(key: key);
//   static const routeName = '/EventDetailsScreen';

//   @override
//   State<EventDetailsScreen> createState() => _EventDetailsScreenState();
// }

// class _EventDetailsScreenState extends State<EventDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: BackButton(
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//          floatingActionButton: 
//             FloatingActionButton(
//                 onPressed: () {
//                   FirebaseAuth.instance.currentUser.displayName == '' ||
//                           FirebaseAuth.instance.currentUser.displayName == null
//                       ? Navigator.of(context).pushNamed(
//                           SetupProfileScreen.routeName,
//                           arguments: ReservationArguments(args.placeId, '',
//                               args.category, '', '', args.timpBlocat))
//                       : Navigator.of(context).pushNamed(
//                           ReservationScreen.routeName,
//                           arguments: ReservationArguments(args.placeId, '',
//                               args.category, '', '', args.timpBlocat));
//                 },
//                 child: Text(
//                   'Rezerva',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 backgroundColor: Colors.blue,
//               )
//             : null,
//   }
// }