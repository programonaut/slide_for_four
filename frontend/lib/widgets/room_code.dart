import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class RoomCode extends StatelessWidget {
  const RoomCode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WS>(
      builder: ((context, ws, child) {
        return Tooltip(
          message: "Click to copy",
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: ws.room));
            },
            child: Text(
              "Room code: ${ws.room}",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }),
    );
  }
}