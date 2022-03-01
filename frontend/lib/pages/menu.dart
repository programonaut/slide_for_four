import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';
import '../widgets/menu_button.dart';
import 'pages.dart';

class Menu extends StatelessWidget {
  static const String path = '/';
  final double width = 200;

  Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    ws.reset();
    ws.connect();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 1,),
                Expanded(flex: 3, child: Image(image: AssetImage("assets/images/menu.png"),)),
                Spacer(flex: 1,),
                Expanded(
                  flex: 2, 
                  child: Center(
                    child: MenuButton(
                      text: "Singleplayer",
                      onPressed: () => Navigator.of(context).pushReplacementNamed(
                        GameSP.path,
                      ),
                      fontSize: 48,
                    ),
                  ),
                ),
                Spacer(flex: 1,),
                Expanded(
                  flex: 2, 
                  child: Center(
                    child: MenuButton(
                      text: "Multiplayer",
                      onPressed: () => Navigator.of(context).pushReplacementNamed(
                        GameSelect.path,
                      ),
                      fontSize: 48,
                    ),
                  ),
                ),
                Spacer(flex: 1,),
              ],
            ),
          ),
          ConnectionVisualization(),
        ],
      ),
    );
  }
}
