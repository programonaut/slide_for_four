import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';
import '../helper/ws.dart';
import 'pages.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/connection_visualization.dart';

class GameSelect extends StatefulWidget {
  GameSelect({Key? key}) : super(key: key);
  static const String path = '/mp-select';

  @override
  State<GameSelect> createState() => _GameSelectState();
}

class _GameSelectState extends State<GameSelect> {
  final double width = 200;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    var ws = context.read<WS>();
    ws.reset();
    ws.connect();
  }

  createGame(ws) {
    ws.sendJSON('create', {});
  }

  joinGame(ws) {
    ws.sendJSON('join', {'code': '${_controller.text}'});
  }

  reconnect(ws) {
    ws.sendJSON('reconnect', {'code': '${_controller.text}'});
  }

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    // Provider.of<WS>(context, listen: false).connect();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: selection(ws),
          ),
          // TODO: only pass the state
          ConnectionVisualization(),
        ],
      ),
    );
  }

  Widget selection(ws) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MenuButton(
          onPressed: () {
            createGame(ws);
            Navigator.of(context).pushNamed(Wait.path);
            },
          text: "Create",
          fontSize: 36,
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   child: SizedBox(
        //     width: width,
        //     child: TextField(
        //       controller: _controller,
        //       decoration: InputDecoration(
        //         hintText: 'Type something',
        //       ),
        //     ),
        //   ),
        // ),
        MenuButton(
          // onPressed: () => joinGame(ws),
          onPressed: () => Navigator.of(context).pushNamed(Join.path),
          text: "Join",
          fontSize: 36,
        ),
        MenuButton(
          onPressed: () => Navigator.of(context).pushNamed(Reconnect.path),
          text: "Reconnect",
          fontSize: 36,
        ),
      ],
    );
  }

  Widget waiting(ws, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          height: 60,
          child: const CircularProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Wait for player to connect',
            style: TextStyle(fontSize: 32),
          ),
        ),
        if (ws.room != null) ...[
          SelectableText(
            "Code: ${ws.room}",
            style: TextStyle(fontSize: 26),
          )
        ],
      ],
    );
  }
}