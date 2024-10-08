import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// ignore: must_be_immutable
class ProgramWidget extends StatelessWidget {
  var program;
  bool eveniment;
  ProgramWidget(this.program, this.eveniment);

  Widget build(BuildContext context) {
    return eveniment == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesome.clock_o,
                    size: 13,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Program :",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(children: [
                Text('Luni :'),
                Spacer(),
                program['Luni']['Open'] as String != 'Inchis'
                    ? Text(
                        '${program['Luni']['Open'] as String} - ${program['Luni']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Marți :'),
                Spacer(),
                program['Marti']['Open'] as String != 'Inchis'
                    ? Text(
                        '${program['Marti']['Open'] as String} - ${program['Marti']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Miercuri :'),
                Spacer(),
                program['Miercuri']['Open'] as String != 'Inchis'
                    ? Text(
                        '${program['Miercuri']['Open'] as String} - ${program['Miercuri']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Joi :'),
                Spacer(),
                program['Joi']['Open'] as String != "Inchis"
                    ? Text(
                        '${program['Joi']['Open'] as String} - ${program['Joi']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Vineri :'),
                Spacer(),
                program['Vineri']['Open'] as String != "Inchis"
                    ? Text(
                        '${program['Vineri']['Open'] as String} - ${program['Vineri']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Sambătă :'),
                Spacer(),
                program['Sambata']['Open'] as String != "Inchis"
                    ? Text(
                        '${program['Sambata']['Open'] as String} - ${program['Sambata']['Close'] as String}')
                    : Text("Inchis")
              ]),
              SizedBox(height: 3),
              Row(children: [
                Text('Duminică :'),
                Spacer(),
                program['Duminica']['Open'] as String != 'Inchis'
                    ? Text(
                        '${program['Duminica']['Open'] as String} - ${program['Duminica']['Close'] as String}')
                    : Text('Inchis')
              ]),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesome.clock_o,
                    size: 13,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Program :",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              program['Luni']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(
                          children: [
                            Text('Luni :'),
                            Spacer(),
                            Text(
                                '${program['Luni']['Open'] as String} - ${program['Luni']['Close'] as String}'),
                          ],
                        ),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Marti']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(children: [
                          Text('Marți :'),
                          Spacer(),
                          Text(
                              '${program['Marti']['Open'] as String} - ${program['Marti']['Close'] as String}'),
                        ]),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Miercuri']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(children: [
                          Text('Miercuri :'),
                          Spacer(),
                          Text(
                              '${program['Miercuri']['Open'] as String} - ${program['Miercuri']['Close'] as String}'),
                        ]),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Joi']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(children: [
                          Text('Joi :'),
                          Spacer(),
                          Text(
                              '${program['Joi']['Open'] as String} - ${program['Joi']['Close'] as String}'),
                        ]),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Vineri']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(children: [
                          Text('Vineri :'),
                          Spacer(),
                          Text(
                              '${program['Vineri']['Open'] as String} - ${program['Vineri']['Close'] as String}'),
                        ]),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Sambata']['Open'] == 'Inchis'
                  ? Container()
                  : Column(
                      children: [
                        Row(children: [
                          Text('Sambătă :'),
                          Spacer(),
                          Text(
                              '${program['Sambata']['Open'] as String} - ${program['Sambata']['Close'] as String}'),
                        ]),
                        SizedBox(height: 3),
                      ],
                    ),
              program['Duminica']['Open'] == 'Inchis'
                  ? Container()
                  : Row(children: [
                      Text('Duminică :'),
                      Spacer(),
                      Text(
                          '${program['Duminica']['Open'] as String} - ${program['Duminica']['Close'] as String}'),
                    ]),
            ],
          );
  }
}
