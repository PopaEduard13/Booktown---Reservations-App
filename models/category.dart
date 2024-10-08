import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/my_flutter_app_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';

import './type_enum.dart';

class Category {
  final int id;
  final String title;
  final Icon icon;
  final Type type;

  const Category({
    @required this.id,
    @required this.title,
    @required this.icon,
    @required this.type,
  });
}

final List<Category> categories = [
  Category(
    id: 1,
    title: 'Restaurante',
    icon: Icon(Icons.restaurant_outlined),
    type: Type.Restaurant,
  ),
  Category(
    id: 2,
    title: 'Cafenele',
    icon: Icon(Icons.local_cafe_outlined),
    type: Type.Cafenea,
  ),
  Category(
    id: 3,
    title: 'Saloane',
    icon: Icon(Icons.cut_outlined),
    type: Type.Salon,
  ),
  Category(
    id: 4,
    title: 'Cazări',
    icon: Icon(Icons.apartment),
    type: Type.Cazare,
  ),
  Category(
    id: 6,
    title: 'Evenimente',
    icon: Icon(Icons.event_available_rounded),
    type: Type.Eveniment,
  ),
  Category(
    id: 7,
    title: 'Sport & Fun',
    icon: Icon(AntDesign.dribbble),
    type: Type.Sport,
  ),
  Category(
    id: 8,
    title: 'Medici',
    icon: Icon(Icons.medical_services_rounded),
    type: Type.Cabinet,
  ),
  Category(
    id: 10,
    title: 'Dentisti',
    icon: Icon(
      MaterialCommunityIcons.tooth,
      color: Colors.greenAccent,
    ),
    type: Type.Cabinet,
  ),
  Category(
    id: 11,
    title: 'Pediatrii',
    icon: Icon(FontAwesome.child),
    type: Type.Cabinet,
  ),
  Category(
    id: 12,
    title: 'Oftalmologi',
    icon: Icon(FontAwesome.eye),
    type: Type.Cabinet,
  ),
  Category(
    id: 13,
    title: 'Clinici',
    icon: Icon(FontAwesome.hospital_o),
    type: Type.Cabinet,
  ),
  Category(
    id: 20,
    title: 'Barber',
    icon: Icon(MyFlutterApp.barber),
    type: Type.Salon,
  ),
  Category(
    id: 21,
    title: 'Coafor',
    icon: Icon(MyFlutterApp.makeover),
    type: Type.Salon,
  ),
  Category(
    id: 22,
    title: 'Spa & Relax',
    icon: Icon(MyFlutterApp.massage),
    type: Type.Salon,
  ),
  Category(
    id: 23,
    title: 'Unghii & Makeup',
    icon: Icon(MyFlutterApp.nail_polish),
    type: Type.Salon,
  ),
];

const Categories_above = const {
  Category(
    id: 1,
    title: 'Restaurante',
    icon: Icon(Icons.restaurant_outlined),
    type: Type.Restaurant,
  ),
  Category(
    id: 2,
    title: 'Cafenele',
    icon: Icon(Icons.local_cafe_rounded),
    type: Type.Cafenea,
  ),
  Category(
    id: 3,
    title: 'Saloane',
    icon: Icon(Icons.cut),
    type: Type.Salon,
  ),
};

const Categories_under = const {
  Category(
    id: 6,
    title: 'Evenimente',
    icon: Icon(Icons.event_available_rounded),
    type: Type.Eveniment,
  ),
  Category(
    id: 7,
    title: 'Sport & Fun',
    icon: Icon(Icons.sports_volleyball),
    type: Type.Sport,
  ),
  Category(
    id: 8,
    title: 'Medici',
    icon: Icon(Icons.medical_services_rounded),
    type: Type.Cabinet,
  ),
};
