import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DairyUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:diary/pages/EditDetailPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

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
        title: Center(
            child: Text(
          "Entry: ${diaryEntry.getTitleFromTimeStamp()}",
          style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold, fontSize: 22),
        )),
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Color(0xFF4b39ba),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return PopupMenuButton<String>(onSelected: (s) {
                if (s == "Delete") {
                  showAlertDialog(context);
                }
              }, itemBuilder: (BuildContext context) {
                return {"Delete"}.map((String choice) {
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 120),
        child: Material(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: Color(0xFF4b39ba),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                      child: Text(
                        "Diary Entry...",
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Text(
                            diaryEntry.entry,
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton(
            backgroundColor: Color(0xFF4b39ba),
            child: FaIcon(
              FontAwesomeIcons.pencil,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: EditDetailPage(
                          diaryUser: diaryUser, diaryEntry: diaryEntry),
                      type: PageTransitionType.bottomToTop));
            },
          ),
        );
      }),
    );
  }
}
