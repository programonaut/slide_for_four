import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WS {
  late WebSocketChannel channel;
  late Stream stream;

  WS(String uri) {
    channel = WebSocketChannel.connect(Uri.parse(uri));
    stream = channel.stream.asBroadcastStream();
  }

  sendJSON(msg) {
    channel.sink.add(jsonEncode(msg));
  }
}