import 'package:diary/models/DairyUser.dart';
import 'package:diary/pages/AuthPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Builder(builder: (context) {
        return Center(
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(40)),
              Image.asset(
                "assets/diary_illustration.png",
                height: 150,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 4),
                  child: Text(
                    "Hi there!",
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Your Personal Diary",
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 50,
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.user,
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: TextField(
                                controller: _nameController,
                                onChanged: (v) {
                                  setState(() {
                                    _nameError = "";
                                  });
                                },
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.sourceSansPro(),
                                decoration: InputDecoration(
                                  focusColor: Color(0xFF988DDC),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: GoogleFonts.sourceSansPro(
                                      color: Color(0xFF988DDC)),
                                  errorStyle: GoogleFonts.sourceSansPro(),
                                  labelText: "Name",
                                  errorText:
                                      _nameError == "" ? null : _nameError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.userLock,
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: TextField(
                                controller: _emailController,
                                onChanged: (v) {
                                  setState(() {
                                    _emailError = "";
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.sourceSansPro(),
                                decoration: InputDecoration(
                                  focusColor: Color(0xFF988DDC),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: GoogleFonts.sourceSansPro(
                                      color: Color(0xFF988DDC)),
                                  errorStyle: GoogleFonts.sourceSansPro(),
                                  labelText: "Email",
                                  errorText:
                                      _emailError == "" ? null : _emailError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.lock,
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: TextField(
                                controller: _passwordController,
                                onChanged: (v) {
                                  setState(() {
                                    _passwordError = "";
                                  });
                                },
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: GoogleFonts.sourceSansPro(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: GoogleFonts.sourceSansPro(
                                      color: Color(0xFF988DDC)),
                                  errorStyle: GoogleFonts.sourceSansPro(),
                                  labelText: "Password",
                                  errorText: _passwordError == ""
                                      ? null
                                      : _passwordError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.lock,
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: TextField(
                                controller: _confirmController,
                                onChanged: (v) {
                                  setState(() {
                                    _confirmError = "";
                                  });
                                },
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: GoogleFonts.sourceSansPro(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: GoogleFonts.sourceSansPro(
                                      color: Color(0xFF988DDC)),
                                  errorStyle: GoogleFonts.sourceSansPro(),
                                  labelText: "Confirm Password",
                                  errorText: _confirmError == ""
                                      ? null
                                      : _confirmError,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
                  child: Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: submit,
                      child: Text(
                        "Create an Account",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15, letterSpacing: .3),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        primary: Color(0xFF4b39ba),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: MySeparator(),
                  )),
                  Text(
                    "Or",
                    style: GoogleFonts.sourceSansPro(color: Colors.white),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: MySeparator(),
                  )),
                ],
              ),
              Container(
                width: double.infinity,
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
                  child: Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: () => login(context),
                      child: Text(
                        "Log In",
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 15, letterSpacing: .3),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        primary: Color(0xFFbab3e8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void login(BuildContext context) {
    Navigator.of(context)
        .pop();
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
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
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
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection("users");
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

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
