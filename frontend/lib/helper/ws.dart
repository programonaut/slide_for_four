import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WsState { DISCONNECTED, INTERRUPTED, CONNECTED }

class WS extends ChangeNotifier {
  late WebSocketChannel channel;
  late Stream stream;
  late String uri;
  late String room = '';
  late int player = -1;
  late WsState state = WsState.DISCONNECTED;
  late bool started = false;

  WS(this.uri);

  sendJSON(type, params) {
    channel.sink.add(jsonEncode({'type': type, 'params': params}));
  }

  connect() {
    print("connect");
    channel = WebSocketChannel.connect(Uri.parse(uri));
    stream = channel.stream.asBroadcastStream();

    sendJSON("connect", {});

    stream.listen(
      (dynamic message) {
        var data = jsonDecode(message.toString());
        var params = data["params"];
        print("$message");
        switch (data["type"]) {
          case "connected":
            state = WsState.CONNECTED;
            break;
          case "disconnected":
            state = WsState.DISCONNECTED;
            break;
          case "init":
            setInit(params["player"], params["code"]);
            break;
          case "start":
            started = true;
            break;
          default:
        }
        print("notify");
        notifyListeners();
      },
      onDone: () {
        print('ws channel closed');
        state = WsState.DISCONNECTED;
        notifyListeners();
      },
      onError: (error) {
        print('ws error $error');
        state = WsState.DISCONNECTED;
        notifyListeners();
      },
    );

    // notifyListeners();
  }

  setInit(player, room) {
    this.room = room;
    this.player = player;
  }
}
