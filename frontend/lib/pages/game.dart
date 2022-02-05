import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/helper/ws.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:provider/provider.dart';

class GameArguments {
  final List<int> field;
  final int player;

  GameArguments(this.field, this.player);
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = context.watch<WS>();
    final args = (ModalRoute.of(context)!.settings.arguments as GameArguments);
    var field = args.field;
    print(args.player);
    return Provider.value(
      value: args.player,
      child: StreamBuilder(
        stream: ws.stream,
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          if (data != null && data["params"]["field"] != null)
            field = <int>[...data["params"]["field"]];
          if (data != null && data["type"] == "win") {
            var win = data["params"]["player"];
            return AlertDialog(
              title: Text(args.player == win ? "Winner" : "Looser"),
            );
          }
          return Board(numbers: field);
        },
      ),
    );
  }
}
