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
            Spacer(flex: 1,),
            Expanded(flex: 3, child: Image(image: AssetImage("assets/images/menu.png"),)),
            Spacer(flex: 1,),
            Expanded(
              flex: 2, 
              child: Center(
                child: MenuButton(
                  text: "Singleplayer",
                  onPressed: () => Navigator.of(context).pushNamed(
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
                  onPressed: () => Navigator.of(context).pushNamed(
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
    );
  }
}
