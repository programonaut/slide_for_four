import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
    return MaterialApp(
      title: 'Puzzle Attack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => Provider(
              create: (_) =>
                  WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
              child: MyHomePage(
                  //channel: WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
                  ),
            ),
        '/game': (context) => Board(),
      },
      initialRoute: "/",
      // home: Board(),
      // home: Provider(
      //   create: (_) =>
      //       WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
      //   child: MyHomePage(
      //       //channel: WebSocketChannel.connect(Uri.parse("ws://localhost:3000")),
      //       ),
      // ),
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

  @override
  Widget build(BuildContext context) {
    var channel = context.watch<WebSocketChannel>();
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          var data = jsonDecode(snapshot.data.toString());
          print(data);
          return Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(
                    //   "/game",
                    // );
                    channel.sink
                        .add(jsonEncode({'type': 'create', 'params': {}}));
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
                    channel.sink.add(jsonEncode({
                      'type': 'join',
                      'params': {'code': '${_controller.text}'}
                    }));
                  },
                  child: Text("join"),
                ),
                if(data != null && data["type"] == "init")... [
                  Text("${data["params"]["code"]}")
                ]
              ],
            ),
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
