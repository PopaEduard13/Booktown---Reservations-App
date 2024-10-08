import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/verify_email_screen.dart';
// import 'package:flutter_complete_guide/widgets/place_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:splashscreen/splashscreen.dart';

import './screens/account_screen.dart';
import './screens/register_screen.dart';
// ignore: unused_import
import './screens/categories_screen.dart';
import './screens/category_list_screen.dart';
import './screens/place_details_screen.dart';
import './screens/reservations_screen.dart';
import './screens/favorites_screen.dart';
import './screens/setup_profile_screen.dart';
import './screens/reservation_screen.dart';
import './screens/reviews_screen.dart';
import './screens/specialists_screen.dart';
import './screens/create_account.dart';
import './screens/specialist_reservation_screen.dart';
import './screens/category_favorites_screen.dart';
import './screens/gallery_screen.dart';
import './screens/profile_screen.dart';
import './screens/subcategories_screen.dart';
import './screens/menu_screen.dart';
import './screens/contact_screen.dart';
import './screens/services_screen.dart';
import './utils/authentication_wrapper.dart';
import './utils/user_simple_preferences.dart';
import './utils/authentication_service.dart';
import './screens/add_review_screen.dart';
import './screens/add_specialist_review_screen.dart';
import './screens/your_reservation_screen.dart';
// import './widgets/custom_page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSimplePreferences.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'BookTown',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xffedd8c2)),
          ),
          primaryColor: Color(0xffedd8c2),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Color(0xffFFFFFF),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
        onGenerateRoute: (settings) {
          if (settings.name == PlaceDetailsScreen.routeName) {
            return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_, __, ___) => PlaceDetailsScreen(),
                transitionsBuilder: (__, a, _, c) => FadeTransition(
                      opacity: a,
                      child: c,
                    ));
          }
          if (settings.name == ReservationScreen.routeName) {
            return PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 200),
                settings: settings,
                pageBuilder: (_, __, ___) => ReservationScreen(),
                transitionsBuilder: (__, a, _, c) => FadeTransition(
                      opacity: a,
                      child: c,
                    ));
          }
          if (settings.name == CategoryListScreen.routeName) {
            return PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 200),
                settings: settings,
                pageBuilder: (_, __, ___) => CategoryListScreen(),
                transitionsBuilder: (__, a, _, c) => FadeTransition(
                      opacity: a,
                      child: c,
                    ));
          }
          return MaterialPageRoute(
            builder: (_) => CategoriesScreen(),
          );
        },
        // onGenerateRoute: (route) => onGenerateRoute(route),
        // onGenerateRoute: (settings) {
        //   if (settings.name == PlaceDetailsScreen.routeName) {
        //     final args = settings.arguments as Arguments;

        //     return MaterialPageRoute(
        //         builder: ((context) => PlaceDetailsScreen()));
        //   }
        // },
        routes: {
          VerifyEmailScreen.routeName: (ctx) => VerifyEmailScreen(),
          AccountScreen.routeName: (ctx) => AccountScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          AddSpecialistReviewScreen.routeName: (ctx) =>
              AddSpecialistReviewScreen(),
          CreateAccountScreen.routeName: (ctx) => CreateAccountScreen(),
          AddReviewScreen.routeName: (ctx) => AddReviewScreen(),
          GalleryScreen.routeName: (ctx) => GalleryScreen(),
          YourReservationScreen.routeName: (ctx) => YourReservationScreen(),
          ReviewsScreen.routeName: (ctx) => ReviewsScreen(),
          CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
          SpecialistScreen.routeName: (ctx) => SpecialistScreen(),
          ContactScreen.routeName: (ctx) => ContactScreen(),
          ServicesScreen.routeName: (ctx) => ServicesScreen(),
          // ReservationScreen.routeName: (ctx) => ReservationScreen(),
          FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
          MenuScreen.routeName: (ctx) => MenuScreen(),
          Subcategories.routeName: (ctx) => Subcategories(),
          SetupProfileScreen.routeName: (ctx) => SetupProfileScreen(),
          // PlaceDetailsScreen.routeName: (ctx) => PlaceDetailsScreen(),
          // CategoryListScreen.routeName: (ctx) => CategoryListScreen(),
          ReservationsScreen.routeName: (ctx) => ReservationsScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          CategoryFavoritesScreen.routeName: (ctx) => CategoryFavoritesScreen(),
          SpecialistReservationScreen.routeName: (ctx) =>
              SpecialistReservationScreen(),
        },
      ),
    );
  }

  // static Route onGenerateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case PlaceDetailsScreen.routeName:
  //       return CustomPageRoute(
  //         child: PlaceDetailsScreen(),
  //         settings: settings,
  //       );

  //     case CategoryListScreen.routeName:
  //       return CustomPageRoute(
  //         child: CategoryListScreen(),
  //         settings: settings,
  //       );
  //   }
  // }
}
