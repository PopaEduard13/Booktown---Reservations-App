// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/screens/account_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:email_validator/email_validator.dart';

import './verify_email_screen.dart';
import './categories_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key key}) : super(key: key);
  static const routeName = '/CreateAccountScreen';

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _verifyEmail = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool _passwordVisible = true;

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(45),
                    child: Image.asset(
                      'assets/logo scurtat culoare 2.0.png',
                      width: 300,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (text) {
                          // ignore: null_aware_in_condition
                          if (text?.isEmpty) {
                            return "Adauga mail-ul pentru contul tau Booktown.";
                          } else if (!EmailValidator.validate(text)) {
                            return "Adauga un mail valid.";
                          } else if (text.contains("@admin.com") ||
                              text.contains("@admin.ro")) {
                            return "Contul de admin este doar pentru aplicatia business.";
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: 'Email :',
                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            icon: Icon(Icons.email),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != _email.text) {
                            return "Adauga acelasi mail pentru verificare.";
                          } else if (value.isEmpty) {
                            return "Adauga mail-ul tau pentru contul BookTown";
                          }
                        },
                        controller: _verifyEmail,
                        decoration: InputDecoration(
                          hintText: 'Verificare mail :',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          icon: Icon(Icons.email),
                          border: InputBorder.none,
                          // suffixIcon: IconButton(
                          //   onPressed: _togglePasswordVisibility,
                          //   icon: Icon(FontAwesome.eye),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                        obscureText: _passwordVisible,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Adauga o parola pentru contul tau Booktown.";
                          }
                        },
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: 'Parolă :',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          icon: Icon(FontAwesome.lock),
                          border: InputBorder.none,
                          // suffixIcon: IconButton(
                          //   onPressed: _togglePasswordVisibility,
                          //   icon: Icon(FontAwesome.eye),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AccountScreen.routeName);
                          },
                          child: Text(
                            "Intră în cont",
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (!_form.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Datele contului tau sunt incomplete!"),
                                ),
                              );
                            } else {
                              try {
                                await auth
                                    .createUserWithEmailAndPassword(
                                      email: _email.text.trim(),
                                      password: _password.text.trim(),
                                    )
                                    .then((_) => Navigator.of(context)
                                        .pushNamed(
                                            VerifyEmailScreen.routeName));
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message),
                                  ),
                                );
                              }
                              // .read<AuthenticationService>()     x
                              // .signUp(
                              //   email: _email.text.trim(),
                              //   password: _password.text.trim(),
                              // )
                              // .then(
                              //   (_) => Navigator.of(context)
                              //       .pushNamed(VerifyEmailScreen.routeName),
                              // );
                            }
                          },
                          child: Text(
                            "Creează cont",
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   width: 350,
                  //   child: SignInButton(
                  //     Buttons.Facebook,
                  //     onPressed: () async {
                  //       final result = await FacebookAuth.i
                  //           .login(permissions: ['public_profile', 'email']);

                  //       if (result.status == LoginStatus.success) {
                  //         final requestData = await FacebookAuth.i.getUserData(
                  //           fields: "email , name",
                  //         );
                  //         setState(() {
                  //           userData = requestData;
                  //         });

                  //         print('it works');
                  //       }
                  //       Navigator.of(context)
                  //           .pushReplacementNamed(CategoriesScreen.routeName);
                  //     },
                  //     text: 'Continua cu Facebook',
                  // ),
                  // ),
                  // SizedBox(
                  //   height: 50,
                  //   width: 350,
                  //   child: SignInButton(
                  //     Buttons.Google,
                  //     onPressed: () async {
                  //       // await _googleSignIn.signIn();
                  //       setState(() {});
                  //       // final statusSignIn = await _googleSignIn.isSignedIn();
                  //       // if (statusSignIn == true) {
                  //       //   Navigator.of(context)
                  //       //       .pushReplacementNamed(CategoriesScreen.routeName);
                  //       // }
                  //     },
                  //     text: 'Continua cu Google',
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // SizedBox(
                  //   height: 50,
                  //   width: 350,
                  //   child: SignInButton(
                  //     Buttons.AppleDark,
                  //     onPressed: () {},
                  //     text: 'Continua cu Apple',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
