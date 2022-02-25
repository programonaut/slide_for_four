import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class Wait extends StatefulWidget {
  static const path = "wait";
  const Wait({Key? key}) : super(key: key);

  @override
  State<Wait> createState() => _WaitState();
}

class _WaitState extends State<Wait> {

  var waitText = "Wait";
  var loadState = "";
  var curr;

  var startedText = "Both players connected!";

  @override
  void initState() {
    super.initState();
    wait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WS>(
        builder: ((context, value, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value.started ? startedText : curr, style: TextStyle(fontSize: 32),),
                if (value.started) ...[
                  MenuButton(text: "Begin!", onPressed: () => print("Connect"), fontSize: 36,),
                ]
              ],
            ),
          );
        }),
      ),
    );
  }

  void wait() async {
    while (true) {
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
}
