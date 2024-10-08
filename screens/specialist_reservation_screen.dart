// ignore_for_file: unnecessary_statements

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'reservation_screen.dart';
import 'reservations_screen.dart';
import '../widgets/service_widget.dart';

class SpecialistReservationScreen extends StatefulWidget {
  const SpecialistReservationScreen({Key key}) : super(key: key);
  static const routeName = '/SpecialistReservationScreen';

  @override
  State<SpecialistReservationScreen> createState() =>
      _SpecialistReservationScreenState();
}

class _SpecialistReservationScreenState
    extends State<SpecialistReservationScreen> {
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  DateTime _date;
  TimeOfDay _time;
  String ora = 'Selecteaza ora';
  bool lastReservationPerDay = false;

  void updateDynamicSchedule(
      String category,
      String place,
      String specialist,
      String date,
      String oraSelectata,
      String durataServiciu,
      dynamic specialistData,
      dynamic reservations,
      bool alreadyExistDynamicSchedule) {
    // List<dynamic> hours = specialistData['program'];
    List<dynamic> schedule = specialistData['program'];
    Map<dynamic, dynamic> dynamicSchedule = specialistData['programDinamic'];
    List<dynamic> hours;
    if (alreadyExistDynamicSchedule && dynamicSchedule.containsKey(date)) {
      hours = specialistData['programDinamic'][date];
    } else {
      hours = specialistData['program'];
    }
    Map<String, dynamic> offTime = {};
    List<String> oreBlocate = [];
    print("intram in functie");
    offTime = specialistData['timpBlocat'];
    print("avem bd");

    if (offTime != null) {
      for (String key in offTime.keys) {
        if (key == date) {
          oreBlocate.add(offTime[key]);
          print(offTime[key]);
        }
      }
    }
    print('lista de ore');
    print(hours);
    print('finalizam lista dinamica');
    // Finalizam lista dinamica de ore disponibile
    for (int i = 0; i < hours.length; ++i) {
      if (hours[i] == oraSelectata) {
        TimeOfDay oraRezervarii = TimeOfDay(
          hour: int.parse(oraSelectata.split(":")[0]),
          minute: int.parse(oraSelectata.split(":")[1]),
        );
        int intOraRezervarii = oraRezervarii.hour * 60 + oraRezervarii.minute;
        TimeOfDay durata =
            TimeOfDay(hour: 0, minute: int.parse(durataServiciu.split(" ")[0]));

        String oraPrecedenta = "";
        print("i $i");
        if (i > 0) {
          oraPrecedenta = hours[i - 1];
        }
        String oraUrmatoare = "";
        if (i < hours.length - 1) {
          oraUrmatoare = hours[i + 1];
        }
        print("oraPrecedenta : $oraPrecedenta");
        if (oraPrecedenta.isNotEmpty) {
          TimeOfDay oraPrecedentaDisponibila = TimeOfDay(
            hour: int.parse(oraPrecedenta.split(":")[0]),
            minute: int.parse(oraPrecedenta.split(":")[1]),
          );
          int intOraPrecedenta = oraPrecedentaDisponibila.hour * 60 +
              oraPrecedentaDisponibila.minute;
          if (intOraPrecedenta + durata.minute > intOraRezervarii) {
            TimeOfDay oraModificata =
                oraRezervarii.plusMinutes(-(durata.minute));
            String oraModif;
            if (oraModificata.hour < 10 && oraModificata.minute == 0) {
              oraModif = '0${oraModificata.hour}:0${oraModificata.minute}';
            } else if (oraModificata.hour < 10 && oraModificata.minute > 0) {
              oraModif = '0${oraModificata.hour}:${oraModificata.minute}';
            } else if (oraModificata.hour > 10 && oraModificata.minute == 0) {
              oraModif = '${oraModificata.hour}:0${oraModificata.minute}';
            } else {
              oraModif = '${oraModificata.hour}:${oraModificata.minute}';
            }
            hours[i - 1] = oraModif;
          }
        }
        if (oraUrmatoare.isNotEmpty) {
          TimeOfDay oraUrmatoareDisponibila = TimeOfDay(
            hour: int.parse(oraUrmatoare.split(":")[0]),
            minute: int.parse(oraUrmatoare.split(":")[1]),
          );
          int intOraUrmatoare = oraUrmatoareDisponibila.hour * 60 +
              oraUrmatoareDisponibila.minute;

          if (intOraRezervarii + durata.minute > intOraUrmatoare) {
            TimeOfDay oraModificata = oraRezervarii.plusMinutes(durata.minute);
            String oraModif;
            if (oraModificata.hour < 10 && oraModificata.minute == 0) {
              oraModif = '0${oraModificata.hour}:0${oraModificata.minute}';
            } else if (oraModificata.hour < 10 && oraModificata.minute > 0) {
              oraModif = '0${oraModificata.hour}:${oraModificata.minute}';
            } else if (oraModificata.hour > 10 && oraModificata.minute == 0) {
              oraModif = '${oraModificata.hour}:0${oraModificata.minute}';
            } else {
              oraModif = '${oraModificata.hour}:${oraModificata.minute}';
            }
            // String oraModif = '${oraModificata.hour}:${oraModificata.minute}';
            hours[i + 1] = oraModif;
          }
        }
        if ((!schedule.contains(oraPrecedenta) && i > 0) || i == 1) {
          hours.removeAt(i - 1);
          hours.removeAt(i - 1);
        } else if ((!schedule.contains(oraUrmatoare)) ||
            i == hours.length - 2 ||
            hours[i] == hours[i + 1]) {
          hours.removeAt(i);
          hours.removeAt(i);
        } else {
          hours.removeAt(i);
        }

        if (i == 0 && hours[i] == hours[i + 1]) {
          hours.removeAt(i);
        } else if (i == hours.length - 1 && hours[i] == hours[i - 1]) {
          hours.removeAt(i);
        } else if (0 < i && i < hours.length - 1) {
          if (hours[i] == hours[i + 1] || hours[i] == hours[i - 1]) {
            hours.removeAt(i);
          }
        }

        // if (i == hours.length - 1) {
        //   hours[i] = '';
        // } else {
        // TimeOfDay oraInceput = TimeOfDay(
        //     hour: int.parse(hours[i].split(":")[0]),
        //     minute: int.parse(hours[i].split(":")[1]));
        // int nextIndexAvailable;
        // int intOraInceput = oraInceput.hour * 60 + oraInceput.minute;
        // // final String durataServiciuRezervat = busyHours[hours[i]];
        // String durataServiciuRezervat;

        // for (int j = i + 1; j < hours.length; ++j) {
        //   if (hours[j] != '') {
        //     nextIndexAvailable = j;
        //     break;
        //   }
        // }
        // // for (int j = i;
        // //     busyHours.containsKey(hours[j]) || hours[j] == oraSelectata;
        // //     ++j) {
        // //   nextIndexAvailable = j;
        // //   hours[j] = '';
        // // }

        // TimeOfDay oraUrmatoareDisponibila = TimeOfDay(
        //     hour: int.parse(schedule[i + 1].split(":")[0]),
        //     minute: int.parse(schedule[i + 1].split(":")[1]));
        //     TimeOfDay oraPrecedentaDisponibila;
        // if (i > 0) {
        //   oraPrecedentaDisponibila = TimeOfDay(
        //       hour: int.parse(schedule[i - 1].split(":")[0]),
        //       minute: int.parse(schedule[i - 1].split(":")[1]));
        // }
        // TimeOfDay durata = TimeOfDay(
        //     hour: 0, minute: int.parse(durataServiciu.split(" ")[0]));
        // TimeOfDay oraFinal = oraInceput.plusMinutes(durata.minute);
        // int intOraFinal = oraFinal.hour * 60 + oraFinal.minute;
        // int intOraUrmatoareDisponibila = oraUrmatoareDisponibila.hour * 60 +
        //     oraUrmatoareDisponibila.minute;
        // if (intOraFinal < intOraUrmatoareDisponibila) {
        //   if (oraFinal.hour < 10) {
        //     print('e');
        //     hours[i] = "0${oraFinal.hour}:${oraFinal.minute}";
        //   } else {
        //     print('f');
        //     hours[i] = "${oraFinal.hour}:${oraFinal.minute}";
        //   }
        // } else if (intOraFinal > intOraUrmatoareDisponibila) {
        //   if (i < hours.length - 2) {
        //     print('g');
        //     hours[i] = '';
        //     hours[nextIndexAvailable] = "${oraFinal.hour}:${oraFinal.minute}";
        //   } else {
        //     print('h');
        //     hours[i] = '';
        //     hours[i + 1] = '';
        //   }
        // }
        // if (oraPrecedentaDisponibila != null) {
        //   TimeOfDay oraTerminare = oraPrecedentaDisponibila.plusMinutes(durata.minute);
        //   int intOraTerminare = oraTerminare.hour * 60 + oraTerminare.minute;
        //   if (intOraTerminare > intOraInceput) {

        //   }
        // }
      }
    }
    print('i');
    for (int i = 0; i < hours.length; ++i) {
      if (oreBlocate.contains(hours[i])) {
        hours.remove(hours[i]);
      }
    }
    print("incepe program dinamic ");
    print(hours);
    FirebaseFirestore.instance
        .collection('places')
        .doc('Categories')
        .collection(category)
        .doc(place)
        .collection('specialisti')
        .doc(specialist)
        .set({
      "programDinamic": {'$date': hours}
    }, SetOptions(merge: true));
    print("finalProgramDinamic");
    if (hours.length == 0) {
      FirebaseFirestore.instance
          .collection('places')
          .doc('Categories')
          .collection(category)
          .doc(place)
          .collection('specialisti')
          .doc(specialist)
          .set({
        'timpBlocat': {'$date': 'full'}
      }, SetOptions(merge: true));
    }
  }

  Widget pickHourSpecialist(
      String placeId,
      String date,
      String category,
      String specialistServiciu,
      String durataServiciu,
      Map<String, dynamic> timpBlocat) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc('Categories')
            .collection(category)
            .doc(placeId)
            .collection('specialisti')
            .doc(specialistServiciu)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final specialist = snapshot.data;
          Map<dynamic, dynamic> programDinamic = specialist['programDinamic'];
          List<dynamic> programRezervari = specialist['program'];
          List<dynamic> hours;
          if (programDinamic.containsKey(date) == true) {
            hours = programDinamic[date];
          } else {
            hours = programRezervari;
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hours.length,
              itemBuilder: (ctx, i) {
                // if (hours.length == 1) {
                //   lastReservationPerDay = true;
                // }
                if (hours[i] == '') {
                  return Container();
                } else {
                  if (_date.day != DateTime.now().day) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          ora = hours[i];
                        });
                      },
                      child: Text(hours[i]),
                    );
                  } else {
                    TimeOfDay hour = TimeOfDay(
                        hour: int.parse(hours[i].split(":")[0]),
                        minute: int.parse(hours[i].split(":")[1]));
                    if (hour.hour > DateTime.now().hour ||
                        (hour.hour == DateTime.now().hour &&
                            hour.minute > DateTime.now().minute)) {
                      return TextButton(
                        onPressed: () {
                          setState(() {
                            ora = hours[i];
                          });
                        },
                        child: Text(hours[i]),
                      );
                    } else {
                      return Container();
                    }
                  }
                }
              });
        });
  }
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

  String getTimeText() {
    if (_time == null) {
      return 'Selecteaza ora';
    } else {
      final ora = _time.hour.toString().padLeft(2, '0');
      final minute = _time.minute.toString().padLeft(2, '0');
      return "$ora:$minute";
    }
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

  void addOrUpdateMapField(
      String documentId, String newKey, List<String> newValues) async {
    // Referința către document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('colectia_ta').doc(documentId);

    // Creează un map cu noua cheie și valorile asociate
    Map<String, dynamic> newMap = {newKey: newValues};

    // Actualizează documentul folosind merge: true pentru a păstra valorile existente
    await docRef.set({'mapField': newMap}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as ReservationArguments;
    final String _uid = FirebaseAuth.instance.currentUser.uid;
    bool dynamicScheduleExist;
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
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('places')
                              .doc('Categories')
                              .collection(args.category)
                              .doc(args.placeId)
                              .collection('specialisti')
                              .doc(args.specialist)
                              .snapshots(),
                          builder: (context, specialistSnapshot) {
                            if (specialistSnapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !specialistSnapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final specialist = specialistSnapshot.data;
                            if (specialist['programDinamic'].length != 0) {
                              dynamicScheduleExist = true;
                            } else {
                              dynamicScheduleExist = false;
                            }

                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('places')
                                    .doc('Categories')
                                    .collection(args.category)
                                    .doc(args.placeId)
                                    .collection('specialisti')
                                    .doc(args.specialist)
                                    .collection('reservations')
                                    .snapshots(),
                                builder:
                                    (context, specialistReservationsSnapshot) {
                                  if (specialistReservationsSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting ||
                                      !specialistReservationsSnapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final reservations =
                                      specialistReservationsSnapshot.data.docs;
                                  return SafeArea(
                                    child: Form(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const BackButton(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 15,
                                                top: 10,
                                              ),
                                              child: Text(
                                                'Rezervarea ta cu specialist la ${document['title']}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Serviciu : ${args.serviceTitle}",
                                                    style: TextStyle(
                                                        fontSize: 18.5,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.person),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                            "Specialist : ${args.specialist}",
                                                            style: TextStyle(
                                                                fontSize: 18.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
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
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Icon(Icons.timer),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(ora),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 50,
                                              child: Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    _date != null
                                                        ? Expanded(
                                                            child: pickHourSpecialist(
                                                                args.placeId,
                                                                '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                                args.category,
                                                                args.specialist,
                                                                args.durataServiciu,
                                                                args.zileBlocate),
                                                          )
                                                        : Text(
                                                            "Selecteaza data pentru a verifica disponibilitatea orelor!",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          )
                                                  ]),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Persoana de contact :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "$_firstName $_lastName",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Numar de telefon :",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "$_phone",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('places')
                                                        .doc("Categories")
                                                        .collection(
                                                            args.category)
                                                        .doc(args.placeId)
                                                        .collection(
                                                            "specialisti")
                                                        .doc(args.specialist)
                                                        .collection(
                                                            'reservations')
                                                        .add({
                                                      'category':
                                                          '${document['category']}',
                                                      'title':
                                                          '${document['title']}',
                                                      'time': ora,
                                                      'date':
                                                          '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                      'imageUrl':
                                                          '${document['imageUrl']}',
                                                      'email': '$_email',
                                                      'durata':
                                                          args.durataServiciu,
                                                      'specialist':
                                                          args.specialist,
                                                      'service':
                                                          args.serviceTitle,
                                                      'name':
                                                          '$_firstName $_lastName',
                                                      'placeId':
                                                          '${args.placeId}',
                                                      'status': 'In asteptare',
                                                      'phone': _phone,
                                                      'profileUID': FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          .uid,
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection('profiles')
                                                        .doc(_uid)
                                                        .collection(
                                                            'reservations')
                                                        .add({
                                                      'category':
                                                          '${document['category']}',
                                                      'title':
                                                          '${document['title']}',
                                                      'time': ora,
                                                      'date':
                                                          '${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}',
                                                      'imageUrl':
                                                          '${document['imageUrl']}',
                                                      'email': '$_email',
                                                      'durata':
                                                          args.durataServiciu,
                                                      'specialist':
                                                          args.specialist,
                                                      'service':
                                                          args.serviceTitle,
                                                      'name':
                                                          '$_firstName $_lastName',
                                                      'placeId':
                                                          '${args.placeId}',
                                                      'status': 'In asteptare',
                                                      'phone': _phone,
                                                      'profileUID': FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          .uid,
                                                    });
                                                    if (lastReservationPerDay ==
                                                        true) {
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
                                                      });
                                                    }
                                                    print(
                                                        'folosim update dinamic');
                                                    updateDynamicSchedule(
                                                      args.category,
                                                      args.placeId,
                                                      args.specialist,
                                                      "${_date.day.toString()} ${getMonthByName(_date.month)} ${_date.year.toString()}",
                                                      ora,
                                                      args.durataServiciu,
                                                      specialist,
                                                      reservations,
                                                      dynamicScheduleExist,
                                                    );

                                                    print(
                                                        'am folosit update dinamic');
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            ReservationsScreen
                                                                .routeName,
                                                            arguments: document[
                                                                'category']);
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
                          });
                    });
              })),
    );
  }
}
