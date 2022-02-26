import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/pages/pages.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';
import 'dart:html' as html;

class Join extends StatefulWidget {
  static const path = "join";
  Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController _controller = TextEditingController();
  String _text = "";

  joinGame(ws) {
    ws.sendJSON('join', {'code': '${_controller.text}'});
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
                  text: "Join${_text.length > 0 ? ":" : ""} $_text",
                  onPressed: () {
                    if (_text.length == 5) {
                      joinGame(ws);
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacementNamed(
                          Wait.path,
                        );
                      });
                    }
                  },
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
