import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class GameSP extends StatefulWidget {
  static const path = "/gamesp";
  GameSP({Key? key}) : super(key: key);

  @override
  State<GameSP> createState() => _GameSPState();
}

class _GameSPState extends State<GameSP> {
  var field;

  @override
  void initState() {
    field = [1, 1, 1, 1, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0];
    field.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Board(numbers: field),
    );
  }
}
