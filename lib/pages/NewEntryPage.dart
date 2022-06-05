import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DairyUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    DateTime proposedDate = DateTime.now();
    List<String> args = "${proposedDate.toLocal()}".split(' ')[0].split("-");
    String t = "${args[2]}-${args[1]}-${args[0]}";
    while (widget.diaryUser.entries.any((item) => item.timeStamp == t)) {
      proposedDate = proposedDate.add(const Duration(days: -1));
      args = "${proposedDate.toLocal()}".split(' ')[0].split("-");
      t = "${args[2]}-${args[1]}-${args[0]}";
    }
    setState(() {
      selectedDate = proposedDate;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            child: child!,
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: Color(0xFF4b39ba),
              onPrimary: Colors.white,
            )),
          );
        },
        selectableDayPredicate: (DateTime val) {
          List<String> args = "${val.toLocal()}".split(' ')[0].split("-");
          String t = "${args[2]}-${args[1]}-${args[0]}";
          bool alreadyEntered = widget.diaryUser.entries.any((item) => item.timeStamp == t);
          bool future = DateTime.now().compareTo(val) < 0;
          return !(alreadyEntered || future);
        },
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
        title: Center(
            child: Text(
          "New Entry",
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: ListView(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    getTitleFromTimeStamp(dateInString),
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Builder(builder: (context) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 32, 16),
                      child: Container(
                        height: 50,
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              "Change date",
                              style: GoogleFonts.sourceSansPro(
                                  fontSize: 15, letterSpacing: .3),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor: Colors.transparent,
                              primary: Color(0xFFbab3e8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ],
            ),
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
          ],
        ),
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

  String getTitleFromTimeStamp(String timeStamp) {
    List<String> args = timeStamp.split("-");
    List<String> months = [
      "Jan",
      "Feb",
      "March",
      "Apr",
      "May",
      "June",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    int mon = int.parse(args[1]);
    return "${args[0]} ${months[mon - 1]} ${args[2]}";
  }
}
