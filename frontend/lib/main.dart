import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/helper/ws.dart';
import 'package:flutter_puzzle_hack/pages/wait.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
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
        // routes: {
        //   // intial
        //   Menu.path: (_) => Menu(),
        //   GameSelect.path: (_) => GameSelect(),
        //   Game.path: (_) => Game(),
        //   GameSP.path: (_) => GameSP(),
        //   Wait.path: (_) => Wait(),
        //   Join.path: (_) => Join(),
        //   Reconnect.path: (_) => Reconnect(),
        // },
        onGenerateRoute:(settings) {
          switch (settings.name) {
            case Menu.path: return PageTransition(child: Menu(), type: PageTransitionType.fade);
            case GameSelect.path: return PageTransition(child: GameSelect(), type: PageTransitionType.fade);
            case Game.path: return PageTransition(child: Game(), type: PageTransitionType.fade);
            case GameSP.path: return PageTransition(child: GameSP(), type: PageTransitionType.fade);
            case Wait.path: return PageTransition(child: Wait(), type: PageTransitionType.fade);
            case Join.path: return PageTransition(child: Join(), type: PageTransitionType.fade);
            case Reconnect.path: return PageTransition(child: Reconnect(), type: PageTransitionType.fade);
            default: return PageTransition(child: Menu(), type: PageTransitionType.fade);
          }
        },
        initialRoute: Menu.path,
      ),
    );
  }
}
