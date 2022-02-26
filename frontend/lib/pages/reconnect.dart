import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/pages/pages.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class Reconnect extends StatefulWidget {
  static const path = "reconnect";
  Reconnect({Key? key}) : super(key: key);

  @override
  State<Reconnect> createState() => _ReconnectState();
}

class _ReconnectState extends State<Reconnect> {
  final TextEditingController _controller = TextEditingController();
  String _text = "";

  reconnectGame(ws) {
    ws.sendJSON('reconnect', {'code': '${_controller.text}'});
  }

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    var width = MediaQuery.of(context).size.width / 4;
    return Material(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    showCursor: false,
                    controller: _controller,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    maxLength: 5,
                    onChanged: (value) {
                      setState(() {
                        _text = value;
                      });
                    },
                  ),
                ),
                MenuButton(
                  text: "Reconnect${_text.length > 0 ? ":" : ""} $_text",
                  onPressed: () { if(_text.length == 5) {
                      Navigator.of(context).pushReplacementNamed(
                        Wait.path,
                      );
                      reconnectGame(ws);
                    } },
                  fontSize: 32,
                )
              ],
            ),
          ),
          ConnectionVisualization(),
        ],
      ),
    );
  }
}
