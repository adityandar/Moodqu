import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moodqu_app/screens/welcome_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String _errMsg = "";

  void initializeFlutterFire() async {
    int tries = 0;
    do {
      try {
        // Wait for Firebase to initialize and set `_initialized` state to true
        await Firebase.initializeApp();
        print('Initialize completed.');
        tries++;
        _errMsg = "";
      } catch (e) {
        // Set `_error` state to true if Firebase initialization fails
        _errMsg = e;
      }
    } while (_errMsg != "" && tries < 5);
    if (_errMsg == "") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('Failed connecting to server, check your connection.');
    }
    print(_errMsg);
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ModalProgressHUD(
        inAsyncCall: true,
        child: Container(),
      ),
    );
  }
}
