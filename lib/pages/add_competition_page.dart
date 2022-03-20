import 'package:bno/pages/competition_page.dart';
import 'package:bno/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';

class AddCompetitionPage extends StatefulWidget {
  AddCompetitionPage({Key key}) : super(key: key);

  @override
  _AddCompetitionPageState createState() => _AddCompetitionPageState();
}

class _AddCompetitionPageState extends State<AddCompetitionPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController timeMinController = TextEditingController();
  final TextEditingController timeSecController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final _key = GlobalKey<FormState>();

  void create() async {
    var document = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).collection("competitions").add({
      "name": nameController.text,
      "distance": double.parse(distanceController.text),
      "timeMin": double.parse(timeMinController.text),
      "timeSec": double.parse(timeSecController.text),
      "type": typeController.text,
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CompetitionPage(document.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj zawody"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nazwa zawodów",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: distanceController,
                      decoration: InputDecoration(
                        labelText: "Dystans",
                        suffixText: "km",
                        icon: Icon(Icons.local_movies_rounded),
                      ),
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: timeMinController,
                        decoration: InputDecoration(
                          labelText: "min",
                          icon: Icon(Icons.timer),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Text(" : "),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: timeSecController,
                        decoration: InputDecoration(
                          labelText: "sec",
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: "Data",
                      icon: Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: "Typ biegu",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      print('Mape dodano');
                    },
                    child: Text("Dodaj mape"),
                    color: Colors.orange[300],
                    textColor: Colors.white,
                    splashColor: Colors.orange[600],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: create,
                    child: Text("Zapisz"),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
