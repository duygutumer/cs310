import 'package:cs310socialmedia/usercard.dart';
import 'package:cs310socialmedia/utils/colors.dart';
import 'package:cs310socialmedia/model/topic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
/*
class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Duration duration = const Duration(milliseconds: 50);
  final double opacity = 0.5;

  TouchableOpacity({@required this.child, this.onTap});

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
      ),
    );
  }
} */
class TopicCard extends StatelessWidget {

  final Topic topic;
  TopicCard({this.topic});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(child: Card(
      //margin: EdgeInsets.symmetric(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: [
                Text( topic.topic,
                  style: TextStyle(
                    fontFamily: 'BrandonText',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
      onTap: (){},
    );
  }
}