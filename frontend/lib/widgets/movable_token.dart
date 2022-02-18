import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/ws.dart';

const UP = 1;
const LEFT = 3;
const RIGHT = 5;
const DOWN = 7;

class MovableToken extends StatefulWidget {
  // final Function click;
  final int index;

  // const MovableToken({Key? key, required this.click, required this.index})
  const MovableToken({Key? key, required this.index}) : super(key: key);

  @override
  State<MovableToken> createState() => _MovableTokenState();
}

class _MovableTokenState extends State<MovableToken> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    var player = ws.player;
    return GestureDetector(
      child: MouseRegion(
        child: Container(
          child: Center(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  switch (index) {
                    case UP:
                      return ControlArrow(
                          img: AssetImage(
                              "assets/images/field-navigation-up.png"),
                          hover: hover,
                          callback: () => ws.sendJSON('turn', {
                                'player': player,
                                'index': widget.index,
                                'direction': -4
                              }));

                    case LEFT:
                      return ControlArrow(
                          img: AssetImage(
                              "assets/images/field-navigation-le.png"),
                          hover: hover,
                          callback: () => ws.sendJSON('turn', {
                                'player': player,
                                'index': widget.index,
                                'direction': -1
                              }));

                    case RIGHT:
                      return ControlArrow(
                          img: AssetImage(
                              "assets/images/field-navigation-ri.png"),
                          hover: hover,
                          callback: () => ws.sendJSON('turn', {
                                'player': player,
                                'index': widget.index,
                                'direction': 1
                              }));

                    case DOWN:
                      return ControlArrow(
                          img: AssetImage(
                              "assets/images/field-navigation-do.png"),
                          hover: hover,
                          callback: () => ws.sendJSON('turn', {
                                'player': player,
                                'index': widget.index,
                                'direction': 4
                              }));

                    default:
                      return const SizedBox.shrink();
                  }
                }),
          ),
        ),
        // TODO: rework
        onEnter: (details) => setState(() {
          hover = true;
        }),
        onExit: (details) => setState(() {
          hover = false;
        }),
      ),
      // onTap: () => widget.click(),
    );
  }
}

class ControlArrow extends StatefulWidget {
  const ControlArrow({
    Key? key,
    required this.hover,
    required this.img,
    this.callback,
  }) : super(key: key);

  final bool hover;
  final AssetImage img;
  final Function? callback;

  @override
  State<ControlArrow> createState() => _ControlArrowState();
}

class _ControlArrowState extends State<ControlArrow> {
  bool individualHover = false;

  @override
  Widget build(BuildContext context) {
    Color col = Colors.white;
    if (!widget.hover) {
      col = Colors.transparent;
    } else if (widget.hover && !individualHover) {
      col = Colors.grey;
    } else {
      col = Colors.black;
    }

    return GestureDetector(
      onTap: widget.callback != null
          ? () => widget.callback!()
          : () => print("Assign a method here!"),
      child: MouseRegion(
        child: Container(
          child: ImageIcon(widget.img, color: col),
        ),
        onEnter: (details) => setState(() {
          individualHover = true;
        }),
        onExit: (details) => setState(() {
          individualHover = false;
        }),
      ),
    );
  }
}
