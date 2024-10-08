import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/reservations_screen.dart';

class YourReservationScreen extends StatefulWidget {
  const YourReservationScreen({Key key}) : super(key: key);

  static const routeName = '/yourReservationScreen';

  @override
  State<YourReservationScreen> createState() => _YourReservationScreenState();
}

class _YourReservationScreenState extends State<YourReservationScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context).settings.arguments as YourReservationArguments;
    print(args.date);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: height - height / 1.15),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: Text(
                  "Rezervarea ta la ${args.place}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 45,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: height - height / 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 25.0),
              child: Row(
                children: [
                  Text(
                    'Numar de persoane : ${args.nrPersOrService}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height - height / 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  Text(
                    'Data : ${args.date}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height - height / 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  Text(
                    'Ora : ${args.hour}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height - height / 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  Text(
                    'Persoana de contact : ${args.contactPerson}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height - height / 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.orange),
                      height: 100,
                      width: 150,
                      child: Center(
                        child: Text(
                          "Cheama un chelner",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue),
                      height: 100,
                      width: 150,
                      child: Center(
                        child: Text(
                          "Cere nota",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
