import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';
import 'menu_button.dart';

class ConnectionVisualization extends StatelessWidget {
  const ConnectionVisualization({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();

    return Consumer<WS>(
      builder: (context, value, child) {
        return Positioned(
        top: 20,
        right: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ws.state == WsState.DISCONNECTED) ...[
              MenuButton(
                onPressed: () => ws.connect(),
                text: "Connect",
                fontSize: 16,
              ),
            ],
            SizedBox.square(
                dimension: 30,
                child: ImageIcon(
                  AssetImage("assets/images/field-circle-1.png"),
                  color: ws.state == WsState.DISCONNECTED
                      ? Colors.red
                      : Colors.green,
                )),
          ],
        ),);
      },
    );
  }
}
