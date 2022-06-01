import 'package:diary/models/DairyUser.dart';
import 'package:diary/pages/AuthPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String _nameError = "";
  String _emailError = "";
  String _passwordError = "";
  String _confirmError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                onChanged: (v) {
                  setState(() {
                    _nameError = "";
                  });
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Name",
                  errorText: _nameError == "" ? null : _nameError,
                ),
              ),
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
              TextField(
                controller: _confirmController,
                onChanged: (v) {
                  setState(() {
                    _confirmError = "";
                  });
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  errorText: _confirmError == "" ? null : _confirmError,
                ),
              ),
              Builder(
                builder: (context) {
                  return TextButton(
                      onPressed: () => login(context), child: Text("Have an account? Login"));
                }
              ),
              ElevatedButton(onPressed: submit, child: Text("SUBMIT"))
            ],
          ),
        ),
      );
  }

  void login(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthPage()));
  }

  Future<void> submit() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirm = _confirmController.text;
    if (name.isEmpty) {
      setState(() {
        _nameError = "Name is required.";
      });
      return;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      setState(() {
        _emailError = "Invalid email.";
      });
      return;
    }
    if (password != confirm) {
      setState(() {
        _confirmError = "Passwords don't match.";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
      DiaryUser diaryUser = DiaryUser.getInstance(name: name);
      usersCollection.doc(firebaseUser.uid).set(diaryUser.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        setState(() {
          _passwordError = "Password too weak.";
        });
      } else if (e.code == "email-already-in-use") {
        setState(() {
          _emailError = "Email is already in use, try logging in?";
        });
      }
    } catch (e) {
      print(e);
    }
  }

}
