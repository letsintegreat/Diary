import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: Text("Edit ${widget.diaryEntry.getTitleFromTimeStamp()}"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _entryController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (v) {
              setState(() {
                _entryError = "";
              });
            },
            decoration: InputDecoration(
              labelText: "Dairy entry",
              errorText: _entryError == "" ? null : _entryError,
            ),
          ),
          Builder(builder: (context) {
            return ElevatedButton(
                onPressed: () => submit(context), child: Text("SUBMIT"));
          }),
        ],
      ),
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
