import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DairyUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:diary/pages/EditDetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EntryDetailPage extends StatelessWidget {
  DiaryUser diaryUser;
  DiaryEntry diaryEntry;
  EntryDetailPage({Key? key, required this.diaryUser, required this.diaryEntry})
      : super(key: key);

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        diaryUser.entries.removeWhere(
            (element) => element.timeStamp == diaryEntry.timeStamp);
        User firebaseUser = FirebaseAuth.instance.currentUser!;
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection("users");
        usersCollection.doc(firebaseUser.uid).set(diaryUser.toJson());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Deleted ${diaryEntry.getTitleFromTimeStamp()}")));
        Navigator.popUntil(context, ModalRoute.withName("/"));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Caution"),
      content: Text(
          "Are you sure you want to delete ${diaryEntry.getTitleFromTimeStamp()} entry?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diaryEntry.getTitleFromTimeStamp()),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return PopupMenuButton<String>(onSelected: (s) {
                if (s == "Edit") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditDetailPage(
                          diaryUser: diaryUser, diaryEntry: diaryEntry)));
                } else if (s == "Delete") {
                  showAlertDialog(context);
                }
              }, itemBuilder: (BuildContext context) {
                return {"Edit", "Delete"}.map((String choice) {
                  return PopupMenuItem(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              });
            },
          )
        ],
      ),
      body: Center(
        child: Text(diaryEntry.entry),
      ),
    );
  }
}
