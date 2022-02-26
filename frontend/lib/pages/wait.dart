import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';
import 'pages.dart';

import '../helper/ws.dart';
import 'dart:html' as html;

class Wait extends StatefulWidget {
  static const path = "wait";
  const Wait({Key? key}) : super(key: key);

  @override
  State<Wait> createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  var waitState = true;
  var waitText = "Wait";
  var loadState = "";
  var curr = "Wait";

  var startedText = "Both players connected!";

  @override
  void initState() {
    super.initState();
    wait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<WS>(
            builder: ((context, ws, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ws.started ? startedText : curr,
                      style: TextStyle(fontSize: 32),
                    ),
                    SelectableText(
                      "Room code: ${ws.room}",
                      style: TextStyle(fontSize: 18),
                    ),
                    if (ws.started) ...[
                      MenuButton(
                        text: "Begin!",
                        onPressed: () =>
                            Navigator.of(context).pushReplacementNamed(
                          Game.path,
                        ),
                        fontSize: 36,
                      ),
                    ]
                  ],
                ),
              );
            }),
          ),
          ConnectionVisualization(),
        ],
      ),
    );
  }

  void wait() async {
    while (waitState) {
      if (loadState.length == 3) {
        loadState = "";
      }
      loadState += ".";
      setState(() {
        curr = waitText + loadState;
      });
      await Future.delayed(const Duration(seconds: 1), () {});
    }
  }

  @override
  void dispose() {
    waitState = false;
    super.dispose();
  }
}
