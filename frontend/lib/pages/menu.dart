import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                  GameSP.path,
                ),
                child: Text("Singleplayer"),
              ),
            ),
            SizedBox(
              height: width / 2,
            ),
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () => 
                  Navigator.of(context).pushNamed(
                    GameSelect.path,
                  ),
                child: Text("Multiplayer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
