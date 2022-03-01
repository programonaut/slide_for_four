import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_puzzle_hack/pages/pages.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';

class NoConnection extends StatelessWidget {
  static const String path = "/no-connection";
  NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "No Connection\nTry again later!",
                style: TextStyle(
                  fontSize: 48,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              MenuButton(
                text: "Back to Menu",
                fontSize: 32,
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                  Menu.path,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static void open(context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(
        NoConnection.path,
      );
    });
  }
}
