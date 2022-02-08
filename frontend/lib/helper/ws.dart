import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WS {
  late WebSocketChannel channel;
  late Stream stream;
  late String uri;
  late String room = '';
  late int player = -1;

  WS(this.uri);

  sendJSON(type, params) {
    channel.sink.add(jsonEncode({'type': type, 'params': params}));
  }

  connect() {
    channel = WebSocketChannel.connect(Uri.parse(uri));
    stream = channel.stream.asBroadcastStream();
  }

  setInit(player, room) {
    this.room = room;
    this.player = player;
  }
}