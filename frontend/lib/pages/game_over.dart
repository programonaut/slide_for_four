import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/pages/pages.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class GameOver extends StatelessWidget {
  static const path = "/game-over";
  const GameOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "You are the:",
            style: TextStyle(fontSize: 32),
          ),
          Text(
            ws.winner == ws.player ? "Winner!" : "Looser!",
            style: TextStyle(fontSize: 42),
          ),
          Spacer(),
          MenuButton(
              text: "Back to Menu",
              fontSize: 32,
              onPressed: () {
                ws.sendJSON('disconnect', {});
                ws.reset();
                Navigator.of(context).pushReplacementNamed(
                  GameSelect.path,
                );
              }),
          Spacer(),
        ],
      ),
    ));
  }
}
