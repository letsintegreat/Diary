import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  User firebaseUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dairy",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
          actions: <Widget>[
            PopupMenuButton<String>(onSelected: (s) {
              if (s == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            }, itemBuilder: (BuildContext context) {
              return {"Logout"}.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            })
          ],
        ),
        body: Center(
          child: FutureBuilder(
            future: usersRef.doc(firebaseUser.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                String name = data['name'];
                return Text(name);
              } else {
                return Text("Loading");
              }
            },
          ),
        ),
      ),
    );
  }
}
