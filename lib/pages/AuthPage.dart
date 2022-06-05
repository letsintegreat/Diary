import 'package:diary/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF988DDC)),
      home: Scaffold(
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
                      "Hi again!",
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
                  height: (MediaQuery.of(context).size.height - 720 > 0)
                      ? MediaQuery.of(context).size.height - 720
                      : 50,
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
                    child: Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: submit,
                        child: Text(
                          "Log In",
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
                        onPressed: () => register(context),
                        child: Text(
                          "Create an Account",
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
