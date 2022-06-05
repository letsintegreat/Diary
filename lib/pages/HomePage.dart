import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DairyUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:diary/pages/NewEntryPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'EntryDetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  final Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  DiaryUser diaryUser = DiaryUser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF988DDC),
        primaryColor: Color(0xFF4b39ba),
      ),
      title: "Dairy",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
          backgroundColor: Color(0xFF4b39ba),
          actions: <Widget>[
            Builder(builder: (context) {
              return PopupMenuButton<String>(onSelected: (s) {
                if (s == 'Logout') {
                  FirebaseAuth.instance.signOut();
                } else if (s == 'Add a new Entry') {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NewEntryPage(diaryUser: diaryUser)));
                }
              }, itemBuilder: (BuildContext context) {
                return {"Logout", "Add a new Entry"}.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              });
            })
          ],
        ),
        body: Center(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _userStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                diaryUser = DiaryUser.fromJson(data);
                return Builder(builder: (context) {
                  return ListView(
                    children: diaryUser.entries.map((DiaryEntry diaryEntry) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EntryDetailPage(
                                  diaryUser: diaryUser,
                                  diaryEntry: diaryEntry)));
                        },
                        title: Text(diaryEntry.timeStamp),
                        subtitle: Text(diaryEntry.entry),
                      );
                    }).toList(),
                  );
                });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Text("Something went wrong.");
              }
            },
          ),
        ),
      ),
    );
  }
}
