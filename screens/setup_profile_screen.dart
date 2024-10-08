// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import './profile_screen.dart';
import '../widgets/service_widget.dart';
import './reservation_screen.dart';

// ignore: must_be_immutable
class SetupProfileScreen extends StatelessWidget {
  static const routeName = '/SetupProfileScreen';
  final auth = FirebaseAuth.instance;

  final _form = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ReservationArguments;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(),
                        // Expanded(child: SizedBox()),
                        Center(
                          child: Text(
                            "Profilul tău",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        BackButton(
                          color: Colors.transparent,
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 10),
                      child: Text(
                          "Avem nevoie să te cunoaștem mai bine pentru rezervările tale ce vor urma :)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Te rugăm să-ți treci numele de familie.";
                        }
                      },
                      controller: _firstName,
                      decoration: InputDecoration(
                        labelText: "Nume :",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Te rugăm să-ți treci numele mic.";
                        }
                      },
                      controller: _lastName,
                      decoration: InputDecoration(
                        labelText: "Prenume :",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Te rugăm să-ți treci numărul de telefon.";
                        } else if (value.length != 10 || !isNumeric(value)) {
                          return "Te rugăm să treci un număr de telefon valid.";
                        }
                      },
                      controller: _phone,
                      decoration: InputDecoration(
                        labelText: "Telefon :",
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Email : ${auth.currentUser.email}",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        if (_form.currentState.validate()) {
                          auth.currentUser
                              .updateDisplayName('${_firstName.text}');
                          FirebaseFirestore.instance
                              .collection('profiles')
                              .doc(auth.currentUser.uid)
                              .set({
                            'firstName': '${_firstName.text}',
                            'lastName': '${_lastName.text}',
                            'phone': _phone.text,
                            'email': auth.currentUser.email,
                            // GoogleSignIn(scopes: ['email']).
                          });
                          if (args == null) {
                            Navigator.of(context)
                                .pushReplacementNamed(ProfileScreen.routeName);
                          } else {
                            Navigator.of(context).pushReplacementNamed(
                              ReservationScreen.routeName,
                              arguments: ReservationArguments(
                                  args.placeId,
                                  args.serviceTitle,
                                  args.category,
                                  args.specialist,
                                  args.durataServiciu,
                                  args.zileBlocate),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Salvează profilul",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
