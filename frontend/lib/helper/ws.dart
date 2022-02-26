import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WsState { DISCONNECTED, INTERRUPTED, CONNECTED }

class WS extends ChangeNotifier {
  late WebSocketChannel channel;

  // game init
  late String uri;
  late String room = '';
  late int player = -1;
  
  // game state
  late int activePlayer = -1;
  late WsState state = WsState.DISCONNECTED;
  late bool started = false;
  late List<int> field = [];
  late List<bool> changes = [];
  late bool gameOver = false;
  late int winner = -1;

  WS(this.uri);

  sendJSON(type, params) {
    channel.sink.add(jsonEncode({'type': type, 'params': params}));
  }

  connect() {
    channel = WebSocketChannel.connect(Uri.parse(uri));
    sendJSON("connect", {});

    channel.stream.listen(
      (dynamic message) {
        var data = jsonDecode(message.toString());
        var params = data["params"];
        switch (data["type"]) {
          case "connected":
            state = WsState.CONNECTED;
            break;
          case "disconnected":
            state = WsState.DISCONNECTED;
            break;
          case "init":
            setInit(params);
            break;
          case "start":
            setState(params);
            break;
          case "turn":
            updateState(params);
            break;
          case "win":
            endState(params);
            break;
          default:
        }
        notifyListeners();
      },

      onDone: () {
        state = WsState.DISCONNECTED;
        notifyListeners();
      },
      onError: (error) {
        print('ws error $error');
        state = WsState.DISCONNECTED;
        notifyListeners();
      },
    );
  }

  setInit(params) {
    room = params["code"];
    player = params["player"];
  }

  setState(params) {
    field = <int>[...params["field"]];
    activePlayer = params["player"];
    started = true;

    List<int> fixedList = Iterable<int>.generate(field.length).toList();

    changes = fixedList.map((i) => true).toList();
  }

  updateState(params) {
    var newField = <int>[...params["field"]];
    List<int> fixedList = Iterable<int>.generate(field.length).toList();

    changes = fixedList.map((i) => field[i] != newField[i]).toList();
    field = newField;
    activePlayer = params["player"];
  }

  endState(params) {
    gameOver = true;
    winner = params["player"];
  }

  reset() {
    room = "";
    player = -1;
    activePlayer = -1;
    started = false;
    field = [];
    gameOver = false;
    winner = -1;
  }
}
