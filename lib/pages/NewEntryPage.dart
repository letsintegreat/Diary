import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DairyUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewEntryPage extends StatefulWidget {
  DiaryUser diaryUser;
  NewEntryPage({Key? key, required this.diaryUser}) : super(key: key);

  @override
  _NewEntryPage createState() => _NewEntryPage();
}

class _NewEntryPage extends State<NewEntryPage> {
  final TextEditingController _entryController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String _entryError = "";
  String dateInString = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void setDateInString() {
    List<String> args = "${selectedDate.toLocal()}".split(' ')[0].split("-");
    setState(() {
      dateInString = "${args[2]}-${args[1]}-${args[0]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    setDateInString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Entry"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateInString),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text("Select date"));
              }),
            ],
          ),
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
        _entryError = "Entry required";
      });
      return;
    }
    DiaryEntry diaryEntry =
        DiaryEntry.getInstance(date: selectedDate, entry: entry);
    widget.diaryUser.entries.add(diaryEntry);
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection("users");
    usersCollection.doc(firebaseUser.uid).set(widget.diaryUser.toJson());
    Navigator.of(context).pop();
  }
}
