import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedProgressButton extends StatefulWidget {
  @override
  _AnimatedProgressButtonState createState() => _AnimatedProgressButtonState();
}

class _AnimatedProgressButtonState extends State<AnimatedProgressButton>
    with SingleTickerProviderStateMixin {
  // Defining Animations and Animation Controller
  Animation<double> _animatedSize;
  Animation<Color> _animatedColor;
  AnimationController _boss;
  bool _loading = false;

  // Initialize Animations and AnimationController
  @override
  void initState() {
    super.initState();
    // AnimationController
    _boss =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    // Animations
    // size using Tween<double>
    _animatedSize = Tween<double>(begin: 0, end: 300).animate(_boss)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _boss.repeat();
        }
      });
    // color using a subclass of Tween, ColorTween
    _animatedColor =
        ColorTween(begin: Colors.yellow, end: Colors.red).animate(_boss);
  }

  // Never forget to dispose the AnimationController
  // to avoid memory leaks
  @override
  void dispose() {
    _boss.dispose();
    super.dispose();
  }

  void submitAction() {
    _boss.forward();
    setState(() {
      _loading = true;
    });
    Timer(Duration(seconds: 2), () {
      _boss.stop();
      _boss.reset();
      setState(() {
        _loading = false;
      });
    });
  }

  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            width: _animatedSize.value,
            height: 5,
            decoration: BoxDecoration(color: _animatedColor.value),
          ),
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: RaisedButton(
              onPressed: _loading ? null : submitAction,
              color: Colors.grey,
              child: Text(
                "Welcome",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              disabledColor: Colors.black,
              disabledElevation: 2.0,
              splashColor: Colors.transparent,
            ),
          )
        ],
      );
}
