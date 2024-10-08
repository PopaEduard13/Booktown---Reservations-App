import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  static const routeName = '/ContactScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Contact BookTown' , style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Text('Persoana de contact : '),
            title: Text('Popa Eduard'),
          ),
          ListTile(
            leading: Text('Numar de telefon : '),
            title: Text('+40771493871'),
          ),
          ListTile(
            leading: Text('Email :'),
            title: Text('popa_eduard@booktown.ro'),
          ),
        ],
      ),
    );
  }
}
