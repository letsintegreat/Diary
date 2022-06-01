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
    diaryEntry.timeStamp = m['timeStamp'];
    return diaryEntry;
  }

  Map<String, dynamic> toJson() {
    return {
      'entry': entry,
      'timeStamp': timeStamp,
    };
  }
}