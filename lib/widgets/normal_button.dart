import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;
  final int height;

  NormalButton({this.color, this.text, this.onPressed, this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      elevation: 5.0,
      highlightElevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      height: (height != null) ? height : 42,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
