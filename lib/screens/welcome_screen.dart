import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moodqu_app/screens/home_screen.dart';
import 'package:moodqu_app/screens/login_screen.dart';
import 'package:moodqu_app/screens/registration_screen.dart';
import 'package:moodqu_app/size_config.dart';
import 'package:moodqu_app/widgets/normal_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String _UID;

  void goTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  String getUserID() {
    final User user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "";
  }

  void checkLoggedIn() async {
    bool filledInfo = false;

    if (_UID != "") {
      print('uid saat ini: $_UID sebelum masuk db.');
      await db
          .collection("personalInfo")
          .where("uid", isEqualTo: _UID)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          filledInfo = true;
        });
      });
      if (filledInfo) {
        goTo(HomeScreen());
      } else {
        goTo(RegistrationScreen());
      }
    }
  }

  @override
  void initState() {
    _UID = getUserID();
    checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image(
                    image: AssetImage(
                      'assets/images/hero.png',
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 4,
                  ),
                  NormalButton(
                    color: Colors.lightBlueAccent,
                    text: 'LOG IN',
                    onPressed: () {
                      goTo(LoginScreen());
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  NormalButton(
                    color: Colors.blueAccent,
                    text: 'REGISTER',
                    onPressed: () {
                      goTo(RegistrationScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
