import 'package:flutter/material.dart';

class WelcomeViewNoFB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Firebase failed',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
