import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_puzzle_hack/helper/config.dart';
import 'package:flutter_puzzle_hack/pages/no_connection.dart';
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
  var waitState = true;
  var waitText = "Loading";
  var loadState = "";
  var curr = "Loading";

  var field;
  late Ai ai;

  @override
  void initState() {
    field = [1, 1, 1, 1, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 0, 0];
    var ws = context.read<WS>();
    // ws.connect();
    ws.reset();

    if (ws.state != WsState.CONNECTED) {
      NoConnection.open(context);
    }

    ai = Ai(address,
        initCallback: (params) =>
            ws.sendJSON("join", {"code": params["code"]}));
    ai.connect();
    ai.reset();
    ai.sendJSON("create", {});

    wait();
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
        if (ws.state == WsState.CONNECTED && ws.field.isEmpty) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                curr,
                style: TextStyle(fontSize: 32),
              ),
            ),
          );
        } else {
          return Board(
            activePlayer: ws.activePlayer == ws.player,
            numbers: ws.field,
            room: ws.room,
            hideRoom: true,
            player: ws.player,
            changes: ws.changes,
          );
        }
      }),
    );
  }

  void wait() async {
    while (waitState) {
      if (loadState.length == 3) {
        loadState = "";
      }
      loadState += ".";
      setState(() {
        curr = waitText + loadState;
      });
      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  @override
  void dispose() {
    waitState = false;
    super.dispose();
  }
}
