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
        print("$message");
        if (data["type"] == "connected") {
          print("Reconnected");
          state = WsState.CONNECTED;
        } else if (data["type"] == "disconnected") {
          state = WsState.DISCONNECTED;
        }
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
