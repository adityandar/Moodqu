import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moodqu_app/screens/history_screen.dart';
import 'package:moodqu_app/screens/loading_screen.dart';
import 'package:moodqu_app/size_config.dart';
import 'package:moodqu_app/emotion_icons.dart';
import 'package:moodqu_app/widgets/mood_card.dart';
import 'package:moodqu_app/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String firstName = "";
  String time;
  List data;

  void getFirstName() {
    final User user = auth.currentUser;
    if (user != null) {
      if (user.uid != "") {
        db
            .collection("personalInfo")
            .where("uid", isEqualTo: user.uid)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            setState(() {
              firstName = result.data()['name'].split(' ')[0];
            });
          });
        });
      }
    }
  }

  String getTime() {
    String convertedDateTime = "${DateTime.now().hour.toString()}";
    int now = int.parse(convertedDateTime);
    if (now >= 18) {
      return 'evening';
    } else if (now >= 11) {
      return 'afternoon';
    } else if (now >= 1) {
      return 'morning';
    }
    return 'day';
  }

  @override
  void initState() {
    time = getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    getFirstName();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 3,
                horizontal: SizeConfig.blockSizeHorizontal * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.person,
                          size: SizeConfig.blockSizeHorizontal * 10,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.power_settings_new,
                          size: SizeConfig.blockSizeHorizontal * 10,
                        ),
                        onTap: () {
                          auth.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoadingScreen()),
                            (Route<dynamic> route) => false,
                          );
                          print('test');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      NeumorphicText(
                        'Hello $firstName!',
                        textStyle: NeumorphicTextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 11.3,
                          fontWeight: FontWeight.w700,
                        ),
                        style: kHeadlineStyle,
                      ),
                      Text(
                        'How are you this $time?',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //happiness, sadness, fear
                          // yellow, cyanAccent, deepPurpleAccent
                          MoodCard(
                            color: Colors.yellow,
                            icon: EmotionIcons.happy,
                            id: Mood.happy,
                          ),
                          MoodCard(
                            color: Colors.cyanAccent,
                            icon: EmotionIcons.sad,
                            id: Mood.sad,
                          ),
                          MoodCard(
                            color: Colors.deepPurpleAccent,
                            icon: EmotionIcons.fear,
                            id: Mood.fear,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //moodcards goes here.
                          //disgust, anger, surprise
                          //lightGreen, red, orange
                          MoodCard(
                            color: Colors.lightGreen,
                            icon: EmotionIcons.disgust,
                            id: Mood.disgust,
                          ),
                          MoodCard(
                            color: Colors.red,
                            icon: EmotionIcons.anger,
                            id: Mood.anger,
                          ),
                          MoodCard(
                            color: Colors.orange,
                            icon: EmotionIcons.surprise,
                            id: Mood.surprise,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 10,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
