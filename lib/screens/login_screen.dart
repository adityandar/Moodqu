import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodqu_app/screens/profile_screen.dart';
import 'package:moodqu_app/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moodqu_app/widgets/normal_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success;
  bool _loading = false;
  String _errMsg = 'Oops, there\'s an error.';
  String _userEmail;

  String email;
  String password;

  Future<bool> login() async {
    User user;
    setState(() {
      _loading = true;
    });
    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim()))
          .user;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errMsg = e.message;
      });
    }
    setState(() {
      _loading = false;
    });
    clear();

    if (user != null) {
      _userEmail = user.email;
      return true;
    } else {
      return false;
    }
  }

  void clear() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your email.';
                      } else {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Your email is not valid.';
                        }
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your password.';
                      } else {
                        if (value.length < 6) {
                          return 'Password should be at least 6 characters.';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  NormalButton(
                    color: Colors.blueAccent,
                    text: "LOG IN",
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _success = await login();

                        print(_emailController.text);
                        if (_success == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        }
                        print(_success);
                        print(_userEmail);
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      _success == null
                          ? ''
                          : (_success
                              ? 'Successfully registed with $_userEmail'
                              : _errMsg),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
