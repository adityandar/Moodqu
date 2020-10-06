import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String UID;
  List<String> history = [];

  String getUserID() {
    final User user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "";
  }

  void getAllHistory() async {
    await db
        .collection("diaries")
        .where('uid', isEqualTo: UID)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        history.add(result.data()['text']);
      });
    });
  }

  @override
  void initState() {
    UID = getUserID();
    getAllHistory();
    print(history);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
