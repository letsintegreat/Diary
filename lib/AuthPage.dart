import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);
  @override
  _AuthPage createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _emailError = "";
  final String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dairy",
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login'
          ),
        ),
        body: Center(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
