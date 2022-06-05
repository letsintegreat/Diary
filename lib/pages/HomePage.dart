import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/models/DiaryUser.dart';
import 'package:diary/models/DiaryEntry.dart';
import 'package:diary/pages/NewEntryPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Personal Diary",
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
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NewEntryPage(diaryUser: diaryUser)));
                },
                icon: FaIcon(
                  FontAwesomeIcons.plus,
                  size: 17,
                ));
          }),
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 17,
                ));
          }),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                  color: Color(0xFF4b39ba), size: 50),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            diaryUser = DiaryUser.fromJson(data);
            return Builder(builder: (context) {
              diaryUser.entries.sort((a, b) {
                if (a.timeStamp.split("-")[2] == b.timeStamp.split("-")[2]) {
                  if (a.timeStamp.split("-")[1] == b.timeStamp.split("-")[1]) {
                    return b.timeStamp
                        .split("-")[0]
                        .compareTo(a.timeStamp.split("-")[0]);
                  } else {
                    return b.timeStamp
                        .split("-")[1]
                        .compareTo(a.timeStamp.split("-")[1]);
                  }
                } else {
                  return b.timeStamp
                      .split("-")[2]
                      .compareTo(a.timeStamp.split("-")[2]);
                }
              });
              Map<String, List<DiaryEntry>> m = {};
              for (var entry in diaryUser.entries) {
                String monthAndYear =
                    entry.timeStamp.split("-").sublist(1).join("-");
                if (!m.containsKey(monthAndYear)) {
                  m[monthAndYear] = [];
                }
                m[monthAndYear]!.add(entry);
              }
              print(m);
              return SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Container(
                    child: ListView(
                      children: m.keys.toList().map((String k) {
                        print(k);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 16),
                                      child: MySeparator(),
                                    )),
                                    Text(
                                      getTitleFromTimeStamp(k),
                                      style: GoogleFonts.sourceSansPro(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 16),
                                      child: MySeparator(),
                                    )),
                                  ],
                                ),
                              ),
                              Column(
                                children: m[k]!.map((DiaryEntry diaryEntry) {
                                  String dateAlone =
                                      diaryEntry.timeStamp.split("-")[0];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 16, 8, 0),
                                    child: Material(
                                      elevation: 5,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(70))),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: EntryDetailPage(
                                                      diaryUser: diaryUser,
                                                      diaryEntry: diaryEntry),
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment:
                                                      Alignment.center,
                                                  duration:
                                                      Duration(seconds: 1)));
                                        },
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color(0xFF4b39ba)),
                                          child: Row(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            Color(0xFF988DDC)),
                                                    child: Center(
                                                      child: Text(
                                                        (dateAlone[0] == "0")
                                                            ? dateAlone[1]
                                                            : dateAlone,
                                                        style: GoogleFonts
                                                            .sourceSansPro(
                                                                color: Color(
                                                                    0xFF4b39ba),
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 0, 10.0, 0),
                                                child: Text(
                                                  diaryEntry.entry
                                                      .split("\n")
                                                      .join(" "),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Text("Something went wrong.");
          }
        },
      ),
    );
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
    int mon = int.parse(args[0]);
    return "${months[mon - 1]}, ${args[1]}";
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.white})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
