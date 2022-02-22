import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

class Wait extends StatelessWidget {
  static const path = "wait";
  const Wait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    return Container(
      child: Text(ws.started ? "started" : "wait"),
    );
  }
}