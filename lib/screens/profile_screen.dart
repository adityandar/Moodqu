import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moodqu_app/screens/home_screen.dart';
import 'package:moodqu_app/widgets/normal_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String _UID;

  List<DropdownMenuItem<int>> _dropDownMenuItems;
  int _currentGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _loading = true;

  String getUserID() {
    final User user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return "";
  }

  void createRecord() async {
    await db.collection("personalInfo").add({
      'uid': _UID,
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'gender': _currentGender,
    });
  }

  void checkFilledInfo() async {
    bool filledInfo;

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
      setState(() {
        _loading = false;
      });
      if (filledInfo) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _UID = getUserID();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFilledInfo();
    });

    DropdownMenuItem<int> _laki = new DropdownMenuItem(
      value: 0,
      child: new Text(
        'Male',
      ),
    );

    DropdownMenuItem<int> _cewe = new DropdownMenuItem(
      value: 1,
      child: new Text(
        'Female',
      ),
    );

    _dropDownMenuItems = [_laki, _cewe];
    _currentGender = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your age.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Text('Gender: '),
                      DropdownButton(
                          value: _currentGender,
                          items: _dropDownMenuItems,
                          onChanged: (int value) {
                            setState(() {
                              _currentGender = value;
                              print(_currentGender);
                            });
                          }),
                    ],
                  ),
                  NormalButton(
                    color: Colors.blueAccent,
                    text: "SUBMIT",
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        // berhasil, harusnya data tersimpan di collections.
                        createRecord();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        print('failed');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
