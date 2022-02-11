import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/ws.dart';
import 'pages.dart';

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
    Provider.of<WS>(context, listen: false).connect();
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
      body: Center(
        child: StreamBuilder(
          stream: Provider.of<WS>(context).stream,
          builder: (context, snapshot) {
            var data = jsonDecode(snapshot.data.toString());
            print("select $data");
            var widget;
            if (data != null && data["type"] == "init") {
              var params = data["params"];
              ws.setInit(params["player"], params["code"]);
              widget = waiting(ws, context);
            } else if (data != null && data["type"] == "start") {
              WidgetsBinding.instance?.addPostFrameCallback((_) =>
                  Navigator.of(context).pushReplacementNamed(Game.path,
                      arguments: GameArguments(
                          <int>[...data["params"]["field"]],
                          data["params"]["player"])));
              widget = waiting(ws, context);
            } else {
              widget =  selection(ws);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget,
                Text("${Provider.of<WS>(context).state}"),
                if (ws.state == WsState.DISCONNECTED) ...[
                  ElevatedButton(
                    onPressed: () => ws.connect(),
                    child: Text("Reconnect"),
                  ),
                ],
              ],
            );
          },
        ),
      ),
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
        SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: () => reconnect(ws),
            child: Text("Reconnect Game"),
          ),
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
          child: Text('Wait for player to connect'),
        ),
        if (ws.room != null) ...[SelectableText("${ws.room}")],
      ],
    );
  }
}
