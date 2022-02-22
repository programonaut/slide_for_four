import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/helper/ws.dart';
import 'package:google_fonts/google_fonts.dart';
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.gloriaHallelujahTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black,
                ), // If this is not set, then ThemeData.light().textTheme is used.
          ),
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
