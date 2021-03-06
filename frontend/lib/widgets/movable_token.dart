import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
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
  bool isMobile = false;

  @override
  void initState() {
    super.initState();
    if ( defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      isMobile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var ws = context.read<WS>();
    var player = ws.player;
    return isMobile ? mobile(ws, player) : browser(ws, player);
  }

  Widget mobile(WS ws, int player) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // print("left");
          ws.sendJSON('turn', {
            'player': player,
            'index': widget.index,
            'direction': -1,
          });
        } else {
          // print("right");
          ws.sendJSON('turn', {
            'player': player,
            'index': widget.index,
            'direction': 1,
          });
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // print("up");
          ws.sendJSON('turn', {
            'player': player,
            'index': widget.index,
            'direction': -4,
          });
        } else {
          // print("down");
          ws.sendJSON('turn', {
            'player': player,
            'index': widget.index,
            'direction': 4,
          });
        }
      },
    );
  }

  Widget browser(WS ws, int player) {
    return MouseRegion(
      child: Center(
        child: GridView.builder(
            padding: EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              var i = widget.index;
              bool up = i - 4 >= 0;
              bool left = i != 0 && i != 4 && i != 8 && i != 12;
              bool down = i + 4 < 16;
              bool right = i != 3 && i != 7 && i != 11 && i != 15;
              switch (index) {
                case UP:
                  return !up ? SizedBox.shrink() : ControlArrow(
                      img: AssetImage("assets/images/field-navigation-up.png"),
                      hover: hover || isMobile,
                      hoverCallback: () =>
                          widget.hoverCallback(widget.index - 4),
                      hoverExitCallback: () => widget.hoverCallback(-1),
                      callback: () => ws.sendJSON('turn', {
                            'player': player,
                            'index': widget.index,
                            'direction': -4
                          }));

                case LEFT:
                  return !left ? SizedBox.shrink() : ControlArrow(
                      img: AssetImage("assets/images/field-navigation-le.png"),
                      hover: hover || isMobile,
                      hoverCallback: () =>
                          widget.hoverCallback(widget.index - 1),
                      hoverExitCallback: () => widget.hoverCallback(-1),
                      callback: () => ws.sendJSON('turn', {
                            'player': player,
                            'index': widget.index,
                            'direction': -1
                          }));

                case RIGHT:
                  return !right ? SizedBox.shrink() : ControlArrow(
                      img: AssetImage("assets/images/field-navigation-ri.png"),
                      hover: hover || isMobile,
                      hoverCallback: () =>
                          widget.hoverCallback(widget.index + 1),
                      hoverExitCallback: () => widget.hoverCallback(-1),
                      callback: () => ws.sendJSON('turn', {
                            'player': player,
                            'index': widget.index,
                            'direction': 1
                          }));

                case DOWN:
                  return !down ? SizedBox.shrink() : ControlArrow(
                      img: AssetImage("assets/images/field-navigation-do.png"),
                      hover: hover || isMobile,
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
      onEnter: (details) => setState(() {
        hover = true;
      }),
      onExit: (details) => setState(() {
        hover = false;
      }),
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
