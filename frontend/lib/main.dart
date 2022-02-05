import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/pages/game.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'helper/ws.dart';

void main() {
  // var channel = WebSocketChannel.connect(Uri.parse("ws://localhost:3000"));
  // channel.sink.add(jsonEncode({'type': 'join', 'params': {'code': 'ABCDE'}}));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => WS('ws://localhost:3000'),
      child: MaterialApp(
        title: 'Puzzle Attack',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => MyHomePage(
              //channel: WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
              ),
          '/game': (context) => Game(),
        },
        initialRoute: "/",
        // home: MyHomePage(),
        // home: Provider(
        //   create: (_) =>
        //       WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
        //   child: MyHomePage(
        //       //channel: WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
        //       ),
        // ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // final WebSocketChannel channel;
  MyHomePage({
    Key? key,
    /* required this.channel */
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = new TextEditingController();
  var waiting = false;
  String code = '';
  int player = -1;

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    final args = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder(
        stream: ws.stream,
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          print(data);
          if (data != null) {
            print(data["type"]);
            switch (data["type"]) {
              case "init":
                code = data["params"]["code"];
                player = data["params"]["player"];
                waiting = true;
                break;
              case "start":
              print(player);
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed(
                    "/game",
                    arguments: GameArguments(<int>[...data["params"]["field"]], player),
                  );
                });
                break;
              default:
            }
          }
          return Scaffold(
            body: Column(children: [
              if (waiting) ...[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Text('Wait for player to connect'),
                if (code != null) ...[
                  SelectableText("${code}")
                ]
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    ws.sendJSON({
                      'type': 'create',
                      'params': {},
                    });
                  },
                  child: Text("new"),
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type something',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ws.sendJSON({
                      'type': 'join',
                      'params': {'code': '${_controller.text}'}
                    });
                  },
                  child: Text("join"),
                ),
                if (data != null && data["type"] == "init") ...[
                  SelectableText("${data["params"]["code"]}")
                ]
              ],
            ]),
          );
        });
  }
}

// class SocketTest extends StatelessWidget {
//   SocketTest({Key? key}) : super(key: key);

//   var code;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Container(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 print("new");
//               },
//               child: Text("New Game"),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter a search term',
//                 ),
//                 onSubmitted: (text) {
//                   print("Code: $text");
//                   code = text;
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => print("join $code"),
//               child: Text("Join Game"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
