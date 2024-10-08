// ignore_for_file: must_be_immutable, missing_return
import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/utils/authentication_service.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';

import './verify_email_screen.dart';
import './create_account.dart';
import './categories_screen.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/AccountScreen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _passwordVisible = true;

  final _form = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  // final _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void setState(VoidCallback fn) {
    if (auth.currentUser?.email != null) {
      Navigator.of(context).pushReplacementNamed(CategoriesScreen.routeName);
    }

    super.setState(fn);
  }

  // void _togglePasswordVisibility() {
  //   setState(() {
  //     _passwordVisible = !_passwordVisible;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_init_to_null
    // Map userData = null;
    // GoogleSignInAccount user;
    // _googleSignIn.currentUser == null
    //     ? user = _googleSignIn.currentUser
    //     // ignore: unnecessary_statements
    //     : null;
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
                          onPressed: () async {
                            if (!_form.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Datele contului tau sunt incomplete!"),
                                ),
                              );
                            } else {
                              try {
                                await auth.signInWithEmailAndPassword(
                                  email: _email.text.trim(),
                                  password: _password.text.trim(),
                                );
                                // ignore: unused_catch_clause
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Mail-ul sau parola contului dvs sunt gresite."),
                                  ),
                                );
                              }
                              if (auth.currentUser != null &&
                                  auth.currentUser.emailVerified == true) {
                                Navigator.of(context).pushReplacementNamed(
                                    CategoriesScreen.routeName);
                              } else if (auth.currentUser != null &&
                                  auth.currentUser.emailVerified == false) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Acceseaza link-ul primit pe mail pentru a continua.")));
                              }

                              // context.read<AuthenticationService>().signIn(    x
                              //       email: _email.text.trim(),
                              //       password: _password.text.trim(),
                              //     );
                            }
                            FocusScope.of(context).unfocus();
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
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CreateAccountScreen.routeName);
                          },
                          // onPressed: () async {
                          //   FocusScope.of(context).unfocus();
                          //   if (!_form.currentState.validate()) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text(
                          //             "Datele contului tau sunt incomplete!"),
                          //       ),
                          //     );
                          //   } else {
                          //     try {
                          //       await auth
                          //           .createUserWithEmailAndPassword(
                          //             email: _email.text.trim(),
                          //             password: _password.text.trim(),
                          //           )
                          //           .then((_) => Navigator.of(context)
                          //               .pushNamed(
                          //                   VerifyEmailScreen.routeName));
                          //     } on FirebaseAuthException catch (e) {
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackBar(
                          //           content: Text(e.message),
                          //         ),
                          //       );
                          //     }
                          //     // .read<AuthenticationService>()     x
                          //     // .signUp(
                          //     //   email: _email.text.trim(),
                          //     //   password: _password.text.trim(),
                          //     // )
                          //     // .then(
                          //     //   (_) => Navigator.of(context)
                          //     //       .pushNamed(VerifyEmailScreen.routeName),
                          //     // );
                          //   }
                          // },
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
                  SizedBox(
                    height: 50,
                    width: 350,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        // await _googleSignIn.signIn();
                        setState(() {});
                        // final statusSignIn = await _googleSignIn.isSignedIn();
                        // if (statusSignIn == true) {
                        //   Navigator.of(context)
                        //       .pushReplacementNamed(CategoriesScreen.routeName);
                        // }
                      },
                      text: 'Continua cu Google',
                    ),
                  ),
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
