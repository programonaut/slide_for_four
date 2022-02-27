import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helper/ai.dart';
import '../helper/ws.dart';
import 'pages.dart';

class GameSP extends StatefulWidget {
  static const path = "/gamesp";
  GameSP({Key? key}) : super(key: key);

  @override
  State<GameSP> createState() => _GameSPState();
}

class _GameSPState extends State<GameSP> {
  var field;
  late Ai ai;

  @override
  void initState() {
    field = [1, 1, 1, 1, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0];
    var ws = context.read<WS>();
    ws.connect();
    ai = Ai("ws://localhost:3000",
        initCallback: (params) =>
            ws.sendJSON("join", {"code": params["code"]}));
    ai.connect();
    ai.sendJSON("create", {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WS>(builder: (context, ws, child) {
        if (ws.gameOver) {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(
              GameOver.path,
            );
          });
        }
        return Board(
            activePlayer: ws.activePlayer == ws.player,
            numbers: ws.field,
            room: ws.room,
            hideRoom: true,
            player: ws.player,
            changes: ws.changes,
            );
      }),
    );
  }
}
