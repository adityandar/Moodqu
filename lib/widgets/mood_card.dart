import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:moodqu_app/constants.dart';
import 'package:moodqu_app/size_config.dart';
import 'package:moodqu_app/screens/write_screen.dart';

class MoodCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function onPressed;
  final Mood id;

  MoodCard({this.color, this.icon, this.onPressed, this.id});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(15.0),
        ),
        lightSource: LightSource.top,
        color: color,
        border: NeumorphicBorder(
          isEnabled: true,
          width: 0.2,
        ),
        depth: 10,
        intensity: 1,
        surfaceIntensity: 0.05,
      ),
      drawSurfaceAboveChild: true,
      padding: EdgeInsets.zero,
      child: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Icon(
                icon,
                size: SizeConfig.blockSizeHorizontal * 25,
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 10.0,
              child: NeumorphicText(
                'HAPPINESS',
                style: NeumorphicStyle(
                  lightSource: LightSource.bottomRight,
                  depth: 4,
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(),
              ),
            ),
          ],
        ),
        width: SizeConfig.blockSizeHorizontal * 30,
        height: SizeConfig.blockSizeHorizontal * 30,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WriteScreen(
              mood: id,
            ),
          ),
        );
      },
    );
  }
}
