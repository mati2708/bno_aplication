import 'package:bno/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  void signIn() async {
    if (_key.currentState.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } on FirebaseAuthException catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejestracja"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Adres email"),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: "Hasło"),
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed: signIn,
                    child: Text("Dodaj konto"),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
