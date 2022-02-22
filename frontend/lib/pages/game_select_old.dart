import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/menu_button.dart';
import 'package:provider/provider.dart';
import '../helper/ws.dart';
import 'pages.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Stack(
        children: [
          Center(
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
                  widget = selection(ws);
                }

                return Center(
                  child: widget,
                );
              },
            ),
          ),
          Positioned(
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
            ),
          )
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
          onPressed: () => createGame(ws),
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
          onPressed: () => joinGame(ws),
          text: "Join",
          fontSize: 36,
        ),
        MenuButton(
          onPressed: () => reconnect(ws),
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
