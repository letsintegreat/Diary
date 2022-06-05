import 'package:diary/pages/ScreenLockPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/AuthPage.dart';
import 'pages/HomePage.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    if (auth.currentUser != null) {
      auth.currentUser!.reload();
    }
  } on Exception catch (e) {
    print(e.toString());
  }
  auth.authStateChanges().listen((User? user) {
    if (auth.currentUser == null || user == null) {
      runApp(const AuthPage());
    } else {
      runApp(ScreenLockPage());
    }
  });
}