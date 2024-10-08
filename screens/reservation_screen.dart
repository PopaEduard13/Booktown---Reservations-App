// ignore_for_file: unnecessary_statements, missing_required_param

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

import './reservations_screen.dart';
import '../widgets/service_widget.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = '/reservationScreen';
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  DateTime _date;
  DateTime _checkIn;
  DateTime _checkOut;
  TimeOfDay _time;
  String _ora = '';
  bool lastReservationPerDay = false;

  Widget pickHour(String placeId, String date, String category,
      Map<String, dynamic> timpBlocat) {
    String ora = '';
    List<dynamic> hours;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("places")
          .doc("Categories")
          .collection(category)
          .doc(placeId)
          .snapshots(),
      builder: (context, placeSnapshot) {
        if (placeSnapshot.connectionState == ConnectionState.waiting ||
            !placeSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final place = placeSnapshot.data;
        hours = place['programRezervari'];

        Map<String, dynamic> offTime = timpBlocat;
        List<String> busyHours = [];

        if (offTime != null) {
          for (String key in offTime.keys) {
            if (key == date) {
              busyHours.add(offTime[key]);
              print(offTime[key]);
            }
          }
        }
        print(hours);
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(Icons.timer),
                ),
                SizedBox(
                  width: 15,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _ora == '' ? Text('Selecteaza ora') : Text(_ora))
              ],
            ),
            Container(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hours.length,
                itemBuilder: (ctx, i) {
                  if (busyHours.contains(hours[i])) {
                    return Container();
                  } else {
                    TimeOfDay hour = TimeOfDay(
                        hour: int.parse(hours[i].split(":")[0]),
                        minute: int.parse(hours[i].split(":")[1]));
                    if (_date.day != DateTime.now().day) {
                      return TextButton(
                        onPressed: () {
                          setState(() {
                            _ora = hours[i];
                          });
                          // setState(() {
                          //   ora = hours[i];
                          // });
                        },
                        child: Text(hours[i]),
                      );
                    } else {
                      if (hour.hour > DateTime.now().hour ||
                          (hour.hour == DateTime.now().hour &&
                              hour.minute > DateTime.now().minute)) {
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              _ora = hours[i];
                            });
                          },
                          child: Text(hours[i]),
                        );
                      } else {
                        return Container();
                      }
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget pickHourSpecialist(
  //     String placeId,
  //     String date,
  //     String category,
  //     String specialistServiciu,
  //     String durataServiciu,
  //     Map<String, dynamic> timpBlocat) {
  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance
  //           .collection('places')
  //           .doc('Categories')
  //           .collection(category)
  //           .doc(placeId)
  //           .collection('specialisti')
  //           .doc(specialistServiciu)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting ||
  //             !snapshot.hasData) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         final specialist = snapshot.data;
  //         Map<dynamic, dynamic> programDinamic = specialist['programDinamic'];
  //         List<dynamic> programRezervari = specialist['program'];
  //         List<dynamic> hours;
  //         if (programDinamic.containsKey(date) == true) {
  //           hours = programDinamic[date];
  //         } else {
  //           hours = programRezervari;
  //         }
  //         return ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: hours.length,
  //             itemBuilder: (ctx, i) {
  //               if (hours.length == 1) {
  //                 lastReservationPerDay = true;
  //               }

  //               return TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     ora = hours[i];
  //                   });
  //                 },
  //                 child: Text(hours[i]),
  //               );
  //             });
  //       });
  // }
  // Widget pickHourSpecialist(
  //     String placeId,
  //     String date,
  //     String category,
  //     String specialistServiciu,
  //     String durataServiciu,
  //     Map<String, dynamic> timpBlocat) {
  //   List<dynamic> hours;
  //   Map<String, dynamic> offTime = timpBlocat;
  //   List<String> oreBlocate = [];

  //   if (offTime != null) {
  //     for (String key in offTime.keys) {
  //       if (key == date) {
  //         oreBlocate.add(offTime[key]);
  //         print(offTime[key]);
  //       }
  //     }
  //   }

  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance
  //           .collection("places")
  //           .doc("Categories")
  //           .collection(category)
  //           .doc(placeId)
  //           .collection('specialisti')
  //           .doc(specialistServiciu)
  //           .snapshots(),
  //       builder: (context, specialistSnapshot) {
  //         if (specialistSnapshot.connectionState == ConnectionState.waiting ||
  //             !specialistSnapshot.hasData) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         final specialist = specialistSnapshot.data;
  //         // print(specialist['program']);
  //         hours = specialist['program'];
  //         return StreamBuilder(
  //             stream: FirebaseFirestore.instance
  //                 .collection('places')
  //                 .doc('Categories')
  //                 .collection(category)
  //                 .doc(placeId)
  //                 .collection('specialisti')
  //                 .doc(specialistServiciu)
  //                 .collection('reservations')
  //                 .snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting ||
  //                   !snapshot.hasData) {
  //                 return Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               }
  //               final reservations = snapshot.data.docs;
  //               final Map busyHours = {};

  //               if (reservations.length != null) {
  //                 for (int i = 0; i < reservations.length; ++i) {
  //                   if (reservations[i]['date'] == date) {
  //                     busyHours["${reservations[i]['time']}"] =
  //                         reservations[i]['durata'];
  //                     // busyHours.addEntries(
  //                     //   reservations[i]['time'],
  //                     // );
  //                   }
  //                 }
  //               }

  //               // Finalizam lista dinamica de ore disponibile
  //               for (int i = 0; i < hours.length; ++i) {
  //                 if (busyHours.containsKey(hours[i])) {
  //                   if (i == hours.length - 1) {
  //                     hours[i] = '';
  //                   } else {
  //                     TimeOfDay oraInceput = TimeOfDay(
  //                         hour: int.parse(hours[i].split(":")[0]),
  //                         minute: int.parse(hours[i].split(":")[1]));
  //                     int nextIndexAvailable;

  //                     final String durataServiciuRezervat = busyHours[hours[i]];

  //                     for (int j = i; busyHours.containsKey(hours[j]); ++j) {
  //                       nextIndexAvailable = j;
  //                       hours[j] = '';
  //                     }

  //                     TimeOfDay oraUrmatoareDisponibila = TimeOfDay(
  //                         hour: int.parse(
  //                             hours[nextIndexAvailable + 1].split(":")[0]),
  //                         minute: int.parse(
  //                             hours[nextIndexAvailable + 1].split(":")[1]));

  //                     TimeOfDay durata = TimeOfDay(
  //                         hour: 0,
  //                         minute:
  //                             int.parse(durataServiciuRezervat.split(" ")[0]));
  //                     TimeOfDay oraFinal =
  //                         oraInceput.plusMinutes(durata.minute);
  //                     int intOraFinal = oraFinal.hour * 60 + oraFinal.minute;
  //                     int intOraUrmatoareDisponibila =
  //                         oraUrmatoareDisponibila.hour * 60 +
  //                             oraUrmatoareDisponibila.minute;
  //                     if (intOraFinal < intOraUrmatoareDisponibila) {
  //                       if (oraFinal.hour < 10) {
  //                         hours[i] = "0${oraFinal.hour}:${oraFinal.minute}";
  //                       } else {
  //                         hours[i] = "${oraFinal.hour}:${oraFinal.minute}";
  //                       }
  //                     } else if (intOraFinal > intOraUrmatoareDisponibila) {
  //                       hours[nextIndexAvailable + 1] =
  //                           "${oraFinal.hour}:${oraFinal.minute}";
  //                     }
  //                   }
  //                 }
  //               }

  //               return ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: hours.length,
  //                   itemBuilder: (ctx, i) {
  //                     if (hours.length == 1) {
  //                       lastReservationPerDay = true;
  //                     }
  //                     if (hours[i] != '' && !oreBlocate.contains(hours[i])) {
  //                       return TextButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             ora = hours[i];
  //                           });
  //                         },
  //                         child: Text(hours[i]),
  //                       );
  //                     }
  //                     return Container();
  //                   });
  //             });
  //       });
  // }

  String getMonthByName(int m) {
    final List months = [
      'Ianuarie',
      'Februarie',
      'Martie',
      'Aprilie',
      'Mai',
      'Iunie',
      'Iulie',
      'August',
      'Septembrie',
      'Octombrie',
      'Noiembrie',
      'Decembrie'
    ];
    String month = months[m - 1];
    return month;
  }

  // Future<List<String>> getZileBlocateLocatie(String category , String place) async {
  //   Map<String,dynamic> timpBlocat = {};
  //   List<String> res = [];
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection('places').doc("Categories").collection(category).doc(place).snapshots(),
  //     builder: (context , snapshot) {
  //       var document = await snapshot.data;
  //       timpBlocat = document["timpBlocat"];
  //       for (String key in timpBlocat.keys) {
  //       if (timpBlocat[key] == 'full') {
  //       res.add(key);
  //     }
  //   }
  //   print("//// $timpBlocat");
  //   return res;
  //   }

  //     }
  Future pickDateSpecialist(BuildContext context, List<int> offDays,
      Map<String, dynamic> timpBlocat) async {
    final initialDate = DateTime.now();

    List<String> zileBlocate = [];
    print("//// $timpBlocat");

    timpBlocat.forEach((key, value) {
      if (value == 'full') {
        zileBlocate.add(key);
      }
    });

    // for (String key in timpBlocat) {
    //   if (timpBlocat[key] == 'full') {
    //     zileBlocate.add(key);
    //   }
    // }

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      selectableDayPredicate: (day) => offDays.contains(day.weekday) ||
              zileBlocate.contains(
                  '${day.day} ${getMonthByName(day.month)} ${day.year}')
          ? false
          : true,
    );

    if (newDate == null) return;

    setState(() {
      _date = newDate;
    });
  }

  Future pickDate(BuildContext context, List<int> offDays,
      Map<String, dynamic> timpBlocat) async {
    final initialDate = DateTime.now();

    List<String> zileBlocate = [];
    print("//// $timpBlocat");

    timpBlocat.forEach((key, value) {
      if (value == 'full') {
        zileBlocate.add(key);
      }
    });

    // for (String key in timpBlocat) {
    //   if (timpBlocat[key] == 'full') {
    //     zileBlocate.add(key);
    //   }
    // }

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      selectableDayPredicate: (day) => offDays.contains(day.weekday) ||
              zileBlocate.contains(
                  '${day.day} ${getMonthByName(day.month)} ${day.year}')
          ? false
          : true,
    );

    if (newDate == null) return;

    setState(() {
      _date = newDate;
    });
  }

  List getOffDays(var program) {
    List zile = <int>[];
    program["Luni"]["Open"] as String == "Inchis" ? zile.add(1) : {};
    program["Marti"]["Open"] as String == "Inchis" ? zile.add(2) : {};
    program["Miercuri"]["Open"] as String == "Inchis" ? zile.add(3) : {};
    program["Joi"]["Open"] as String == "Inchis" ? zile.add(4) : {};
    program["Vineri"]["Open"] as String == "Inchis" ? zile.add(5) : {};
    program["Sambata"]["Open"] as String == "Inchis" ? zile.add(6) : {};
    program["Duminica"]["Open"] as String == "Inchis" ? zile.add(7) : {};

    print(zile);
    return zile;
  }

  Future pickCheckIn(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() {
      _checkIn = newDate;
    });
  }

  Future pickCheckOut(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() {
      _checkOut = newDate;
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (newTime == null) return;

    setState(() {
      _time = newTime;
    });
  }

  final nrPers = new TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   _firstName = UserSimplePreferences.getFirstName() ?? '';
  //   _lastName = UserSimplePreferences.getSecondName() ?? '';
  //   _phone = UserSimplePreferences.getPhone() ?? '';
  //   _email = UserSimplePreferences.getEmail() ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ReservationArguments;
    final String _uid = FirebaseAuth.instance.currentUser.uid;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc('${FirebaseAuth.instance.currentUser.uid}')
                  .snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting ||
                    !streamSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final profile = streamSnapshot.data;
                _firstName = profile['firstName'];
                _lastName = profile['lastName'];
                _email = profile['email'];
                _phone = profile['phone'];
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('places')
                        .doc('Categories')
                        .collection(args.category)
                        .doc(args.placeId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final document = snapshot.data;
                      var program = document.get('program');
                      // List<dynamic> reservationHours = [];
                      // if (args.specialist != "") {
                      //   return StreamBuilder(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('places')
                      //         .doc('Categories')
                      //         .collection(args.category)
                      //         .doc(args.placeId)
                      //         .collection('specialisti')
                      //         .doc(args.specialist)
                      //         .snapshots(),
                      //     // ignore: missing_return
                      //     builder: (context, specialistSnapshot) {
                      //       print(args.specialist);
                      //       print(args.category);
                      //       print(args.placeId);
                      //       if (specialistSnapshot.connectionState ==
                      //               ConnectionState.waiting ||
                      //           !specialistSnapshot.hasData) {
                      //         return Center(child: CircularProgressIndicator());
                      //       }
                      //       final specialistDocument = specialistSnapshot.data;
                      //       reservationHours = specialistDocument['program'];
                      //       print("Poate aici ? $reservationHours");
                      //     },
                      //   );
                      // } else {
                      //   reservationHours = document['programRezervari'];
                      // }
                      // print("Dar aici apare ok ? ${args.specialist}");
                      // print("Orele de rezervari : $reservationHours");
                      var timpBlocat = args.zileBlocate;
                      return SafeArea(
                        child: Form(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const BackButton(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 15,
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Rezervarea ta la ${document['title']}',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                document['category'] == 'Restaurante' ||
                                        document['category'] == 'Cafenele' ||
                                        document['category'] == 'Evenimente'
                                    ? selectNumberOfPeople(nrPers)
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Serviciu : ${args.serviceTitle}",
                                              style: TextStyle(
                                                  fontSize: 18.5,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      "Specialist : ${args.specialist}",
                                                      style: TextStyle(
                                                          fontSize: 18.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                // document['category'] == 'Cazari'
                                //     ? Column(
                                //         children: [
                                //           Row(
                                //             children: [
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     top: 10),
                                //                 child:
                                //                     Icon(Icons.calendar_today),
                                //               ),
                                //               SizedBox(
                                //                 width: 15,
                                //               ),
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     top: 10),
                                //                 child: ElevatedButton(
                                //                   style:
                                //                       ElevatedButton.styleFrom(
                                //                     backgroundColor:
                                //                         Colors.blue,
                                //                   ),
                                //                   onPressed: () =>
                                //                       pickCheckIn(context),
                                //                   child: _checkIn == null
                                //                       ? Text(
                                //                           "Data Check-In",
                                //                         )
                                //                       : Text(
                                //                           "${_checkIn.day} ${getMonthByName(_checkIn.month)} ${_checkIn.year}",
                                //                         ),
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //           Row(
                                //             children: [
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     top: 10),
                                //                 child:
                                //                     Icon(Icons.calendar_today),
                                //               ),
                                //               SizedBox(
                                //                 width: 15,
                                //               ),
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     top: 10),
                                //                 child: ElevatedButton(
                                //                   style:
                                //                       ElevatedButton.styleFrom(
                                //                     backgroundColor:
                                //                         Colors.blue,
                                //                   ),
                                //                   onPressed: () =>
                                //                       pickCheckOut(context),
                                //                   child: _checkOut == null
                                //                       ? Text(
                                //                           "Data Check-Out",
                                //                         )
                                //                       : Text(
                                //                           "${_checkOut.day} ${getMonthByName(_checkOut.month)} ${_checkOut.year}",
                                //                         ),
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //         ],
                                //       )
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(Icons.calendar_today),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () {
                                          final List offDays =
                                              getOffDays(program);
                                          pickDate(context, offDays,
                                              args.zileBlocate);
                                        },
                                        child: _date == null
                                            ? Text(
                                                "Seleceaza data",
                                              )
                                            : Text(
                                                "${_date.day} ${getMonthByName(_date.month)} ${_date.year}",
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(top: 10),
                                //       child: Icon(Icons.timer),
                                //     ),
                                //     SizedBox(
                                //       width: 15,
                                //     ),
                                //     Padding(
                                //         padding: const EdgeInsets.only(top: 10),
                                //         child: ora == ''
                                //             ? Text('Selecteaza ora')
                                //             : Text(ora))

                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(top: 10),
                                //   child: ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       primary: Colors.blue,
                                //     ),
                                //     onPressed: () => pickTime(context),
                                //     child: Text(
                                //       getTimeText(),
                                //     ),
                                //   ),
                                // )
                                // ],
                                // ),
                                Container(
                                  height: 80,
                                  child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        _date != null
                                            ? Expanded(
                                                child: pickHour(
                                                args.placeId,
                                                '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                args.category,
                                                args.zileBlocate,
                                              ))
                                            : Text(
                                                "Selecteaza data pentru a verifica disponibilitatea orelor!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Persoana de contact :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "$_firstName $_lastName",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Numar de telefon :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "$_phone",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Center(
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        document['category'] == 'Restaurante' ||
                                                document['category'] ==
                                                    'Cafenele' ||
                                                document['category'] ==
                                                    'Evenimente'
                                            ? {
                                                FirebaseFirestore.instance
                                                    .collection('places')
                                                    .doc('Categories')
                                                    .collection(args.category)
                                                    .doc(args.placeId)
                                                    .collection("Reservations")
                                                    .add({
                                                  'category':
                                                      '${document['category']}',
                                                  'title':
                                                      '${document['title']}',
                                                  'time': _ora,
                                                  'date':
                                                      '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                  'imageUrl':
                                                      '${document['imageUrl']}',
                                                  'email': _email,
                                                  'numberPeople':
                                                      '${nrPers.text}',
                                                  'name':
                                                      '$_firstName $_lastName',
                                                  'placeId': '${args.placeId}',
                                                  'status': 'In asteptare',
                                                  'phone': _phone,
                                                  'profileUID': FirebaseAuth
                                                      .instance.currentUser.uid,
                                                }),
                                                FirebaseFirestore.instance
                                                    .collection('profiles')
                                                    .doc(_uid)
                                                    .collection('reservations')
                                                    .add({
                                                  'category':
                                                      '${document['category']}',
                                                  'title':
                                                      '${document['title']}',
                                                  'time': _ora,
                                                  'date':
                                                      '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                  'imageUrl':
                                                      '${document['imageUrl']}',
                                                  'email': _email,
                                                  'numberPeople':
                                                      '${nrPers.text}',
                                                  'name':
                                                      '$_firstName $_lastName',
                                                  'placeId': '${args.placeId}',
                                                  'status': 'In asteptare',
                                                  'phone': _phone,
                                                  'profileUID': FirebaseAuth
                                                      .instance.currentUser.uid,
                                                }),
                                                if (lastReservationPerDay ==
                                                    true)
                                                  {
                                                    FirebaseFirestore.instance
                                                        .collection('places')
                                                        .doc('Categories')
                                                        .collection(
                                                            args.category)
                                                        .doc(args.placeId)
                                                        .update({
                                                      "timpBlocat": {
                                                        "${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}":
                                                            "full"
                                                      }
                                                    })
                                                  }
                                              }
                                            : {
                                                FirebaseFirestore.instance
                                                    .collection('places')
                                                    .doc("Categories")
                                                    .collection(args.category)
                                                    .doc(args.placeId)
                                                    .collection("specialisti")
                                                    .doc(args.specialist)
                                                    .collection('reservations')
                                                    .add({
                                                  'category':
                                                      '${document['category']}',
                                                  'title':
                                                      '${document['title']}',
                                                  'time': _ora,
                                                  'date':
                                                      '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                  'imageUrl':
                                                      '${document['imageUrl']}',
                                                  'email': '$_email',
                                                  'durata': args.durataServiciu,
                                                  'specialist': args.specialist,
                                                  'service': args.serviceTitle,
                                                  'name':
                                                      '$_firstName $_lastName',
                                                  'placeId': '${args.placeId}',
                                                  'status': 'In asteptare',
                                                  'phone': _phone,
                                                  'profileUID': FirebaseAuth
                                                      .instance.currentUser.uid,
                                                }),
                                                FirebaseFirestore.instance
                                                    .collection('profiles')
                                                    .doc(_uid)
                                                    .collection('reservations')
                                                    .add({
                                                  'category':
                                                      '${document['category']}',
                                                  'title':
                                                      '${document['title']}',
                                                  'time': _ora,
                                                  'date':
                                                      '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                  'imageUrl':
                                                      '${document['imageUrl']}',
                                                  'email': '$_email',
                                                  'durata': args.durataServiciu,
                                                  'specialist': args.specialist,
                                                  'service': args.serviceTitle,
                                                  'name':
                                                      '$_firstName $_lastName',
                                                  'placeId': '${args.placeId}',
                                                  'status': 'In asteptare',
                                                  'phone': _phone,
                                                  'profileUID': FirebaseAuth
                                                      .instance.currentUser.uid,
                                                }),
                                                if (lastReservationPerDay ==
                                                    true)
                                                  {
                                                    FirebaseFirestore.instance
                                                        .collection('places')
                                                        .doc('Categories')
                                                        .collection(
                                                            args.category)
                                                        .doc(args.placeId)
                                                        .collection(
                                                            'specialisti')
                                                        .doc(args.specialist)
                                                        .update({
                                                      "timpBlocat": {
                                                        "${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}":
                                                            "full"
                                                      }
                                                    })
                                                  },
                                              };
                                        Navigator.of(context).pushNamed(
                                            ReservationsScreen.routeName,
                                            arguments: document['category']);
                                      },
                                      child: Text(
                                        "Trimite rezervarea",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}

Widget selectNumberOfPeople(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Numar persoane',
      icon: Icon(Icons.person_outline_rounded),
    ),
    keyboardType: TextInputType.number,
  );
}

extension TimeOfDayExtension on TimeOfDay {
  // Ported from org.threeten.bp;
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}
