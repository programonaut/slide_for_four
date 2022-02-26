import 'dart:math';
import 'package:rive/rive.dart';

import 'package:flutter/material.dart';

class PlayerToken extends StatefulWidget {
  final int index;
  final bool circle;
  final bool changed;

  const PlayerToken({Key? key, required this.index, required this.circle, required this.changed})
      : super(key: key);

  @override
  State<PlayerToken> createState() => _PlayerTokenState();
}

class _PlayerTokenState extends State<PlayerToken> {
  late RiveAnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.changed ? SimpleAnimation("show", autoplay: true) : SimpleAnimation("");
  }


  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(widget.circle ? 'circle.riv' : 'cross.riv', controllers: [_controller],);
  }
}
