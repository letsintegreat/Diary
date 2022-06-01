import 'package:diary/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override
  _AuthPage createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _emailError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dairy",
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                onChanged: (v) {
                  setState(() {
                    _emailError = "";
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: _emailError == "" ? null : _emailError,
                ),
              ),
              TextField(
                controller: _passwordController,
                onChanged: (v) {
                  setState(() {
                    _passwordError = "";
                  });
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError == "" ? null : _passwordError,
                ),
              ),
              Builder(builder: (context) {
                return TextButton(
                    onPressed: () => register(context),
                    child: Text("Don't have an account? Register"));
              }),
              ElevatedButton(onPressed: submit, child: Text("SUBMIT"))
            ],
          ),
        ),
      ),
    );
  }

  void register(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void submit() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        setState(() {
          _emailError = "Couldn't find such an email, try registering?";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _passwordError = "Incorrect password.";
        });
      } else {
        setState(() {
          _emailError = e.code;
        });
      }
    }
  }
}
