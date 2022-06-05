import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/DairyUser.dart';

class EditDetailPage extends StatefulWidget {
  DiaryUser diaryUser;
  DiaryEntry diaryEntry;
  EditDetailPage({Key? key, required this.diaryUser, required this.diaryEntry})
      : super(key: key);

  @override
  _EditDetailPage createState() => _EditDetailPage();
}

class _EditDetailPage extends State<EditDetailPage> {
  TextEditingController _entryController = TextEditingController();
  String _entryError = "";

  @override
  void initState() {
    super.initState();
    _entryController = TextEditingController(text: widget.diaryEntry.entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Edit: ${widget.diaryEntry.getTitleFromTimeStamp()}",
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
      ),
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 100),
            child: Material(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Color(0xFF4b39ba),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: TextField(
                    controller: _entryController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (v) {
                      setState(() {
                        _entryError = "";
                      });
                    },
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelText: "Dairy entry...",
                        errorText: _entryError == "" ? null : _entryError,
                        labelStyle: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: FloatingActionButton(
            backgroundColor: Color(0xFF4b39ba),
            child: FaIcon(FontAwesomeIcons.check),
            onPressed: () => submit(context),
          ),
        );
      }),
    );
  }

  void submit(BuildContext context) {
    String entry = _entryController.text.trim();
    if (entry.isEmpty) {
      setState(() {
        _entryError = "Entry is required.";
      });
      return;
    }
    widget.diaryUser.entries.removeWhere(
        (element) => element.timeStamp == widget.diaryEntry.timeStamp);
    DiaryEntry newEntry =
        DiaryEntry.getInstance(date: widget.diaryEntry.date, entry: entry);
    widget.diaryUser.entries.add(newEntry);
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection("users");
    usersCollection.doc(firebaseUser.uid).set(widget.diaryUser.toJson());
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
}
