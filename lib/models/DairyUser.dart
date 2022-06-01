import 'DiaryEntry.dart';

class DiaryUser {
  String name = "";
  List<DiaryEntry> entries = [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> m = <String, dynamic>{};
    m['name'] = name;
    List<Map<String, dynamic>> en = [];
    entries.forEach((element) {
      en.add(element.toJson());
    });
    m['entries'] = en;
    return m;
  }

  static DiaryUser fromJson(Map<String, dynamic> m) {
    DiaryUser diaryUser = DiaryUser();
    diaryUser.name = m['name'];
    for (Map<String, dynamic> m1 in m['entries']) {
      diaryUser.entries.add(
        DiaryEntry.fromJson(m1)
      );
    }
    return diaryUser;
  }

  static DiaryUser getInstance({required String name}) {
    DiaryUser diaryUser = DiaryUser();
    diaryUser.name = name;
    return diaryUser;
  }
}