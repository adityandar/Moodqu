import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moodqu_app/size_config.dart';
import 'package:moodqu_app/constants.dart';
import 'package:intl/intl.dart';

class WriteScreen extends StatefulWidget {
  final Mood mood;

  WriteScreen({this.mood});

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final messageTextController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String story;
  String moodString;
  int moodInt;

  void getMoodString() {
    Mood selectedMood = widget.mood;
    if (selectedMood == Mood.happy) {
      moodString = 'happy';
      moodInt = 1;
    } else if (selectedMood == Mood.sad) {
      moodString = 'sad';
      moodInt = 2;
    } else if (selectedMood == Mood.fear) {
      moodString = 'fear';
      moodInt = 3;
    } else if (selectedMood == Mood.disgust) {
      moodString = 'disgust';
      moodInt = 4;
    } else if (selectedMood == Mood.anger) {
      moodString = 'anger';
      moodInt = 5;
    } else if (selectedMood == Mood.surprise) {
      moodString = 'surprise';
      moodInt = 6;
    }
  }

  String getUserID() {
    final User user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "";
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    getMoodString();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(moodString),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Neumorphic(
                      child: TextField(
                        maxLines: 10,
                        controller: messageTextController,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                        ),
                        onChanged: (value) {
                          //Do something with the user input.
                          story = value;
                        },
                      ),
                    ),
                  ),
                ),
                NeumorphicButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    //Implement send functionality.
                  },
                  child: GestureDetector(
                    child: Container(
                      color: Colors.grey,
                      height: SizeConfig.blockSizeVertical * 10,
                      child: Center(
                        child: Text(
                          'SAVE DIARY',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      bool filledDiary = false;
                      String UID = getUserID();
                      String date = getDate();

                      await db
                          .collection("diaries")
                          .where('uid', isEqualTo: UID)
                          .where('date', isEqualTo: date)
                          .get()
                          .then((value) {
                        value.docs.forEach((result) {
                          filledDiary = true;
                        });
                      });

                      if (!filledDiary) {
                        try {
                          await db.collection("diaries").add({
                            'uid': UID,
                            'moodId': moodInt,
                            'text': story,
                            'date': date,
                          });
                        } catch (e) {
                          print(e);
                        }
                        print('Berhasil.');
                      } else {
                        print('Gagal.');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
