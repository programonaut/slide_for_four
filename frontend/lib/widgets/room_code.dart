import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
              Clipboard.setData(ClipboardData(text: ws.room)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Room code copied to clipboard!",
                    style: GoogleFonts.gloriaHallelujah(color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ));
              });
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
