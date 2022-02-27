import 'dart:math';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:flutter/material.dart';

class PlayerToken extends StatefulWidget {
  final int index;
  final bool circle;
  final bool changed;

  PlayerToken({Key? key, required this.index, required this.circle, required this.changed})
      : super(key: key);

  @override
  State<PlayerToken> createState() => _PlayerTokenState();
}

// class _PlayerTokenState extends State<PlayerToken> {
//   late RiveAnimationController _controller;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     // _controller = widget.changed ? SimpleAnimation("show", autoplay: true) : SimpleAnimation("");
//     _loadRiveFile();
//   }

//   _loadRiveFile() async {
//     // Load your Rive data
//     final data = await rootBundle.load('assets/success_check.riv');
//     // Create a RiveFile from the binary data
//     final file = RiveFile();
//     if (file.import(data)) {
//       // Get the artboard containing the animation you want to play
//       final artboard = file.mainArtboard;

//       artboard.addController(
//         _animation = CallbackAnimation(
//           'Untitled',
//           callback: () => setState(() => _isAnimationComplete = true),
//         ),
//       );

//       // Wrapped in setState so the widget knows the artboard is ready to play
//       setState(() => _artboard = artboard);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RiveAnimation.file(widget.circle ? 'assets/circle.riv' : 'assets/cross.riv', controllers: [_controller],);
//   }
// }


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
    return RiveAnimation.asset(widget.circle ? 'animations/circle.riv' : 'animations/cross.riv', controllers: [_controller],);
  }
}