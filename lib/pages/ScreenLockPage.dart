import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';

import 'HomePage.dart';

class ScreenLockPage extends StatefulWidget {
  const ScreenLockPage({Key? key}) : super(key: key);

  @override
  _ScreenLockPage createState() => _ScreenLockPage();
}

class _ScreenLockPage extends State<ScreenLockPage> {
  BuildContext? _context;
  bool _hasAttemptedAuth = false;

  Future<void> localAuth(BuildContext context) async {
    final localAuth = LocalAuthentication();
    if (await localAuth.isDeviceSupported()) {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate',
        options: AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        setState(() {
          _hasAttemptedAuth = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Set up a Screen Lock to secure your Personal Diary.",
            style: GoogleFonts.sourceSansPro(),
          ),
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((timeStamp) => localAuth(_context!));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF988DDC),
        primaryColor: Color(0xFF4b39ba),
      ),
      title: "Diary",
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Builder(builder: (context) {
            _context = context;
            return Text(
              "Authenticate yourself",
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold, fontSize: 22),
            );
          })),
          toolbarHeight: 70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF4b39ba),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 50, 8, 32),
                child: Image.asset(
                  "assets/waiting.png",
                  height: 180,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Center(
                  child: Text(
                    _hasAttemptedAuth
                        ? "You can't access the Diary without the Screen Lock :("
                        : "Waiting for you to authenticate.",
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _hasAttemptedAuth
                  ? Container(
                      width: double.infinity,
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                            onPressed: () => localAuth(context),
                            child: Text(
                              "Try Again",
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
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }
}
