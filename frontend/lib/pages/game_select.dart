import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/ws.dart';
import 'pages.dart';

class GameSelect extends StatelessWidget {
  GameSelect({Key? key}) : super(key: key);
  final double width = 200;
  final TextEditingController _controller = TextEditingController();
  static const String path = '/mp-select';

  createGame(ws) {
    ws.sendJSON('create', {});
  }

  joinGame(ws) {
    ws.sendJSON('join', {'code': '${_controller.text}'});
  }

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    ws.connect();

    return Scaffold(
      body: Center(
          child: StreamBuilder(
              stream: ws.stream,
              builder: (context, snapshot) {
                var data = jsonDecode(snapshot.data.toString());
                print(data);
                if (data != null && data["type"] == "init") {
                  var params = data["params"];
                  ws.setInit(params["player"], params["code"]);
                  return waiting(ws);
                } else if (data != null && data["type"] == "start") {
                  WidgetsBinding.instance?.addPostFrameCallback(
                    (_) => Navigator.of(context).pushNamed(
                    Game.path,
                    arguments: GameArguments(<int>[...data["params"]["field"]], data["params"]["player"])
                  ));
                  return waiting(ws);
                } else {
                  return selection(ws);
                }
              })),
    );
  }

  Widget selection(ws) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: () => createGame(ws),
            child: Text("Create Game"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            width: width,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type something',
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: () => joinGame(ws),
            child: Text("Join Game"),
          ),
        ),
      ],
    );
  }

  Widget waiting(ws) {
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
          child: Text('Wait for player to connect'),
        ),
        if (ws.room != null) ...[SelectableText("${ws.room}")]
      ],
    );
  }
}
