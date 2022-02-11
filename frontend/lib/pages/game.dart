import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class GameArguments {
  final List<int> field;
  final int player;

  GameArguments(this.field, this.player);
}

class Game extends StatefulWidget {
  static const path = "/game";
  Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var field;

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    final args = (ModalRoute.of(context)!.settings.arguments as GameArguments);
    return StreamBuilder(
      stream: ws.stream,
      builder: (context, snapshot) {
        var data = jsonDecode(snapshot.data.toString());
        print(data);
        if (data != null) {
          if (data["type"] == "turn") {
            field = <int>[...data["params"]["field"]];
          } else if (data["type"] == "win") {
            var win = data["params"]["player"];
            return AlertDialog(
              title: Text(ws.player == win ? "Winner" : "Looser"),
            );
          }
        } else {
          field = args.field;
        }
        return Board(numbers: field);
      },
    );
  }
}
