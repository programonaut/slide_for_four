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
  final Function hoverCallback;

  // const MovableToken({Key? key, required this.click, required this.index})
  MovableToken({Key? key, required this.index, required this.hoverCallback})
      : super(key: key);

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
                          hoverCallback: () =>
                              widget.hoverCallback(widget.index - 4),
                          hoverExitCallback: () => widget.hoverCallback(-1),
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
                          hoverCallback: () =>
                              widget.hoverCallback(widget.index - 1),
                          hoverExitCallback: () => widget.hoverCallback(-1),
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
                          hoverCallback: () =>
                              widget.hoverCallback(widget.index + 1),
                          hoverExitCallback: () => widget.hoverCallback(-1),
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
                          hoverCallback: () =>
                              widget.hoverCallback(widget.index + 4),
                          hoverExitCallback: () => widget.hoverCallback(-1),
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
    this.hoverCallback,
    this.hoverExitCallback,
  }) : super(key: key);

  final bool hover;
  final AssetImage img;
  final Function? callback;
  final Function? hoverCallback;
  final Function? hoverExitCallback;

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
          ? () {
              widget.callback!();
              widget.hoverExitCallback!();
            }
          : () => print("Assign a method here!"),
      child: MouseRegion(
          child: Container(
            child: ImageIcon(widget.img, color: col),
          ),
          onEnter: (details) {
            setState(() {
              individualHover = true;
            });
            widget.hoverCallback!();
          },
          onExit: (details) {
            setState(() {
              individualHover = false;
            });
            widget.hoverExitCallback!();
          }),
    );
  }
}
