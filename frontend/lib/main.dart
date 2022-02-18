import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/helper/ws.dart';
import 'package:provider/provider.dart';
import 'pages/pages.dart';

void main() {
  runApp(const PuzzleHack());
}

class PuzzleHack extends StatelessWidget {
  const PuzzleHack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WS("ws://localhost:3000"),
      child: MaterialApp(
        title: 'Flutter Puzzle Hack',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          // intial
          Menu.path: (_) => Menu(),
          GameSelect.path: (_) => GameSelect(),
          Game.path: (_) => Game(),
          GameSP.path: (_) => GameSP(),
        },
        initialRoute: Menu.path,
      ),
    );
  }
}