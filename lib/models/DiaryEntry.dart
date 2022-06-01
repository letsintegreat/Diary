import 'package:flutter/material.dart';

class DiaryEntry {
  DateTime date = DateTime.now();
  String timeStamp = "";
  String entry = "";

  void changeDate(DateTime d) {
    date = d;
    setStringTimeStamp(d);
  }

  void setStringTimeStamp(DateTime d) {
    List<String> args = "${d.toLocal()}".split(' ')[0].split("-");
    timeStamp = "${args[2]}-${args[1]}-${args[0]}";
  }

  static DiaryEntry getInstance({required DateTime date, required String entry}) {
    DiaryEntry diaryEntry = DiaryEntry();
    diaryEntry.changeDate(date);
    diaryEntry.entry = entry;
    return diaryEntry;
  }

  static DiaryEntry fromJson(Map<String, dynamic> m) {
    DiaryEntry diaryEntry = DiaryEntry();
    diaryEntry.entry = m['entry'];
    List<String> args = m['timeStamp'].split("-");
    String helperDate = "${args[2]}-${args[1]}-${args[0]} 00:00:00.000";
    DateTime d = DateTime.parse(helperDate);
    diaryEntry.changeDate(d);
    return diaryEntry;
  }

  Map<String, dynamic> toJson() {
    return {
      'entry': entry,
      'timeStamp': timeStamp,
    };
  }

  String getTitleFromTimeStamp() {
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