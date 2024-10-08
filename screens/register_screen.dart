import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key key}) : super(key: key);
  static const routeName = '/RegisterScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo marit.png',
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
                    decoration: InputDecoration(
                        hintText: 'Nume :',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        icon: Icon(Icons.person),
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
                    decoration: InputDecoration(
                        hintText: 'Prenume :',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        icon: Icon(Icons.person),
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
                    decoration: InputDecoration(
                        hintText: 'Telefon :',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        icon: Icon(Icons.phone),
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
                    decoration: InputDecoration(
                        hintText: 'Parola :',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        icon: Icon(Icons.password_rounded),
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(25)),
                child: TextButton(
                  onPressed: () {},
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
        ),
      ),
    );
  }
}
