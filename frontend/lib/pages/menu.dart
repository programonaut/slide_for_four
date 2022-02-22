import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MenuButton(
              text: "Singleplayer",
              onPressed: () => Navigator.of(context).pushNamed(
                GameSP.path,
              ),
              fontSize: 48,
            ),
            MenuButton(
              text: "Multiplayer",
              onPressed: () => Navigator.of(context).pushNamed(
                GameSelect.path,
              ),
              fontSize: 48,
            ),
          ],
        ),
      ),
    );
  }
}
