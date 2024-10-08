// import 'package:flutter/material.dart';

// class CustomPageRoute extends PageRouteBuilder {
//   final Widget child;

//   CustomPageRoute({
//     this.child,
//     RouteSettings settings,
//   }) : super(
//           transitionDuration: Duration(milliseconds: 1),
//           pageBuilder: (context, animation, secondaryAnimation) => child,
//           settings: settings,
//         );

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animations,
//       Animation<double> secondaryAnimation, Widget child) {
//     ScaleTransition(
//       scale: animation,
//       child: child,
//     );
//   }
// }
